import test from "node:test";
import assert from "node:assert/strict";
import { readFile, readdir } from "node:fs/promises";
import { PGlite } from "@electric-sql/pglite";
import { createServer } from "node:http";
import { once } from "node:events";
import { leesAgentRijen, bouwAgentSnapshot } from "../netlify/lib/agent-export.mjs";
import { maakAgentHandler } from "../netlify/lib/agent-handler.mjs";
import edge from "../netlify/edge-functions/wachtwoord.js";
import { controleerAgentWebsite } from "../tools/check-agent-export.mjs";
import { TOKEN } from "./fixtures.mjs";

test("echte Postgres-query op alle migraties: alleen nieuwste goedgekeurde versies en actieve bijlagen", async () => {
  const database = new PGlite();
  let released = 0;
  const pool = { connect: async () => ({
    query: (sql, params) => database.query(sql, params), release: () => { released++; },
  }) };
  try {
    const migrations = new URL("../netlify/database/migrations/", import.meta.url);
    for (const name of (await readdir(migrations)).filter((n) => n.endsWith(".sql")).sort()) {
      await database.exec(await readFile(new URL(name, migrations), "utf8"));
    }
    const original = await bouwAgentSnapshot(await leesAgentRijen(pool));
    assert.equal(original.manifest.chapter_count, 13);
    assert.equal(released, 1);
    // Echte lokale HTTP-keten: Edge-auth -> handler -> database -> JSON -> clientcheck.
    const handler = maakAgentHandler({ getToken: () => TOKEN,
      getSnapshot: async () => bouwAgentSnapshot(await leesAgentRijen(pool)) });
    const oldNetlify = globalThis.Netlify;
    globalThis.Netlify = { env: { get: (name) => name === "KNOWLEDGE_SYNC_TOKEN" ? TOKEN : "browser-password" } };
    const server = createServer(async (incoming, outgoing) => {
      try {
        const request = new Request(`http://127.0.0.1${incoming.url}`, { method: incoming.method, headers: incoming.headers });
        const response = (await edge(request)) || (await handler(request));
        outgoing.writeHead(response.status, Object.fromEntries(response.headers));
        outgoing.end(Buffer.from(await response.arrayBuffer()));
      } catch { outgoing.writeHead(500).end(); }
    });
    try {
      server.listen(0, "127.0.0.1");
      await once(server, "listening");
      const checked = await controleerAgentWebsite(`http://127.0.0.1:${server.address().port}`, TOKEN);
      assert.equal(checked.snapshot_id, original.manifest.snapshot_id);
    } finally {
      server.closeAllConnections();
      await new Promise((resolve) => server.close(resolve));
      globalThis.Netlify = oldNetlify;
    }
    const paragraphs = (await database.query("SELECT paragraaf_id, tekst FROM paragraaf")).rows;
    const sections = original.exported.chapters.flatMap((h) => h.sections);
    assert.equal(sections.length, paragraphs.length);
    for (const paragraph of paragraphs) {
      assert.equal(sections.find((s) => s.id === paragraph.paragraaf_id).body, paragraph.tekst);
    }
    const draft = (await database.query(`
      INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, versiedatum, auteur)
      VALUES ('H01', '1.1', 'concept', 'Nieuwe titel', 'Nieuw', '2026-10-08', 'Auteur') RETURNING id`)).rows[0];
    await database.query(`
      INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, titel, tekst, reviewdatum, controlegetal)
      VALUES ($1, 'H01-P00', 0, 'inleiding', 'Nieuwe inleiding', 'Nieuwe goedgekeurde tekst', '2027-10-08', 'test')`, [draft.id]);
    assert.equal((await bouwAgentSnapshot(await leesAgentRijen(pool))).manifest.snapshot_id, original.manifest.snapshot_id, "concept heeft geen effect");
    await database.query("UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Reviewer', goedgekeurd_op = '2026-10-08' WHERE id = $1", [draft.id]);
    const changed = await bouwAgentSnapshot(await leesAgentRijen(pool));
    assert.notEqual(changed.manifest.snapshot_id, original.manifest.snapshot_id);
    assert.equal(changed.exported.chapters[0].sections.length, 1, "oude/verwijderde paragrafen zijn weg");
    assert.equal(changed.exported.chapters[0].version.id, draft.id);
    assert.equal(changed.exported.chapters[1].content_hash, original.exported.chapters[1].content_hash);
    const proposal = (await database.query(`
      INSERT INTO voorstel (soort, status, hoofdstuk_id, wat, waarom, bron, auteur, bijlage_soort, bijlage_titel, bijlage_omschrijving, bijlage_datum, bijlage_url)
      VALUES ('bijlage_toevoegen', 'concept', 'H01', 'Bijlage', 'Test', 'Test', 'Auteur', 'link', 'Link', 'Beschrijving', '2026-10-08', 'https://example.org') RETURNING id`)).rows[0];
    await database.query(`
      INSERT INTO bijlage (bijlage_id, hoofdstuk_id, soort, titel, omschrijving, datum, url, status, voorstel_id, auteur, goedgekeurd_door, goedgekeurd_op)
      VALUES ('H01-B01', 'H01', 'link', 'Link', 'Beschrijving', '2026-10-08', 'https://example.org', 'actief', $1, 'Auteur', 'Reviewer', '2026-10-08')`, [proposal.id]);
    const withAttachment = await bouwAgentSnapshot(await leesAgentRijen(pool));
    assert.equal(withAttachment.exported.chapters[0].attachments.length, 1);
    await database.query("UPDATE bijlage SET status = 'vervallen' WHERE bijlage_id = 'H01-B01'");
    assert.equal((await bouwAgentSnapshot(await leesAgentRijen(pool))).exported.chapters[0].attachments.length, 0);
    assert.equal(JSON.stringify(withAttachment.exported).includes('"voorstel"'), false);
  } finally { await database.close(); }
});
