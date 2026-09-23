import { haalHoofdstuk, haalVersie, isVerlopen, datumNL, tweeCijfers, grootteTekst, BIJLAGE_NAAM } from "./data.js";
import { markdownNaarHtml, zoektermen, markeer, verwijderMarkering, escapeHtml } from "./tekst.js";
import { beeldenTerugval, kopZoekbalk, toonFout, toonRedacteurKeuze, werkTellerBij } from "./algemeen.js";
import { openVoorstelFormulier } from "./voorstelformulier.js";
import { openBijlageFormulier } from "./bijlageformulier.js";
import { vergelijkHtml } from "./vergelijk.js";

const params = new URLSearchParams(location.search);
const id = (params.get("h") || "").toUpperCase();
const hoofdEl = document.getElementById("hoofdstuk");

const BIJLAGESOORTEN = [
  { soort: "download", naam: "Downloads", icoon: '<path d="M12 3v12m0 0l-5-5m5 5l5-5M4 21h16"/>' },
  { soort: "template", naam: "Templates", icoon: '<rect x="4" y="3" width="16" height="18" rx="2"/><path d="M8 8h8M8 12h8M8 16h5"/>' },
  { soort: "stappenplan", naam: "Stappenplannen", icoon: '<path d="M4 6h3M4 12h3M4 18h3M10 6h10M10 12h10M10 18h10"/>' },
  { soort: "link", naam: "Links", icoon: '<path d="M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1"/>' },
];

function sectieKop(s) {
  const nr = s.number ? `<span class="nr num">${escapeHtml(s.number)}</span>` : "";
  return `<h2>${nr}<span>${escapeHtml(s.title)}</span></h2>`;
}

function sectieHtml(s) {
  const verlopen = isVerlopen(s.review?.date);
  return `
    <section class="paragraaf kind-${s.kind}" id="${s.id}" aria-labelledby="${s.id}-kop">
      <div class="par-meta">
        <span class="id">${s.id}</span>
        <span>Review: ${datumNL(s.review?.date)}</span>
        ${verlopen ? '<span class="status verlopen"><span aria-hidden="true">!</span> Reviewdatum verlopen</span>' : ""}
      </div>
      <div id="${s.id}-kop">${sectieKop(s)}</div>
      <div class="md">${markdownNaarHtml(s.body)}</div>
      <div class="par-acties geen-print">
        ${s.open_proposals ? `<a class="status validatie" href="/voorstellen.html?hoofdstuk=${id}"><span aria-hidden="true">◷</span> ${s.open_proposals} ${s.open_proposals === 1 ? "voorstel" : "voorstellen"} open</a>` : ""}
        <button type="button" class="knop tweede klein" data-voorstel="wijzigen" data-sectie="${s.id}">Wijziging voorstellen</button>
        <button type="button" class="knop tekstknop klein" data-voorstel="toevoegen" data-sectie="${s.id}">Paragraaf toevoegen hierna</button>
        <button type="button" class="knop tekstknop klein" data-voorstel="verwijderen" data-sectie="${s.id}">Verwijderen voorstellen</button>
      </div>
    </section>`;
}

function navItem(s) {
  const nr = s.number ?? "";
  return `<li data-sectie="${s.id}"><a href="#${s.id}"><span class="nr">${escapeHtml(nr)}</span><span>${escapeHtml(s.title)} <span class="treffers"></span></span></a></li>`;
}

function bijlageItem(x) {
  const extra = x.external
    ? `<span class="hulp">Externe link</span>`
    : `<span class="hulp">${escapeHtml((x.file_name || "").split(".").pop().toUpperCase())}${x.file_size ? " · " + grootteTekst(x.file_size) : ""}</span>`;
  return `<li class="bijlage">
    <a href="${escapeHtml(x.url)}" ${x.external ? 'target="_blank" rel="noopener noreferrer"' : "download"}>${escapeHtml(x.title)}</a>
    <span class="bijlage-omschr">${escapeHtml(x.description || "")}</span>
    <span class="hulp num">${escapeHtml(x.id)} · ${datumNL(x.date)}</span> ${extra}
    <span class="bijlage-acties geen-print">
      ${x.open_proposals ? `<a class="status validatie" href="/voorstellen.html?hoofdstuk=${id}"><span aria-hidden="true">◷</span> voorstel open</a>` : ""}
      <button type="button" class="knop tekstknop klein" data-bijlage="bijlage_wijzigen" data-id="${escapeHtml(x.id)}">Wijzigen</button>
      <button type="button" class="knop tekstknop klein" data-bijlage="bijlage_verwijderen" data-id="${escapeHtml(x.id)}">Laten vervallen</button>
    </span>
  </li>`;
}

function bijlagenHtml(bijlagen) {
  return BIJLAGESOORTEN.map((b) => {
    const items = bijlagen.filter((x) => x.type === b.soort);
    const inhoud = items.length
      ? `<ul class="bijlagen-lijst">${items.map(bijlageItem).join("")}</ul>`
      : `<p>Nog geen ${b.naam.toLowerCase()}.</p>`;
    return `<div class="bijlagegroep"><h3><svg viewBox="0 0 24 24" aria-hidden="true">${b.icoon}</svg>${b.naam}</h3>${inhoud}</div>`;
  }).join("") + `<button type="button" class="knop tweede klein geen-print" data-bijlage="bijlage_toevoegen">+ Bijlage voorstellen</button>`;
}

function geschiedenisHtml(versies) {
  return versies.map((x, i) => {
    const status = x.status === "afgewezen"
      ? '<span class="status afgewezen"><span aria-hidden="true">✕</span> Afgewezen</span>'
      : '<span class="status goed"><span aria-hidden="true">✓</span> Goedgekeurd</span>';
    const vergelijk = i === versies.length - 1
      ? "Eerste versie: er is nog geen vorige versie om mee te vergelijken."
      : `<button type="button" class="knop tekstknop klein" data-vergelijk="${x.id}" data-vorige="${versies[i + 1].id}">Vergelijk met ${escapeHtml(versies[i + 1].number)}</button>`;
    return `<li><strong class="num">${escapeHtml(x.number)}</strong> · ${datumNL(x.date)} ${status}<br>
      <span class="hulp">Auteur: ${escapeHtml(x.author || "–")}<br>Goedgekeurd door: ${escapeHtml(x.approved_by || "–")}${x.approved_at ? " op " + datumNL(x.approved_at) : ""}</span><br>
      ${x.note ? `<span class="hulp">${escapeHtml(x.note)}</span><br>` : ""}
      ${x.proposal_id ? `<a class="hulp" href="/voorstellen.html?id=${x.proposal_id}">Voorstel #${x.proposal_id}</a><br>` : ""}
      <span class="hulp">${vergelijk}</span></li>`;
  }).join("");
}

function render(h) {
  const c = h.chapter, v = h.version;
  document.title = `${tweeCijfers(c.number)} ${c.title} – Kennisbank Fin`;
  const exportDatum = datumNL(new Date().toISOString().slice(0, 10));

  hoofdEl.innerHTML = `
    <div class="print-kop"><span>FinSport</span><span>Kennisbank Fin</span></div>
    <div class="wrap">
      <nav class="kruimel" aria-label="Kruimelpad"><a href="/">Start</a> / Hoofdstuk ${tweeCijfers(c.number)}</nav>
      <header class="hs-kop">
        <div class="nr" aria-hidden="true">${tweeCijfers(c.number)}</div>
        <h1><span class="sr-only">Hoofdstuk ${c.number}: </span>${escapeHtml(c.title)}</h1>
        <div class="versie">
          <span><strong>Versie</strong> <span class="num">${escapeHtml(v.number)}</span></span>
          <span><strong>Datum</strong> <span class="num">${datumNL(v.date)}</span></span>
          <span><strong>Auteur</strong> ${escapeHtml(v.author)}</span>
          <span><strong>Goedkeurder</strong> ${v.approved_by ? escapeHtml(v.approved_by) : "–"}</span>
          <span class="status goed"><span aria-hidden="true">✓</span> Goedgekeurd</span>
          ${h.open_proposals || h.open_concepts ? `<a href="/voorstellen.html?hoofdstuk=${c.id}">${h.open_proposals} ter validatie, ${h.open_concepts} ${h.open_concepts === 1 ? "concept" : "concepten"}</a>` : ""}
        </div>
        <div class="hs-acties">
          <form class="zoek-lokaal" id="zoek-lokaal" role="search">
            <label for="zoek-lokaal-veld" class="sr-only">Zoeken in dit hoofdstuk</label>
            <input class="veld" id="zoek-lokaal-veld" type="search" placeholder="Zoeken in dit hoofdstuk" autocomplete="off">
            <span class="zoek-info" id="zoek-info" aria-live="polite"></span>
          </form>
          <button type="button" class="knop tweede klein" id="vorige" disabled>Vorige</button>
          <button type="button" class="knop tweede klein" id="volgende" disabled>Volgende</button>
          <button type="button" class="knop tweede klein" id="pdf">PDF</button>
          <button type="button" class="knop tweede klein" id="word">Word</button>
        </div>
      </header>

      <div class="hs-grid">
        <nav class="inhoud-nav" aria-label="Inhoud van dit hoofdstuk">
          <span class="label">Inhoud</span>
          <ol>${h.sections.map(navItem).join("")}</ol>
        </nav>

        <div class="tekst">
          <details class="inhoud-uitklap geen-print">
            <summary>Inhoud van dit hoofdstuk</summary>
            <ol>${h.sections.map((s) => `<li><a href="#${s.id}">${escapeHtml((s.number ? s.number + " " : "") + s.title)}</a></li>`).join("")}</ol>
          </details>
          <div id="paragrafen">${h.sections.map(sectieHtml).join("")}</div>
          <div class="print-voet">Hoofdstuk ${c.number} — ${escapeHtml(c.title)} · versie ${escapeHtml(v.number)} (${datumNL(v.date)}) · geëxporteerd op ${exportDatum}</div>
        </div>

        <aside class="zijkolom">
          <section class="blok" aria-labelledby="bijlagen-kop">
            <h2 id="bijlagen-kop">Bijlagen</h2>
            ${bijlagenHtml(h.attachments || [])}
          </section>
          <section class="blok" aria-labelledby="versies-kop">
            <h2 id="versies-kop">Versiegeschiedenis</h2>
            <ul class="historie">${geschiedenisHtml(h.history || [v])}
            </ul>
          </section>
        </aside>
      </div>
    </div>`;

  koppelZoeken();
  koppelInhoudActief();
  koppelVoorstellen(h);
  koppelBijlagen(h);
  koppelVergelijken(h);
  document.getElementById("pdf").addEventListener("click", () => window.print());
  document.getElementById("word").addEventListener("click", () => exporteerWord(h));

  if (location.hash) document.getElementById(location.hash.slice(1))?.scrollIntoView();
}

function koppelZoeken() {
  const veld = document.getElementById("zoek-lokaal-veld");
  const info = document.getElementById("zoek-info");
  const par = document.getElementById("paragrafen");
  const vorige = document.getElementById("vorige");
  const volgende = document.getElementById("volgende");
  let marks = [], huidig = -1;

  function ga(n) {
    if (!marks.length) return;
    marks[huidig]?.classList.remove("huidig");
    huidig = (n + marks.length) % marks.length;
    marks[huidig].classList.add("huidig");
    marks[huidig].scrollIntoView({ block: "center" });
    info.textContent = `${huidig + 1} van ${marks.length}`;
  }

  function zoek(waarde, spring = true) {
    verwijderMarkering(par);
    const termen = zoektermen(waarde);
    document.querySelectorAll(".inhoud-nav li").forEach((li) => { li.classList.remove("geen-treffer"); li.querySelector(".treffers").textContent = ""; });
    marks = []; huidig = -1;
    if (!termen.length) { info.textContent = ""; vorige.disabled = volgende.disabled = true; return; }
    markeer(par, termen);
    marks = [...par.querySelectorAll("mark")];
    document.querySelectorAll(".inhoud-nav li").forEach((li) => {
      const n = document.getElementById(li.dataset.sectie).querySelectorAll("mark").length;
      li.classList.toggle("geen-treffer", n === 0);
      li.querySelector(".treffers").textContent = n ? `(${n})` : "";
    });
    vorige.disabled = volgende.disabled = marks.length === 0;
    info.textContent = marks.length ? `${marks.length} treffers` : "Geen treffers";
    if (marks.length && spring) ga(0);
  }

  let timer;
  veld.addEventListener("input", () => { clearTimeout(timer); timer = setTimeout(() => zoek(veld.value), 200); });
  document.getElementById("zoek-lokaal").addEventListener("submit", (e) => { e.preventDefault(); marks.length ? ga(huidig + 1) : zoek(veld.value); });
  vorige.addEventListener("click", () => ga(huidig - 1));
  volgende.addEventListener("click", () => ga(huidig + 1));

  const q = params.get("q");
  if (q) { veld.value = q; zoek(q, !location.hash); }
}

function koppelInhoudActief() {
  const links = new Map([...document.querySelectorAll(".inhoud-nav a")].map((a) => [a.getAttribute("href").slice(1), a]));
  const obs = new IntersectionObserver((items) => {
    for (const it of items) {
      if (it.isIntersecting) {
        links.forEach((a) => a.classList.remove("actief"));
        links.get(it.target.id)?.classList.add("actief");
      }
    }
  }, { rootMargin: "0px 0px -70% 0px" });
  document.querySelectorAll(".paragraaf").forEach((s) => obs.observe(s));
}

function koppelVoorstellen(h) {
  document.getElementById("paragrafen").addEventListener("click", async (e) => {
    const knop = e.target.closest("[data-voorstel]");
    if (!knop) return;
    const sectie = h.sections.find((s) => s.id === knop.dataset.sectie);
    const uit = await openVoorstelFormulier({ soort: knop.dataset.voorstel, hoofdstuk: h.chapter, sectie });
    if (uit) location.href = `/voorstellen.html?id=${uit.id}&klaar=${uit.ingediend ? "ingediend" : "concept"}`;
  });
}

function koppelBijlagen(h) {
  document.querySelector(".zijkolom").addEventListener("click", async (e) => {
    const knop = e.target.closest("[data-bijlage]");
    if (!knop) return;
    const bijlage = knop.dataset.id ? h.attachments.find((a) => a.id === knop.dataset.id) : null;
    const uit = await openBijlageFormulier({ soort: knop.dataset.bijlage, hoofdstuk: h.chapter, bijlage });
    if (uit) location.href = `/voorstellen.html?id=${uit.id}&klaar=${uit.ingediend ? "ingediend" : "concept"}`;
  });
}

let vergelijkVenster = null;
function koppelVergelijken(h) {
  document.querySelectorAll("[data-vergelijk]").forEach((knop) => {
    knop.addEventListener("click", async () => {
      knop.disabled = true;
      try {
        const [{ versie: nieuw }, { versie: oud }] = await Promise.all([
          haalVersie(h.chapter.id, knop.dataset.vergelijk), haalVersie(h.chapter.id, knop.dataset.vorige)]);
        toonVergelijking(oud, nieuw);
      } catch (err) {
        alert(`De versies konden niet worden geladen. ${err.message}`);
      } finally {
        knop.disabled = false;
      }
    });
  });
}

function toonVergelijking(oud, nieuw) {
  if (!vergelijkVenster) {
    vergelijkVenster = document.createElement("dialog");
    vergelijkVenster.className = "voorstel-venster";
    document.body.appendChild(vergelijkVenster);
  }
  const oudMap = new Map(oud.sections.map((s) => [s.id, s]));
  const nieuwMap = new Map(nieuw.sections.map((s) => [s.id, s]));
  const blokken = [];
  for (const s of nieuw.sections) {
    const o = oudMap.get(s.id);
    const kop = (x) => (x.number ? x.number + " " : "") + x.title;
    if (!o) {
      blokken.push(`<h3>${escapeHtml(s.id)} · toegevoegd</h3><pre class="vergelijking"><ins>${escapeHtml(kop(s) + "\n\n" + s.body)}</ins></pre>`);
    } else if (o.body !== s.body || kop(o) !== kop(s)) {
      blokken.push(`<h3>${escapeHtml(s.id)} · gewijzigd</h3>
        ${kop(o) !== kop(s) ? `<pre class="vergelijking">${vergelijkHtml(kop(o), kop(s))}</pre>` : ""}
        ${o.body !== s.body ? `<pre class="vergelijking">${vergelijkHtml(o.body, s.body)}</pre>` : ""}`);
    } else if (o.review.date !== s.review.date) {
      blokken.push(`<h3>${escapeHtml(s.id)} · reviewdatum</h3><p>${datumNL(o.review.date)} → ${datumNL(s.review.date)}</p>`);
    }
  }
  for (const o of oud.sections) {
    if (!nieuwMap.has(o.id)) blokken.push(`<h3>${escapeHtml(o.id)} · verwijderd</h3><pre class="vergelijking"><del>${escapeHtml(o.body)}</del></pre>`);
  }
  vergelijkVenster.innerHTML = `
    <div class="vv">
      <header class="vv-kop">
        <span class="label">Versiegeschiedenis</span>
        <h2>Versie ${escapeHtml(nieuw.number)} vergeleken met ${escapeHtml(oud.number)}</h2>
        <p class="hulp">Verwijderde tekst is doorgestreept, nieuwe tekst is gemarkeerd.</p>
      </header>
      <div class="vv-inhoud">${blokken.join("") || "<p>Geen verschillen in de tekst.</p>"}</div>
      <footer class="vv-knoppen"><button type="button" class="knop tweede" data-sluit>Sluiten</button></footer>
    </div>`;
  vergelijkVenster.querySelector("[data-sluit]").addEventListener("click", () => vergelijkVenster.close());
  vergelijkVenster.showModal();
}

// Word-export: HTML-document dat Word opent (.doc). Altijd de goedgekeurde versie.
function exporteerWord(h) {
  const c = h.chapter, v = h.version;
  const vandaag = new Date().toISOString().slice(0, 10);
  const rood = getComputedStyle(document.documentElement).getPropertyValue("--fin-rood").trim() || "#D0011B";
  const secties = h.sections.map((s) => `
    <p class="meta">${s.id} · review ${datumNL(s.review?.date)}</p>
    <h2>${s.number ? `<span class="rood">${escapeHtml(s.number)}</span> ` : ""}${escapeHtml(s.title)}</h2>
    ${markdownNaarHtml(s.body)}`).join("");
  const html = `<!DOCTYPE html><html lang="nl"><head><meta charset="utf-8"><title>${escapeHtml(c.title)}</title>
    <style>
      body{font-family:Arial,sans-serif;font-size:11pt;color:#000}
      .balk{background:${rood};color:#fff;padding:6pt 10pt;font-weight:bold}
      h1{font-size:20pt} h2{font-size:14pt;margin-top:16pt} .rood{color:${rood}}
      .meta{font-size:8pt;color:#666;margin:14pt 0 0}
      table{border-collapse:collapse;width:100%} th,td{border:1px solid #ccc;padding:4pt;text-align:left;vertical-align:top}
      .voet{font-size:9pt;color:#666;border-top:1px solid #ccc;margin-top:24pt;padding-top:4pt}
    </style></head><body>
    <table class="balk-tabel" style="border:0"><tr><td class="balk" style="border:0">FinSport</td><td class="balk" style="border:0;text-align:right">Kennisbank Fin</td></tr></table>
    <h1><span class="rood">${tweeCijfers(c.number)}</span> ${escapeHtml(c.title)}</h1>
    <p>Versie ${escapeHtml(v.number)} (goedgekeurd, ${datumNL(v.date)}) · exportdatum ${datumNL(vandaag)}</p>
    ${secties}
    ${h.attachments?.length ? `<h2>Bijlagen</h2><ul>${h.attachments.map((a) => `<li><strong>${escapeHtml(a.title)}</strong> (${escapeHtml(BIJLAGE_NAAM[a.type] || a.type)}, ${datumNL(a.date)}) – ${escapeHtml(a.description || "")}${a.external ? ` – ${escapeHtml(a.url)}` : ` – bestand: ${escapeHtml(a.file_name || "")}`}</li>`).join("")}</ul>` : ""}
    <p class="voet">Hoofdstuk ${c.number} — ${escapeHtml(c.title)} · versie ${escapeHtml(v.number)} · exportdatum ${datumNL(vandaag)}</p>
    </body></html>`;
  const blob = new Blob(["\ufeff", html], { type: "application/msword" });
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = `Kennisbank-Fin_${c.id}_v${v.number}_${vandaag}.doc`;
  document.body.appendChild(a);
  a.click();
  setTimeout(() => { URL.revokeObjectURL(a.href); a.remove(); }, 1000);
}

beeldenTerugval();
kopZoekbalk(null);
toonRedacteurKeuze();
werkTellerBij();
haalHoofdstuk(id)
  .then(({ hoofdstuk }) => render(hoofdstuk))
  .catch((e) => toonFout(hoofdEl, `Dit hoofdstuk kon niet worden geladen. ${e.message}`));
