import test from "node:test";
import assert from "node:assert/strict";
import edge from "../netlify/edge-functions/wachtwoord.js";
import { controleerAgentToegang } from "../netlify/lib/agent-access.mjs";
import { maakAgentHandler } from "../netlify/lib/agent-handler.mjs";
import { bouwAgentSnapshot } from "../netlify/lib/agent-export.mjs";
import { TOKEN, rijen } from "./fixtures.mjs";

const req = (path = "/api/agent/manifest", headers = {}, method = "GET") =>
  new Request(`https://knowledge.example${path}`, { method, headers });
const auth = { Authorization: `Bearer ${TOKEN}` };

test("servicetoegang is fail-closed en cookies/querytokens tellen niet", async () => {
  for (const configured of [undefined, "", "short"]) {
    assert.equal((await controleerAgentToegang(req(undefined, auth), configured)).status, 503);
  }
  for (const headers of [{}, { Cookie: "fin_sessie=browser" }, { Authorization: "Bearer wrong" }]) {
    const denied = await controleerAgentToegang(req(undefined, headers), TOKEN);
    assert.equal(denied.status, 401);
    assert.equal(denied.headers.get("cache-control"), "private, no-store");
  }
  assert.equal((await controleerAgentToegang(req(`/?token=${TOKEN}`), TOKEN)).status, 404);
  assert.equal((await controleerAgentToegang(req(`/api/agent/export?token=${TOKEN}`), TOKEN)).status, 401);
  assert.equal(await controleerAgentToegang(req(undefined, auth), TOKEN), null);
  for (const method of ["HEAD", "POST", "PUT", "DELETE", "OPTIONS"]) {
    assert.equal((await controleerAgentToegang(req(undefined, auth, method), TOKEN)).status, 405);
  }
});

test("Edge geeft agenttoken uitsluitend de twee leesroutes; browserlogin blijft werken", async () => {
  const old = globalThis.Netlify;
  globalThis.Netlify = { env: { get: (name) => ({ SITE_PASSWORD: "browser-password", KNOWLEDGE_SYNC_TOKEN: TOKEN })[name] } };
  try {
    for (const path of ["/api/agent/manifest", "/api/agent/export"]) {
      assert.equal(await edge(req(path, auth)), undefined);
      assert.equal((await edge(req(path))).status, 401);
      assert.equal((await edge(req(path, auth, "POST"))).status, 405);
    }
    for (const path of ["/api/voorstel", "/api/voorstellen", "/api/upload", "/api/bestand", "/api/kennisbank", "/api/agent/manifest/", "/api/agent/other"]) {
      assert.equal((await edge(req(path, auth))).status, 401, path);
    }
    for (const path of ["/", "/llms.txt", "/kennisbank.json", "/.netlify/functions/agent-sync"]) {
      assert.equal((await edge(req(path, auth))).status, 303, path);
    }
    const login = await edge(new Request("https://knowledge.example/inloggen", {
      method: "POST", body: new URLSearchParams({ wachtwoord: "browser-password", terug: "/" }),
    }));
    assert.equal(login.status, 303);
    const cookie = login.headers.get("set-cookie").split(";")[0];
    assert.equal(await edge(req("/api/kennisbank", { Cookie: cookie })), undefined);
    assert.equal((await edge(req("/api/agent/export", { Cookie: cookie }))).status, 401);
    globalThis.Netlify.env.get = (name) => name === "KNOWLEDGE_SYNC_TOKEN" ? TOKEN : undefined;
    assert.equal(await edge(req(undefined, auth)), undefined, "service werkt onafhankelijk van browserwachtwoord");
    assert.equal((await edge(req("/"))).status, 503);
  } finally { globalThis.Netlify = old; }
});

test("handler controleert opnieuw, vóór databasetoegang en vóór 304", async () => {
  let calls = 0;
  const handler = maakAgentHandler({ getToken: () => TOKEN,
    getSnapshot: async () => { calls++; return bouwAgentSnapshot(rijen()); } });
  assert.equal((await handler(req(undefined, { "If-None-Match": "*" }))).status, 401);
  assert.equal(calls, 0);
  assert.equal((await handler(req("/.netlify/functions/agent-sync", auth))).status, 404);
  assert.equal((await handler(req(undefined, auth, "POST"))).status, 405);
  assert.equal(calls, 0);
  const response = await handler(req(undefined, auth));
  assert.equal(response.status, 200);
  const etag = response.headers.get("etag");
  assert.equal(response.headers.get("vary"), "Authorization");
  const manifest = await response.json();
  for (const condition of [etag, `W/${etag}`, `"old", ${etag}`, "*"]) {
    const result = await handler(req(undefined, { ...auth, "If-None-Match": condition }));
    assert.equal(result.status, 304);
    assert.equal(await result.text(), "");
  }
  const exp = await handler(req(`/api/agent/export?snapshot_id=${manifest.snapshot_id}`, auth));
  assert.equal(exp.status, 200);
  assert.notEqual(exp.headers.get("etag"), etag);
  assert.equal((await exp.json()).snapshot_id, manifest.snapshot_id);
  const stale = await handler(req(`/api/agent/export?snapshot_id=sha256:${"0".repeat(64)}`, { ...auth, "If-None-Match": "*" }));
  assert.equal(stale.status, 409);
  assert.equal((await stale.json()).error, "snapshot_changed");
});

test("ongeldige parameters, databasefout en te grote export blijven expliciete fouten", async () => {
  let calls = 0;
  const handler = maakAgentHandler({ getToken: () => TOKEN, logError: () => {},
    getSnapshot: async () => { calls++; throw new Error("private database message"); } });
  for (const path of ["/api/agent/export?snapshot_id=", "/api/agent/export?snapshot_id=no", "/api/agent/export?token=abc", "/api/agent/manifest?snapshot_id=abc", "/api/agent/export?snapshot_id=a&snapshot_id=b"]) {
    assert.equal((await handler(req(path, auth))).status, 400);
  }
  assert.equal(calls, 0);
  const result = await handler(req(undefined, auth));
  assert.equal(result.status, 503);
  assert.deepEqual(await result.json(), { error: "source_unavailable" });
  const tooBig = maakAgentHandler({ getToken: () => TOKEN, getSnapshot: async () => ({
    manifest: { snapshot_id: "sha256:abc" }, exported: { body: "x".repeat(5 * 1024 * 1024) },
  }) });
  assert.equal((await tooBig(req("/api/agent/export", auth))).status, 503);
});
