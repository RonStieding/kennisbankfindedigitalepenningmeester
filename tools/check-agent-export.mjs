// Read-only controle voor een uitgerolde preview/productie; print nooit content of tokens.
import assert from "node:assert/strict";
import { pathToFileURL } from "node:url";
import { hash } from "../netlify/lib/agent-export.mjs";

export async function controleerAgentWebsite(baseUrl, token) {
  const base = new URL(baseUrl);
  assert.ok(base.protocol === "https:" || (base.protocol === "http:" && ["localhost", "127.0.0.1", "[::1]"].includes(base.hostname)), "Gebruik HTTPS (HTTP alleen lokaal)");
  assert.ok(!base.username && !base.password && !base.search && !base.hash && base.pathname === "/", "Gebruik alleen de oorsprong van de site, zonder credentials, pad of query");
  assert.match(token || "", /^[A-Za-z0-9_-]{32,256}$/, "KNOWLEDGE_SYNC_TOKEN ontbreekt of is ongeldig");
  const auth = { Authorization: `Bearer ${token}` };
  const request = (path, headers = auth, method = "GET") => fetch(new URL(path, base), {
    method, headers, redirect: "error", signal: AbortSignal.timeout(20000),
  });
  const leesJson = async (response) => {
    assert.match(response.headers.get("content-type") || "", /^application\/json\b/, "Geen JSON: controleer Netlify Visitor Access");
    return response.json();
  };

  const unauthorized = await request("/api/agent/manifest", {});
  assert.equal(unauthorized.status, 401, "Zonder token moet de agentroute 401 geven");
  const manifestResponse = await request("/api/agent/manifest");
  assert.equal(manifestResponse.status, 200, "Manifest niet bereikbaar; controleer beide tokenscopes en platformtoegang");
  const manifest = await leesJson(manifestResponse);
  assert.equal(manifest.complete, true);
  assert.equal(manifest.schema_version, 1);
  assert.equal(manifest.source_id, "fin-kennisbank");
  assert.equal(manifest.chapter_count, manifest.chapters.length);
  assert.ok(manifest.chapter_count > 0);
  assert.equal(new Set(manifest.chapters.map((h) => h.id)).size, manifest.chapter_count);
  const etag = manifestResponse.headers.get("etag");
  assert.ok(etag);
  // Netlify's edge plakt bij compressie een achtervoegsel aan de ETag (bijvoorbeeld "-df"), voert de
  // If-None-Match-vergelijking zelf uit met de kale ETag van de function en geeft een variant met
  // achtervoegsel nooit door. Een afnemer stuurt daarom altijd de kale vorm terug (zie docs/agent-api.md).
  const kaleEtag = etag.replace(/^(?:W\/)?("manifest-v1-sha256:[a-f0-9]{64})(?:-[A-Za-z0-9]+)?"$/, '$1"');
  assert.equal(kaleEtag, `"manifest-v1-${manifest.snapshot_id}"`, "ETag hoort niet bij de snapshot_id van het manifest");
  const unchanged = await request("/api/agent/manifest", { ...auth, "If-None-Match": kaleEtag });
  assert.equal(unchanged.status, 304, "Bron gewijzigd tijdens controle? Voer opnieuw uit");
  assert.equal(await unchanged.text(), "");
  const exp = await request(`/api/agent/export?snapshot_id=${encodeURIComponent(manifest.snapshot_id)}`);
  assert.equal(exp.status, 200, "Bron gewijzigd tijdens controle? Voer opnieuw uit");
  const exported = await leesJson(exp);
  const { snapshot_id, ...payload } = exported;
  assert.equal(snapshot_id, manifest.snapshot_id);
  assert.equal(hash(payload), snapshot_id, "Exporthash klopt niet");
  assert.equal(exported.chapters.length, manifest.chapter_count);
  for (const h of exported.chapters) {
    const entry = manifest.chapters.find((m) => m.id === h.id);
    assert.ok(entry);
    assert.equal(entry.content_hash, h.content_hash);
    assert.equal(entry.metadata_hash, h.metadata_hash);
    assert.equal(entry.section_count, h.sections.length);
    assert.equal(entry.attachment_count, h.attachments.length);
  }
  const wrongSnapshot = `sha256:${"0".repeat(64)}`;
  assert.equal((await request(`/api/agent/export?snapshot_id=${wrongSnapshot}`)).status, 409);
  assert.equal((await request("/api/agent/export", auth, "POST")).status, 405);
  assert.equal((await request("/api/voorstellen")).status, 401, "Agenttoken mag geen redactietoegang geven");
  assert.equal((await request("/api/agent/manifest", { "If-None-Match": etag })).status, 401);

  // Publieke bijlagen: elke public_url werkt zonder token; de redactieroute blijft dicht.
  let publiek = 0;
  for (const h of exported.chapters) {
    for (const b of h.attachments) {
      if (b.external) { assert.equal(b.public_url, undefined, `${b.id}: links hebben geen public_url`); continue; }
      assert.equal(b.access, "public", `${b.id}: bestandsbijlage hoort publiek te zijn`);
      assert.equal(b.public_url, `/api/publiek/bijlage/${b.id}`, `${b.id}: public_url wijkt af`);
      const download = await request(b.public_url, {});
      assert.equal(download.status, 200, `${b.id}: publieke download mislukt`);
      assert.match(download.headers.get("content-disposition") || "", /^attachment;/, `${b.id}: geen attachment`);
      assert.equal(download.headers.get("content-type"), b.file.mime, `${b.id}: MIME wijkt af`);
      assert.equal((await download.arrayBuffer()).byteLength, b.file.size, `${b.id}: grootte wijkt af`);
      assert.equal((await request(b.url, {})).status, 401, `${b.id}: redactieroute moet zonder login dicht blijven`);
      publiek++;
    }
  }
  assert.equal((await request("/api/publiek/bijlage/H99-B99", {})).status, 404, "Onbekende bijlage moet 404 geven");
  assert.equal((await request("/api/publiek/bijlage/H99-B99", {}, "POST")).status, 405);
  return { chapter_count: manifest.chapter_count, snapshot_id, public_attachments: publiek };
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    const result = await controleerAgentWebsite(process.env.KNOWLEDGE_SYNC_URL, process.env.KNOWLEDGE_SYNC_TOKEN);
    console.log(`Agentexport gecontroleerd: ${result.chapter_count} hoofdstukken, ${result.public_attachments} publieke bijlagen; authenticatie, hashes, 304, 409 en publieke downloads kloppen.`);
  } catch (error) {
    console.error(`Agentcontrole mislukt: ${error.message}`);
    process.exitCode = 1;
  }
}
