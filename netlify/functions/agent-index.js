// Index van de kennisbank, live opgebouwd uit de database. Alleen goedgekeurde content.
//
// GET /index-kennisbank  – HTML-pagina: alle hoofdstukken en paragrafen met ID, titel, versie, reviewdatum en vaste link
// GET /llms.txt          – korte uitleg + links naar hoofdstukken en paragrafen (Markdown)
// GET /llms-full.txt     – alle goedgekeurde tekst in één Markdown-bestand
// GET /kennisbank.json   – volledige structuur met ID's, versies, reviewdatums en peildatums
// GET /p/H04-P03         – vaste link: stuurt door naar de paragraaf op de hoofdstukpagina
//
// Toegang: alle adressen vallen onder het inlogslot (netlify/edge-functions/wachtwoord.js, path "/*").
// Omdat de adressen via config.path lopen, is deze function niet bereikbaar via /.netlify/functions/.
//
// Kennisbanktekst (titels, tekst, bronnen) wordt letterlijk doorgegeven. In de HTML-pagina
// wordt alleen ge-escaped, zodat de tekst als tekst wordt getoond.

import { behandel, sql } from "../lib/server.mjs";
import { goedgekeurdeKennisbank, hoofdstukVanParagraaf } from "../lib/kennisbank.mjs";
import { vandaagNL } from "../lib/datum.mjs";

const PARAGRAAF_ID = /^H\d{2}-P\d{2,}$/;

export default behandel(async (req, context) => {
  const url = new URL(req.url);
  const pad = url.pathname;

  if (pad.startsWith("/p/")) return vasteLink(url, context.params?.id);

  const kennisbank = await goedgekeurdeKennisbank(sql);
  controleerAllesGoedgekeurd(kennisbank);

  if (pad === "/llms.txt") return tekst(llmsTxt(kennisbank, url.origin), "text/plain");
  if (pad === "/llms-full.txt") return tekst(llmsFullTxt(kennisbank, url.origin), "text/plain");
  if (pad === "/kennisbank.json") return tekst(JSON.stringify(kennisbankJson(kennisbank, url.origin), null, 2), "application/json");
  return tekst(indexPagina(kennisbank), "text/html");
});

export const config = {
  path: ["/index-kennisbank", "/llms.txt", "/llms-full.txt", "/kennisbank.json", "/p/:id"],
  method: "GET",
};

// ---------- regels ----------

// Tweede slot naast de query: stopt als er toch iets anders dan goedgekeurde content tussen zit.
function controleerAllesGoedgekeurd(kennisbank) {
  for (const h of kennisbank) {
    if (h.version.status !== "goedgekeurd" || !h.version.approved_at) {
      throw new Error(`Index geweigerd: versie ${h.version.id} van ${h.chapter.id} is niet goedgekeurd.`);
    }
  }
}

async function vasteLink(url, id) {
  const paragraafId = String(id || "").toUpperCase();
  if (PARAGRAAF_ID.test(paragraafId)) {
    const hoofdstukId = await hoofdstukVanParagraaf(sql, paragraafId);
    if (hoofdstukId) {
      return new Response(null, {
        status: 302,
        headers: { Location: `/hoofdstuk.html?h=${hoofdstukId}#${paragraafId}`, "Cache-Control": "private, no-store" },
      });
    }
  }
  const html = pagina("Paragraaf niet gevonden", `
    <div class="wrap" style="padding-top:64px;padding-bottom:64px">
      <h1>Paragraaf niet gevonden</h1>
      <p>De paragraaf <strong>${escapeHtml(paragraafId || "(geen ID)")}</strong> staat niet in de actuele goedgekeurde versie van de kennisbank. Misschien is het ID onjuist of is de paragraaf verwijderd.</p>
      <p><a class="knop hoofd" href="/index-kennisbank">Naar de index</a></p>
    </div>`);
  return tekst(html, "text/html", 404);
}

// ---------- vormen ----------

const tweeCijfers = (n) => String(n).padStart(2, "0");
const vasteUrl = (origin, paragraafId) => `${origin}/p/${paragraafId}`;
const hoofdstukUrl = (origin, hoofdstukId) => `${origin}/hoofdstuk.html?h=${hoofdstukId}`;
const paragraafNaam = (s) => (s.number ? `${s.number}. ` : "") + s.title;

function llmsTxt(kennisbank, origin) {
  const regels = [
    "# Kennisbank Fin",
    "",
    "> Kennisbank van Fin, de digitale penningmeester van FinSport. Bevat alleen goedgekeurde tekst voor penningmeesters van sportverenigingen.",
    "",
    "Elke paragraaf heeft een vast ID (bijvoorbeeld H04-P03) en een vaste link (/p/H04-P03). Paragraaf-ID's veranderen nooit en worden nooit hergebruikt. Verwijs bij voorkeur met het paragraaf-ID.",
    "Elke wijziging is door een tweede redacteur gecontroleerd. De peildatum is de datum waarop de hoofdstukversie is goedgekeurd.",
    "",
    "## Volledige inhoud",
    "",
    `- [Alle goedgekeurde tekst (Markdown)](${origin}/llms-full.txt): de volledige tekst van alle hoofdstukken`,
    `- [Structuur (JSON)](${origin}/kennisbank.json): ID's, versies, reviewdatums, peildatums en tekst`,
    `- [Index (HTML)](${origin}/index-kennisbank): overzicht voor mensen`,
    "",
    "## Hoofdstukken",
    "",
  ];
  for (const h of kennisbank) {
    regels.push(`- [${tweeCijfers(h.chapter.number)} ${h.chapter.title}](${hoofdstukUrl(origin, h.chapter.id)}): ${h.chapter.description}`);
  }
  for (const h of kennisbank) {
    regels.push("", `## ${h.chapter.id} – ${h.chapter.title} (versie ${h.version.number}, peildatum ${h.version.peildatum})`, "");
    for (const s of h.sections) regels.push(`- [${s.id} ${paragraafNaam(s)}](${vasteUrl(origin, s.id)})`);
  }
  return regels.join("\n") + "\n";
}

function llmsFullTxt(kennisbank, origin) {
  const delen = [
    "# Kennisbank Fin – alle goedgekeurde tekst",
    "",
    `Opgebouwd op ${vandaagNL()} uit ${origin}. Alleen goedgekeurde tekst; de tekst van elke paragraaf staat hieronder letterlijk.`,
    "Peildatum = datum waarop de hoofdstukversie is goedgekeurd.",
  ];
  for (const h of kennisbank) {
    const v = h.version;
    delen.push(
      "", "---", "",
      `# Hoofdstuk ${h.chapter.number} – ${h.chapter.title}`,
      "",
      `Hoofdstuk-ID: ${h.chapter.id} · Versie: ${v.number} · Peildatum: ${v.peildatum} · Goedgekeurd door: ${v.approved_by}`,
      `Link: ${hoofdstukUrl(origin, h.chapter.id)}`,
    );
    for (const s of h.sections) {
      delen.push(
        "",
        `## ${s.id} – ${paragraafNaam(s)}`,
        "",
        `Paragraaf-ID: ${s.id} · Reviewdatum: ${s.review.date} · Vaste link: ${vasteUrl(origin, s.id)}`,
        "",
        s.body,
      );
    }
    if (h.attachments.length) {
      delen.push("", `## Bijlagen bij hoofdstuk ${h.chapter.number}`, "");
      for (const b of h.attachments) {
        const link = b.external ? b.url : origin + b.url;
        delen.push(`- ${b.id} (${b.type}, ${b.date}): [${b.title}](${link}) – ${b.description}`);
      }
    }
  }
  return delen.join("\n") + "\n";
}

function kennisbankJson(kennisbank, origin) {
  return {
    schema: "fin-kennisbank/index@1",
    generated_on: vandaagNL(),
    source: origin,
    note: "Alleen goedgekeurde content. body is letterlijke tekst (Markdown). checksum = eerste 16 tekens van sha256(body). peildatum = datum waarop de hoofdstukversie is goedgekeurd.",
    chapters: kennisbank.map((h) => ({
      id: h.chapter.id,
      number: h.chapter.number,
      title: h.chapter.title,
      description: h.chapter.description,
      url: hoofdstukUrl(origin, h.chapter.id),
      version: {
        number: h.version.number,
        date: h.version.date,
        approved_by: h.version.approved_by,
        approved_at: h.version.approved_at,
        peildatum: h.version.peildatum,
        basisversie: h.version.basisversie,
      },
      sections: h.sections.map((s) => ({ ...s, url: vasteUrl(origin, s.id) })),
      attachments: h.attachments.map((b) => ({ ...b, url: b.external ? b.url : origin + b.url })),
    })),
  };
}

function indexPagina(kennisbank) {
  const vandaag = vandaagNL();
  const hoofdstukken = kennisbank.map((h) => {
    const rijen = h.sections.map((s) => {
      const verlopen = s.review.date && s.review.date < vandaag
        ? ' <span class="status verlopen"><span aria-hidden="true">!</span> verlopen</span>' : "";
      return `
            <tr>
              <td class="num"><strong>${escapeHtml(s.id)}</strong></td>
              <td><a href="/p/${escapeHtml(s.id)}">${escapeHtml(paragraafNaam(s))}</a></td>
              <td class="num">${escapeHtml(h.version.number)}</td>
              <td class="num">${datumNL(s.review.date)}${verlopen}</td>
              <td class="num"><a href="/p/${escapeHtml(s.id)}">/p/${escapeHtml(s.id)}</a></td>
            </tr>`;
    }).join("");
    return `
      <section class="index-hs" id="${escapeHtml(h.chapter.id)}" aria-labelledby="${escapeHtml(h.chapter.id)}-kop">
        <h2 id="${escapeHtml(h.chapter.id)}-kop"><span class="nr num">${tweeCijfers(h.chapter.number)}</span>
          <a href="/hoofdstuk.html?h=${escapeHtml(h.chapter.id)}">${escapeHtml(h.chapter.title)}</a></h2>
        <div class="versie">
          <span><strong>ID</strong> <span class="num">${escapeHtml(h.chapter.id)}</span></span>
          <span><strong>Versie</strong> <span class="num">${escapeHtml(h.version.number)}</span></span>
          <span><strong>Peildatum</strong> <span class="num">${datumNL(h.version.peildatum)}</span></span>
          <span class="status goed"><span aria-hidden="true">✓</span> Goedgekeurd</span>
        </div>
        <div class="md tabel-wrap">
          <table>
            <thead><tr><th scope="col">ID</th><th scope="col">Titel</th><th scope="col">Versie</th><th scope="col">Reviewdatum</th><th scope="col">Vaste link</th></tr></thead>
            <tbody>${rijen}
            </tbody>
          </table>
        </div>
      </section>`;
  }).join("");

  return pagina("Index", `
    <div class="wrap">
      <nav class="kruimel" aria-label="Kruimelpad"><a href="/">Start</a> / Index</nav>
      <header class="hs-kop">
        <h1>Index van de kennisbank</h1>
        <p class="tekst">Alle hoofdstukken en paragrafen in de actuele goedgekeurde versie. Elke paragraaf heeft een vaste link die niet verandert.</p>
        <div class="versie">
          <span><strong>Voor agents</strong> <a href="/llms.txt">llms.txt</a> · <a href="/llms-full.txt">llms-full.txt</a> · <a href="/kennisbank.json">kennisbank.json</a></span>
          <span><strong>Peildatum</strong> datum waarop de hoofdstukversie is goedgekeurd</span>
        </div>
      </header>
      ${hoofdstukken || '<p class="melding">Er zijn nog geen goedgekeurde hoofdstukken.</p>'}
    </div>`, true);
}

// ---------- hulpjes ----------

function pagina(titel, inhoud, isIndex = false) {
  return `<!DOCTYPE html>
<html lang="nl">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex, nofollow">
  <title>${escapeHtml(titel)} – Kennisbank Fin</title>
  <link rel="icon" href="/favicon.svg" type="image/svg+xml">
  <link rel="stylesheet" href="/css/fin.css">
  <script type="module" src="/js/index-kennisbank.js"></script>
</head>
<body>
  <a class="sr-only" href="#main">Naar de inhoud</a>
  <header class="kopbalk">
    <div class="wrap">
      <a class="merk" href="/" aria-label="Kennisbank Fin – naar de startpagina">
        <img data-logo src="/assets/logo/finsport-logo-wit.svg" alt="FinSport">
        <span class="logo-tekst" hidden>FinSport</span>
        <span class="naam">Kennisbank Fin</span>
      </a>
      <form class="zoek-globaal" id="zoek-globaal" role="search">
        <label for="zoek-globaal-veld" class="sr-only">Zoeken in alle hoofdstukken</label>
        <input id="zoek-globaal-veld" type="search" placeholder="Zoeken in alle hoofdstukken" autocomplete="off">
      </form>
      <ul class="menu">
        <li><a href="/index-kennisbank"${isIndex ? ' aria-current="page"' : ""}>Index</a></li>
        <li><a href="/voorstellen.html">Openstaande voorstellen <span class="teller" data-teller-voorstellen>0</span></a></li>
        <li><span class="uit" title="Volgt in bouwstap 4">Testset</span></li>
        <li><span class="uit" title="Volgt in bouwstap 5">Export</span></li>
        <li class="gebruiker" id="gebruiker" aria-live="polite"></li>
        <li><a href="/uitloggen">Uitloggen</a></li>
      </ul>
    </div>
  </header>

  <main id="main">${inhoud}
  </main>
</body>
</html>`;
}

function tekst(inhoud, type, status = 200) {
  return new Response(inhoud, {
    status,
    headers: {
      "Content-Type": `${type}; charset=utf-8`,
      "Cache-Control": "private, no-store",
      "X-Content-Type-Options": "nosniff",
    },
  });
}

function datumNL(iso) {
  if (!iso) return "–";
  const [j, m, d] = String(iso).split("-");
  return `${d}-${m}-${j}`;
}

function escapeHtml(t) {
  return String(t ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]);
}
