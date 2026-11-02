import test from "node:test";
import assert from "node:assert/strict";
import { readFile, readdir } from "node:fs/promises";
import { PGlite } from "@electric-sql/pglite";
import { createServer } from "node:http";
import { once } from "node:events";
import { maakPubliekeBijlageHandler, ZOEK_ACTIEVE_BESTANDSBIJLAGE } from "../netlify/lib/publieke-bijlage.mjs";
import { isPubliekeBijlageAanvraag, publiekeBijlageId } from "../netlify/lib/agent-access.mjs";
import { geldigeBijlageUrl } from "../netlify/lib/tekstregels.mjs";
import { leesAgentRijen, bouwAgentSnapshot } from "../netlify/lib/agent-export.mjs";
import { maakAgentHandler } from "../netlify/lib/agent-handler.mjs";
import edge from "../netlify/edge-functions/wachtwoord.js";
import { controleerAgentWebsite } from "../tools/check-agent-export.mjs";
import { TOKEN } from "./fixtures.mjs";

const req = (path, method = "GET", headers = {}) => new Request(`https://kennisbank.example${path}`, { method, headers });
const SLEUTEL_V1 = "bestanden/20261101-11111111-1111-1111-1111-111111111111";
const SLEUTEL_V2 = "bestanden/20261102-22222222-2222-2222-2222-222222222222";
const SLEUTEL_CONCEPT = "bestanden/20261102-33333333-3333-3333-3333-333333333333";
const PDF = (tekst) => new TextEncoder().encode(`%PDF-${tekst}`);

test("bijlage-ID uit het pad: alleen het juiste prefix en formaat, hoofdletterongevoelig", () => {
  const id = (path) => publiekeBijlageId(new URL(`https://x${path}`));
  assert.equal(id("/api/publiek/bijlage/H01-B01"), "H01-B01");
  assert.equal(id("/api/publiek/bijlage/h01-b01"), "H01-B01");
  assert.equal(id("/api/publiek/bijlage/H01-B123"), "H01-B123");
  for (const path of ["/api/publiek/bijlage/", "/api/publiek/bijlage/H01", "/api/publiek/bijlage/H01-P01",
    "/api/publiek/bijlage/H01-B01/extra", "/api/publiek/bijlage/bestanden%2Fx", "/api/publiek/bijlage/%ZZ",
    "/api/bestand?sleutel=H01-B01", "/api/publiek/bijlageH01-B01"]) {
    assert.equal(id(path), null, path);
  }
  assert.equal(isPubliekeBijlageAanvraag(new URL("https://x/api/publiek/bijlage/anything")), true);
  assert.equal(isPubliekeBijlageAanvraag(new URL("https://x/api/publiek/bijlage")), false);
});

test("linkbijlagen: alleen https, zodat de export nooit op een link stukloopt", () => {
  assert.equal(geldigeBijlageUrl("https://example.org/doc"), true);
  for (const url of ["http://example.org", "ftp://example.org", "javascript:alert(1)", "example.org", "", null, undefined, 42]) {
    assert.equal(geldigeBijlageUrl(url), false, String(url));
  }
});

test("publieke route: alleen actieve goedgekeurde bestandsbijlagen, zelfde link na vervanging, 404 na vervallen", async () => {
  const database = new PGlite();
  const blobs = new Map([[SLEUTEL_V1, PDF("v1")], [SLEUTEL_V2, PDF("v2!!")], [SLEUTEL_CONCEPT, PDF("concept")]]);
  let gelogd = 0;
  const handler = maakPubliekeBijlageHandler({
    zoekBijlage: async (id) => (await database.query(ZOEK_ACTIEVE_BESTANDSBIJLAGE, [id])).rows[0] || null,
    leesBestand: async (sleutel) => blobs.has(sleutel) ? blobs.get(sleutel).buffer.slice(0) : null,
    logError: () => { gelogd++; },
  });
  try {
    const migrations = new URL("../netlify/database/migrations/", import.meta.url);
    for (const name of (await readdir(migrations)).filter((n) => n.endsWith(".sql")).sort()) {
      await database.exec(await readFile(new URL(name, migrations), "utf8"));
    }
    const voorstel = async (status, sleutel) => (await database.query(`
      INSERT INTO voorstel (soort, status, hoofdstuk_id, wat, waarom, bron, auteur, bijlage_soort, bijlage_titel,
                            bijlage_omschrijving, bijlage_datum, bestand_sleutel, bestandsnaam, bestand_mime, bestand_grootte)
      VALUES ('bijlage_toevoegen', $1, 'H02', 'Template', 'Test', 'Test', 'Paul Baans', 'template', 'Rekenschema',
              'Sjabloon', '2026-11-01', $2, 'rekenschema.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', $3)
      RETURNING id`, [status, sleutel, blobs.get(sleutel).byteLength])).rows[0].id;
    const bijlage = async (voorstelId, sleutel, soort = "template", vervangt = null) => (await database.query(`
      INSERT INTO bijlage (bijlage_id, hoofdstuk_id, soort, titel, omschrijving, datum, url, bestand_sleutel, bestandsnaam,
                           bestand_mime, bestand_grootte, status, voorstel_id, auteur, goedgekeurd_door, goedgekeurd_op, vervangt_id)
      VALUES ('H02-B01', 'H02', $1, 'Rekenschema', 'Sjabloon', '2026-11-01', $2, $3, 'rekenschema.xlsx',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', $4, 'actief', $5, 'Paul Baans', 'Ron Stieding', '2026-11-01', $6)
      RETURNING id`, [soort, soort === "link" ? "https://example.org/x" : null, soort === "link" ? null : sleutel,
      soort === "link" ? null : blobs.get(sleutel).byteLength, voorstelId, vervangt])).rows[0].id;

    // Nog niets goedgekeurd: alleen een concept met een geüpload bestand.
    await voorstel("concept", SLEUTEL_CONCEPT);
    const conceptAntwoord = await handler(req("/api/publiek/bijlage/H02-B01"));
    assert.equal(conceptAntwoord.status, 404, "een bestand dat alleen bij een voorstel hoort, is niet publiek");
    assert.equal(conceptAntwoord.headers.get("cache-control"), "private, no-store");

    // Goedgekeurde bijlage (rij in `bijlage`): publiek, met de juiste headers en bytes.
    // De koppelrij in `voorstel` krijgt hier 'ter_validatie'; de status van het voorstel speelt geen rol
    // voor de route, alleen de rij in `bijlage` telt.
    const rij1 = await bijlage(await voorstel("ter_validatie", SLEUTEL_V1), SLEUTEL_V1);
    const ok = await handler(req("/api/publiek/bijlage/h02-b01"));
    assert.equal(ok.status, 200);
    assert.equal(ok.headers.get("content-type"), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
    assert.match(ok.headers.get("content-disposition"), /^attachment; filename="rekenschema\.xlsx"; filename\*=UTF-8''rekenschema\.xlsx$/);
    assert.equal(ok.headers.get("cache-control"), "private, no-store");
    assert.equal(ok.headers.get("x-robots-tag"), "noindex, nofollow");
    assert.equal(new TextDecoder().decode(await ok.arrayBuffer()), "%PDF-v1");
    for (const [path, method, status] of [
      ["/api/publiek/bijlage/H02-B01", "POST", 405], ["/api/publiek/bijlage/H02-B01", "HEAD", 405],
      ["/api/publiek/bijlage/H02-B02", "GET", 404], ["/api/publiek/bijlage/H99-B01", "GET", 404],
      ["/api/publiek/bijlage/bestanden%2F20261101-11111111-1111-1111-1111-111111111111", "GET", 404],
    ]) {
      assert.equal((await handler(req(path, method))).status, status, `${method} ${path}`);
    }
    assert.equal((await handler(req("/api/publiek/bijlage/H02-B01", "POST"))).headers.get("allow"), "GET");

    // Vervanging: nieuwe revisie, oude vervalt. Zelfde link, nieuw bestand; de oude bytes zijn weg.
    await database.query("UPDATE bijlage SET status = 'vervallen' WHERE id = $1", [rij1]);
    await bijlage(await voorstel("ter_validatie", SLEUTEL_V2), SLEUTEL_V2, "template", rij1);
    const v2 = await handler(req("/api/publiek/bijlage/H02-B01"));
    assert.equal(v2.status, 200);
    assert.equal(new TextDecoder().decode(await v2.arrayBuffer()), "%PDF-v2!!");

    // Export: publieke link staat erin, relatief, en verandert niet door de vervanging.
    const pool = { connect: async () => ({ query: (sql, params) => database.query(sql, params), release: () => {} }) };
    const bestandscontrole = async (sleutel) => ({ sha256: "a".repeat(64), size: blobs.get(sleutel).byteLength,
      mime: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" });
    const snapshot = await bouwAgentSnapshot(await leesAgentRijen(pool), bestandscontrole);
    const h02 = snapshot.exported.chapters.find((h) => h.id === "H02");
    assert.deepEqual(h02.attachments.map((b) => [b.id, b.access, b.public_url]), [["H02-B01", "public", "/api/publiek/bijlage/H02-B01"]]);
    assert.equal(JSON.stringify(snapshot.exported).includes(SLEUTEL_CONCEPT), false, "conceptbestanden staan niet in de export");

    // Volledige lokale keten: Edge laat de publieke route door, controlescript haalt de public_url zonder token op.
    const agent = maakAgentHandler({ getToken: () => TOKEN,
      getSnapshot: async () => bouwAgentSnapshot(await leesAgentRijen(pool), bestandscontrole) });
    const oldNetlify = globalThis.Netlify;
    globalThis.Netlify = { env: { get: (name) => name === "KNOWLEDGE_SYNC_TOKEN" ? TOKEN : "browser-password" } };
    const server = createServer(async (incoming, outgoing) => {
      try {
        const request = new Request(`http://127.0.0.1${incoming.url}`, { method: incoming.method, headers: incoming.headers });
        const response = (await edge(request))
          || (isPubliekeBijlageAanvraag(new URL(request.url)) ? await handler(request) : await agent(request));
        outgoing.writeHead(response.status, Object.fromEntries(response.headers));
        outgoing.end(Buffer.from(await response.arrayBuffer()));
      } catch { outgoing.writeHead(500).end(); }
    });
    try {
      server.listen(0, "127.0.0.1");
      await once(server, "listening");
      const checked = await controleerAgentWebsite(`http://127.0.0.1:${server.address().port}`, TOKEN);
      assert.equal(checked.public_attachments, 1);
    } finally {
      server.closeAllConnections();
      await new Promise((resolve) => server.close(resolve));
      globalThis.Netlify = oldNetlify;
    }

    // Vervallen zonder opvolger: link is dood, en de export toont de bijlage niet meer.
    await database.query("UPDATE bijlage SET status = 'vervallen' WHERE bijlage_id = 'H02-B01' AND status = 'actief'");
    assert.equal((await handler(req("/api/publiek/bijlage/H02-B01"))).status, 404);
    const zonder = await bouwAgentSnapshot(await leesAgentRijen(pool), bestandscontrole);
    assert.equal(zonder.exported.chapters.find((h) => h.id === "H02").attachments.length, 0);
    assert.notEqual(zonder.manifest.snapshot_id, snapshot.manifest.snapshot_id);

    // Een linkbijlage is nooit via de publieke route te halen.
    await bijlage(await voorstel("ter_validatie", SLEUTEL_V2), SLEUTEL_V2, "link");
    assert.equal((await handler(req("/api/publiek/bijlage/H02-B01"))).status, 404);

    // Bestand weg uit de opslag of andere grootte: geen levering, wel gelogd.
    await database.query("UPDATE bijlage SET status = 'vervallen' WHERE bijlage_id = 'H02-B01' AND status = 'actief'");
    await bijlage(await voorstel("ter_validatie", SLEUTEL_V1), SLEUTEL_V1);
    blobs.set(SLEUTEL_V1, PDF("langer-dan-vastgelegd"));
    assert.equal((await handler(req("/api/publiek/bijlage/H02-B01"))).status, 404);
    blobs.delete(SLEUTEL_V1);
    assert.equal((await handler(req("/api/publiek/bijlage/H02-B01"))).status, 404);
    assert.equal(gelogd, 2);
  } finally { await database.close(); }
});

test("databasefout wordt een 503 zonder details", async () => {
  const handler = maakPubliekeBijlageHandler({
    zoekBijlage: async () => { throw new Error("connection string with secrets"); },
    leesBestand: async () => null, logError: () => {},
  });
  const antwoord = await handler(req("/api/publiek/bijlage/H01-B01"));
  assert.equal(antwoord.status, 503);
  assert.equal((await antwoord.text()).includes("secrets"), false);
});
