// Alleen Web APIs: gedeeld door de Deno Edge Function en Node Functions.
export const AGENT_PATHS = ["/api/agent/manifest", "/api/agent/export"];

export function agentAntwoord(data, status = 200, extraHeaders = {}) {
  return new Response(data === null ? null : JSON.stringify(data), {
    status,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": "private, no-store",
      "Vary": "Authorization",
      "X-Content-Type-Options": "nosniff",
      "X-Robots-Tag": "noindex, nofollow",
      ...extraHeaders,
    },
  });
}

export async function controleerAgentToegang(request, token) {
  if (!AGENT_PATHS.includes(new URL(request.url).pathname)) {
    return agentAntwoord({ error: "not_found" }, 404);
  }
  // Uitsluitend een apart, lang servicetoken; browsercookies geven hier geen toegang.
  if (typeof token !== "string" || !/^[A-Za-z0-9_-]{32,256}$/.test(token)) {
    return agentAntwoord({ error: "agent_access_not_configured" }, 503);
  }
  const bearer = /^Bearer ([A-Za-z0-9_-]{32,256})$/i.exec(request.headers.get("authorization") || "");
  const encoder = new TextEncoder();
  const [expected, actual] = await Promise.all([token, bearer?.[1] || ""].map(
    (value) => crypto.subtle.digest("SHA-256", encoder.encode(value)),
  ));
  const a = new Uint8Array(expected);
  const b = new Uint8Array(actual);
  let verschil = 0;
  for (let i = 0; i < a.length; i++) verschil |= a[i] ^ b[i];
  if (!bearer || verschil !== 0) {
    return agentAntwoord({ error: "unauthorized" }, 401, { "WWW-Authenticate": 'Bearer realm="fin-knowledge"' });
  }
  if (request.method !== "GET") {
    return agentAntwoord({ error: "method_not_allowed" }, 405, { Allow: "GET" });
  }
  return null;
}
