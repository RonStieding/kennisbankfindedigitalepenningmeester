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
  const unchanged = await request("/api/agent/manifest", { ...auth, "If-None-Match": etag });
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
  return { chapter_count: manifest.chapter_count, snapshot_id };
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    const result = await controleerAgentWebsite(process.env.KNOWLEDGE_SYNC_URL, process.env.KNOWLEDGE_SYNC_TOKEN);
    console.log(`Agentexport gecontroleerd: ${result.chapter_count} hoofdstukken; authenticatie, hashes, 304 en 409 kloppen.`);
  } catch (error) {
    console.error(`Agentcontrole mislukt: ${error.message}`);
    process.exitCode = 1;
  }
}
