// Wachtwoordbeveiliging voor de hele kennisbank (pagina's, bestanden en /api/...).
//
// Deze Edge Function draait bij Netlify vóór elke aanvraag. Zonder geldige sessiecookie
// krijgt een bezoeker alleen het inlogscherm te zien; een API-aanvraag krijgt een 401.
//
// Het wachtwoord staat NIET in de code. Netlify levert het via de environment variable
// SITE_PASSWORD. Ontbreekt die variabele, dan blijven browserpagina's en bestaande API's dicht.
// Alleen de twee agent-GET-routes hebben hun eigen, onafhankelijke servicetoken.
//
// Na correct inloggen krijgt de browser een HttpOnly-cookie met een vervaldatum en een
// handtekening (HMAC-SHA256). De handtekening is gemaakt met het wachtwoord als sleutel.
// Een cookie is dus niet na te maken zonder het wachtwoord, en na het wijzigen van
// SITE_PASSWORD zijn alle bestaande sessies direct ongeldig.

import { AGENT_PATHS, controleerAgentToegang } from "../lib/agent-access.mjs";

const COOKIE = "fin_sessie";
const SESSIEDUUR_SECONDEN = 14 * 24 * 60 * 60; // 14 dagen
const INLOGPAD = "/inloggen";
const UITLOGPAD = "/uitloggen";

const encoder = new TextEncoder();

export default async (request) => {
  const url = new URL(request.url);
  // Apart read-only slot, vóór browserlogin. Een servicetoken verleent nergens
  // anders toegang en wordt in de Node Function opnieuw gecontroleerd.
  if (AGENT_PATHS.includes(url.pathname)) {
    return (await controleerAgentToegang(request, Netlify.env.get("KNOWLEDGE_SYNC_TOKEN"))) || undefined;
  }
  const wachtwoord = Netlify.env.get("SITE_PASSWORD") || "";

  if (!wachtwoord) {
    return htmlAntwoord(
      pagina("Kennisbank niet beschikbaar",
        `<p>De wachtwoordbeveiliging is nog niet ingesteld. De beheerder moet in Netlify de environment variable <strong>SITE_PASSWORD</strong> invullen.</p>`),
      503,
    );
  }

  if (url.pathname === UITLOGPAD) {
    return doorsturen(INLOGPAD + "?uitgelogd=1", verwijderCookie(url));
  }

  if (url.pathname === INLOGPAD) {
    if (request.method === "POST") return verwerkInloggen(request, url, wachtwoord);
    if (await geldigeSessie(request, wachtwoord)) return doorsturen(veiligTerugpad(url.searchParams.get("terug")));
    return inlogscherm(url.searchParams.get("terug"), url.searchParams.has("uitgelogd") ? "Je bent uitgelogd." : "");
  }

  if (await geldigeSessie(request, wachtwoord)) return; // doorgaan naar de site of de Function

  if (url.pathname.startsWith("/api/")) {
    return new Response(JSON.stringify({ fout: "Je bent niet (meer) ingelogd. Laad de pagina opnieuw en log in." }), {
      status: 401,
      headers: { "Content-Type": "application/json; charset=utf-8", "Cache-Control": "no-store" },
    });
  }
  return doorsturen(INLOGPAD + "?terug=" + encodeURIComponent(url.pathname + url.search));
};

// ---------- inloggen ----------

async function verwerkInloggen(request, url, wachtwoord) {
  // Alleen formulieren vanaf de eigen site.
  const herkomst = request.headers.get("origin");
  if (herkomst && herkomst !== "null" && new URL(herkomst).host !== url.host) {
    return new Response("Geweigerd", { status: 403 });
  }

  let ingevuld = "";
  let terug = "/";
  try {
    const formulier = await request.formData();
    ingevuld = String(formulier.get("wachtwoord") || "");
    terug = veiligTerugpad(String(formulier.get("terug") || "/"));
  } catch { /* leeg formulier: telt als fout wachtwoord */ }

  if (!(await gelijk(ingevuld, wachtwoord))) {
    // Vertraging maakt het raden van het wachtwoord trager.
    await new Promise((klaar) => setTimeout(klaar, 1000));
    return inlogscherm(terug, "Het wachtwoord is onjuist. Probeer het opnieuw.", 401);
  }

  const verloopt = Math.floor(Date.now() / 1000) + SESSIEDUUR_SECONDEN;
  const waarde = `${verloopt}.${await handtekening(String(verloopt), wachtwoord)}`;
  return doorsturen(terug, maakCookie(url, waarde, SESSIEDUUR_SECONDEN));
}

async function geldigeSessie(request, wachtwoord) {
  const waarde = leesCookie(request.headers.get("cookie") || "", COOKIE);
  if (!waarde) return false;
  const [verloopt, sig] = waarde.split(".");
  if (!/^\d{1,12}$/.test(verloopt || "") || !sig) return false;
  if (Number(verloopt) <= Math.floor(Date.now() / 1000)) return false;
  return gelijk(sig, await handtekening(verloopt, wachtwoord));
}

// ---------- cryptografie ----------

async function handtekening(tekst, geheim) {
  const sleutel = await crypto.subtle.importKey("raw", encoder.encode(geheim), { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
  const sig = await crypto.subtle.sign("HMAC", sleutel, encoder.encode("fin-sessie:" + tekst));
  return [...new Uint8Array(sig)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

// Vergelijking in constante tijd: eerst beide waarden hashen, dan alle bytes vergelijken.
async function gelijk(a, b) {
  const [ha, hb] = await Promise.all([
    crypto.subtle.digest("SHA-256", encoder.encode(a)),
    crypto.subtle.digest("SHA-256", encoder.encode(b)),
  ]);
  const x = new Uint8Array(ha);
  const y = new Uint8Array(hb);
  let verschil = 0;
  for (let i = 0; i < x.length; i++) verschil |= x[i] ^ y[i];
  return verschil === 0;
}

// ---------- cookies en antwoorden ----------

function leesCookie(kop, naam) {
  for (const deel of kop.split(";")) {
    const i = deel.indexOf("=");
    if (i > -1 && deel.slice(0, i).trim() === naam) return deel.slice(i + 1).trim();
  }
  return "";
}

// Secure alleen via https; lokaal testen (http://localhost) werkt anders niet in elke browser.
function maakCookie(url, waarde, maxAge) {
  const secure = url.protocol === "https:" ? "; Secure" : "";
  return `${COOKIE}=${waarde}; Path=/; Max-Age=${maxAge}; HttpOnly; SameSite=Lax${secure}`;
}

function verwijderCookie(url) {
  return maakCookie(url, "", 0);
}

// Alleen terugsturen naar een pad op deze site (geen doorsturen naar andere websites).
function veiligTerugpad(pad) {
  if (!pad || !pad.startsWith("/") || pad.startsWith("//") || pad.startsWith("/\\")) return "/";
  if (pad.startsWith(INLOGPAD) || pad.startsWith(UITLOGPAD)) return "/";
  return pad;
}

function doorsturen(pad, cookie) {
  const headers = new Headers({ Location: pad, "Cache-Control": "no-store" });
  if (cookie) headers.append("Set-Cookie", cookie);
  return new Response(null, { status: 303, headers });
}

function htmlAntwoord(html, status = 200) {
  return new Response(html, {
    status,
    headers: {
      "Content-Type": "text/html; charset=utf-8",
      "Cache-Control": "no-store",
      "X-Robots-Tag": "noindex, nofollow",
      "X-Content-Type-Options": "nosniff",
      "X-Frame-Options": "DENY",
      "Referrer-Policy": "strict-origin-when-cross-origin",
      "Content-Security-Policy": "default-src 'none'; style-src 'unsafe-inline'; form-action 'self'; frame-ancestors 'none'; base-uri 'none'",
    },
  });
}

function inlogscherm(terug, melding = "", status = 200) {
  const inhoud = `
    <form method="post" action="${INLOGPAD}">
      <input type="hidden" name="terug" value="${escapeHtml(veiligTerugpad(terug))}">
      <label for="wachtwoord">Wachtwoord</label>
      <input id="wachtwoord" name="wachtwoord" type="password" autocomplete="current-password" required autofocus>
      ${melding ? `<p class="melding" role="alert">${escapeHtml(melding)}</p>` : ""}
      <button type="submit">Inloggen</button>
    </form>`;
  return htmlAntwoord(pagina("Inloggen", inhoud), status);
}

// Het inlogscherm laadt niets van de beveiligde site; daarom staat de opmaak hier zelf.
function pagina(kop, inhoud) {
  return `<!DOCTYPE html>
<html lang="nl">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex, nofollow">
  <title>${escapeHtml(kop)} – Kennisbank Fin</title>
  <style>
    body { margin: 0; min-height: 100vh; display: flex; align-items: center; justify-content: center;
           background: #f4f4f4; color: #111; font-family: system-ui, -apple-system, "Segoe UI", sans-serif; }
    main { width: min(360px, calc(100% - 32px)); background: #fff; border-top: 6px solid #D0011B;
           padding: 28px 24px; box-shadow: 0 2px 12px rgba(0,0,0,.08); }
    h1 { font-size: 22px; margin: 0 0 4px; }
    .sub { margin: 0 0 20px; color: #555; }
    label { display: block; font-weight: 600; margin-bottom: 6px; }
    input[type=password] { width: 100%; box-sizing: border-box; padding: 10px; font-size: 16px; border: 1px solid #999; border-radius: 4px; }
    button { margin-top: 16px; width: 100%; padding: 11px; font-size: 16px; font-weight: 600; color: #fff;
             background: #D0011B; border: 0; border-radius: 4px; cursor: pointer; }
    button:hover { background: #a80016; }
    .melding { color: #a80016; margin: 10px 0 0; }
  </style>
</head>
<body>
  <main>
    <h1>Kennisbank Fin</h1>
    <p class="sub">${escapeHtml(kop)}</p>
    ${inhoud}
  </main>
</body>
</html>`;
}

function escapeHtml(tekst) {
  return String(tekst).replace(/[&<>"']/g, (t) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[t]);
}

// Geldt voor alle adressen van de site, dus ook /api/... en de bestanden in public/.
export const config = { path: "/*" };
