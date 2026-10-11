import test from "node:test";
import assert from "node:assert/strict";
import { bouwAgentSnapshot, canoniek, hash, leesAgentRijen } from "../netlify/lib/agent-export.mjs";
import { maakBestandscontrole } from "../netlify/lib/agent-files.mjs";
import { rijen, bestand, fileInfo, FILE_KEY } from "./fixtures.mjs";

test("snapshot is deterministisch en bewaart brontekst letterlijk", async () => {
  const data = rijen();
  const a = await bouwAgentSnapshot(data);
  data.paragrafen.reverse();
  const b = await bouwAgentSnapshot(data);
  assert.deepEqual(a, b);
  assert.equal(a.exported.chapters[0].sections[0].body, data.paragrafen[1].tekst);
  assert.equal(a.manifest.chapter_count, a.manifest.chapters.length);
  assert.equal(a.manifest.chapters[0].section_count, 2);
  assert.equal(a.manifest.chapters[0].sections, undefined);
  assert.equal(a.manifest.snapshot_id, a.exported.snapshot_id);
  const { snapshot_id, ...payload } = a.exported;
  assert.equal(hash(payload), snapshot_id);
  assert.equal(canoniek({ z: 1, a: { b: 2, a: 3 } }), canoniek({ a: { a: 3, b: 2 }, z: 1 }));
  assert.throws(() => hash({ invalid: undefined }));
});

test("tekst, titel, volgorde, bronnen, verwijdering en reviewmetadata veranderen de juiste hashes", async () => {
  const baseline = await bouwAgentSnapshot(rijen());
  for (const change of [
    (r) => { r.paragrafen[0].tekst += "\nNieuw"; },
    (r) => { r.paragrafen[0].titel += " gewijzigd"; },
    (r) => { r.paragrafen[0].bronnen = "[]"; },
    (r) => { r.versies[0].titel += " gewijzigd"; },
    (r) => { [r.paragrafen[0].volgorde, r.paragrafen[1].volgorde] = [1, 0]; },
    (r) => { r.paragrafen.pop(); },
  ]) {
    const data = rijen(); change(data);
    const changed = await bouwAgentSnapshot(data);
    assert.notEqual(changed.manifest.snapshot_id, baseline.manifest.snapshot_id);
    assert.notEqual(changed.manifest.chapters[0].content_hash, baseline.manifest.chapters[0].content_hash);
  }
  for (const change of [
    (r) => { r.paragrafen[0].reviewdatum = "2028-10-08"; },
    (r) => { r.versies[0].id = 2; r.versies[0].versie = "1.1"; r.paragrafen.forEach((p) => p.hoofdstuk_versie_id = 2); },
  ]) {
    const data = rijen(); change(data);
    const changed = await bouwAgentSnapshot(data);
    assert.notEqual(changed.manifest.snapshot_id, baseline.manifest.snapshot_id);
    assert.notEqual(changed.manifest.chapters[0].metadata_hash, baseline.manifest.chapters[0].metadata_hash);
    assert.equal(changed.manifest.chapters[0].content_hash, baseline.manifest.chapters[0].content_hash);
  }
});

test("export weigert lege, halflege, niet-goedgekeurde en beschadigde data", async () => {
  for (const change of [
    (r) => { r.versies = []; }, (r) => { r.paragrafen = []; },
    (r) => { r.versies[0].status = "concept"; },
    (r) => { r.versies[0].goedgekeurd_op = null; },
    (r) => { r.paragrafen[0].reviewdatum = "2026-02-30"; },
    (r) => { r.paragrafen[0].bronnen = "broken json"; },
    (r) => { r.paragrafen[0].bronnen = "{}"; },
    (r) => { r.paragrafen[0].hoofdstuk_versie_id = 999; },
    (r) => { r.paragrafen.push({ ...r.paragrafen[0] }); },
    (r) => { r.bijlagen = [{ ...bestand(), hoofdstuk_id: "H99" }]; },
  ]) {
    const data = rijen(); change(data);
    await assert.rejects(() => bouwAgentSnapshot(data, fileInfo));
  }
});

test("bijlageversie, hash en metadata tellen mee; bestanden blijven privé", async () => {
  const data = rijen(); data.bijlagen.push(bestand());
  const original = await bouwAgentSnapshot(data, fileInfo);
  const attachment = original.exported.chapters[0].attachments[0];
  assert.equal(attachment.revision_id, 1);
  assert.equal(attachment.access, "editor_session_required");
  assert.equal(attachment.file.content_hash, `sha256:${"a".repeat(64)}`);
  for (const change of [
    (r) => { r.bijlagen[0].id++; },
    (r) => { r.bijlagen[0].titel += " aangepast"; },
    (r) => { r.bijlagen = []; },
  ]) {
    const changed = structuredClone(data); change(changed);
    assert.notEqual((await bouwAgentSnapshot(changed, fileInfo)).manifest.snapshot_id, original.manifest.snapshot_id);
  }
  assert.notEqual((await bouwAgentSnapshot(data, async () => ({ ...(await fileInfo()), sha256: "b".repeat(64) }))).manifest.snapshot_id, original.manifest.snapshot_id);
  await assert.rejects(() => bouwAgentSnapshot(data, async () => null));
  await assert.rejects(() => bouwAgentSnapshot(data, async () => ({ ...(await fileInfo()), size: 999 })));
  await assert.rejects(() => bouwAgentSnapshot(data, async () => { throw new Error("unavailable"); }));
  data.bijlagen = [{ ...bestand(), soort: "link", url: "https://example.org" }];
  const linked = await bouwAgentSnapshot(data, async () => { throw new Error("Mag geen externe links ophalen"); });
  assert.equal(linked.exported.chapters[0].attachments[0].file, null);
  data.bijlagen[0].url = "javascript:alert(1)";
  await assert.rejects(() => bouwAgentSnapshot(data));
});

test("alle leesqueries gebruiken dezelfde read-only transactie; rollback en release bij fouten", async () => {
  for (const failAt of [null, 0, 1, 2, 3, 4]) {
    const queries = []; let released = false; let connected = 0;
    const pool = { connect: async () => { connected++; return {
      query: async (sql) => { const i = queries.length; queries.push(sql); if (i === failAt) throw new Error("query failed"); return { rows: [] }; },
      release: () => { released = true; },
    }; } };
    if (failAt === null) await leesAgentRijen(pool);
    else await assert.rejects(() => leesAgentRijen(pool));
    assert.equal(connected, 1);
    assert.equal(queries[0], "BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY");
    assert.equal(queries.at(-1), failAt === null ? "COMMIT" : "ROLLBACK");
    assert.equal(released, true);
  }
});

test("oude bijlagen krijgen een echte bytehash; cache volgt ETag; nieuwe uploads gebruiken metadata", async () => {
  let reads = 0; let etag = "v1"; let sha256;
  const metadata = () => ({ grootte: 4, mime: "application/pdf", ...(sha256 ? { sha256 } : {}) });
  const store = {
    getMetadata: async () => ({ etag, metadata: metadata() }),
    getWithMetadata: async () => { reads++; return { etag, metadata: metadata(), data: new TextEncoder().encode("%PDF").buffer }; },
  };
  const check = maakBestandscontrole(() => store);
  const first = await check(FILE_KEY);
  assert.match(first.sha256, /^[a-f0-9]{64}$/);
  assert.deepEqual(await check(FILE_KEY), first);
  assert.equal(reads, 1);
  etag = "v2";
  await check(FILE_KEY);
  assert.equal(reads, 2);
  sha256 = "a".repeat(64);
  assert.equal((await check(FILE_KEY)).sha256, sha256);
  assert.equal(reads, 2);
  await assert.rejects(() => check("not-a-key"));
  store.getMetadata = async () => null;
  await assert.rejects(() => check(FILE_KEY));
});

test("ontbrekende, te grote of tijdens ophalen gewijzigde blobs worden geweigerd", async () => {
  for (const [size, blob] of [
    [0, null], [6 * 1024 * 1024, null], [4, null],
    [4, { etag: "v2", data: new ArrayBuffer(4) }],
    [4, { etag: "v1", data: new ArrayBuffer(3) }],
  ]) {
    const check = maakBestandscontrole(() => ({
      getMetadata: async () => ({ etag: "v1", metadata: { grootte: size, mime: "application/pdf" } }),
      getWithMetadata: async () => blob,
    }));
    await assert.rejects(() => check(FILE_KEY));
  }
});
