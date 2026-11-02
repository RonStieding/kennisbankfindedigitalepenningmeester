// Alleen Web APIs: gedeeld door de Deno Edge Function en Node Functions.
export const AGENT_PATHS = ["/api/agent/manifest", "/api/agent/export"];

// Publieke download van goedgekeurde bestandsbijlagen: /api/publiek/bijlage/H03-B02
// Geen login en geen token. De Function levert uitsluitend actieve, goedgekeurde bijlagen.
export const PUBLIEK_BIJLAGE_PAD = "/api/publiek/bijlage/";
const BIJLAGE_ID = /^H\d{2}-B\d{2,}$/;

export function isPubliekeBijlageAanvraag(url) {
  return url.pathname.startsWith(PUBLIEK_BIJLAGE_PAD);
}

// Geeft het bijlage-ID uit het pad terug (hoofdletters), of null als het pad niet klopt.
export function publiekeBijlageId(url) {
  if (!isPubliekeBijlageAanvraag(url)) return null;
  const rest = url.pathname.slice(PUBLIEK_BIJLAGE_PAD.length);
  if (!rest || rest.includes("/")) return null;
  let id;
  try { id = decodeURIComponent(rest).toUpperCase(); } catch { return null; }
  return BIJLAGE_ID.test(id) ? id : null;
}

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
