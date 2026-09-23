import { haalKennisbank, aantalVerlopen, datumNL, tweeCijfers } from "./data.js";
import { platteTekst, normaliseer, zoektermen, scoor, fragment, markeer, escapeHtml } from "./tekst.js";
import { beeldenTerugval, kopZoekbalk, toonFout, toonRedacteurKeuze } from "./algemeen.js";

const tegelsEl = document.getElementById("tegels");
const signalenEl = document.getElementById("signalen");
const resultatenEl = document.getElementById("resultaten");
const standaardEl = document.getElementById("standaard");

let index = null; // zoekindex, per paragraaf

function tegelHtml(h) {
  const c = h.chapter;
  const verlopen = aantalVerlopen(h);
  const voorstellen = h.open_proposals ?? 0;
  return `
    <a class="tegel" href="/hoofdstuk.html?h=${c.id}">
      <span class="nr" aria-hidden="true">${tweeCijfers(c.number)}</span>
      <h3><span class="sr-only">Hoofdstuk ${c.number}: </span>${escapeHtml(c.title)}</h3>
      <p>${escapeHtml(c.description)}</p>
      <span class="meta">
        <span class="num">v${escapeHtml(h.version.number)} · ${datumNL(h.version.date)}</span>
        <span class="status goed"><span aria-hidden="true">✓</span> Goedgekeurd</span>
      </span>
      <span class="meta">
        <span class="num">${voorstellen} ${voorstellen === 1 ? "voorstel" : "voorstellen"} open</span>
        ${verlopen
          ? `<span class="status verlopen"><span aria-hidden="true">!</span> ${verlopen} review${verlopen === 1 ? "" : "s"} verlopen</span>`
          : `<span class="num">0 reviews verlopen</span>`}
      </span>
      <span class="pijl" aria-hidden="true">→</span>
    </a>`;
}

async function laadStart() {
  try {
    const { hoofdstukken } = await haalKennisbank();

    tegelsEl.innerHTML = hoofdstukken.map(tegelHtml).join("") + `
      <a class="tegel nieuw" href="/voorstellen.html?nieuw=hoofdstuk">
        <span class="plus" aria-hidden="true">+</span>
        <strong>Hoofdstuk toevoegen</strong>
        <span class="hulp">Een nieuw hoofdstuk gaat ook door de goedkeuring.</span>
      </a>`;

    const totVerlopen = hoofdstukken.reduce((n, h) => n + aantalVerlopen(h), 0);
    const totVoorstellen = hoofdstukken.reduce((n, h) => n + (h.open_proposals ?? 0), 0);
    const totParagrafen = hoofdstukken.reduce((n, h) => n + h.sections.length, 0);
    document.querySelectorAll("[data-teller-voorstellen]").forEach((el) => { el.textContent = totVoorstellen; });
    signalenEl.innerHTML = `
      <a class="signaal" href="/voorstellen.html"><strong>${totVoorstellen}</strong><span>voorstellen wachten op beoordeling</span></a>
      <div class="signaal ${totVerlopen ? "let-op" : ""}"><strong>${totVerlopen}</strong><span>paragrafen met verlopen reviewdatum</span></div>
      <div class="signaal"><strong>${hoofdstukken.length}</strong><span>hoofdstukken, ${totParagrafen} paragrafen</span></div>`;

    index = hoofdstukken.flatMap((h) => h.sections.map((s) => {
      const plat = platteTekst(s.body);
      return {
        hoofdstuk: h.chapter, sectie: s, plat,
        titelNorm: normaliseer((s.number ? s.number + " " : "") + s.title),
        tekstNorm: normaliseer(plat),
      };
    }));

    const q = new URLSearchParams(location.search).get("q");
    if (q) zoek(q);
  } catch (e) {
    toonFout(document.getElementById("main"), `De kennisbank kon niet worden geladen. ${e.message}`);
  }
}

function zoek(invoer) {
  const url = new URL(location.href);
  if (invoer) url.searchParams.set("q", invoer); else url.searchParams.delete("q");
  history.replaceState(null, "", url);

  const termen = zoektermen(invoer);
  if (!termen.length || !index) {
    resultatenEl.hidden = true;
    standaardEl.hidden = false;
    return;
  }
  const treffers = index
    .map((r) => ({ ...r, score: scoor(r.titelNorm, r.tekstNorm, termen) }))
    .filter((r) => r.score > 0);

  standaardEl.hidden = true;
  resultatenEl.hidden = false;
  resultatenEl.innerHTML = "";

  const wrap = document.createElement("div");
  wrap.className = "wrap";
  const kop = document.createElement("h2");
  kop.textContent = `Zoekresultaten voor “${invoer}”`;
  const info = document.createElement("p");
  info.className = "hulp";
  wrap.append(kop, info);

  if (!treffers.length) {
    info.textContent = "Geen paragrafen gevonden waarin al deze woorden voorkomen. Probeer minder of andere woorden.";
    wrap.insertAdjacentHTML("beforeend", `
      <div class="leeg" data-beeldvak><img data-optioneel src="/assets/fin/fin-pose-nadenken.png" alt="Fin kijkt nadenkend, met een vraagteken boven zijn hoofd"></div>`);
    resultatenEl.appendChild(wrap);
    beeldenTerugval(resultatenEl);
    return;
  }

  const groepen = new Map();
  for (const t of treffers) {
    if (!groepen.has(t.hoofdstuk.id)) groepen.set(t.hoofdstuk.id, []);
    groepen.get(t.hoofdstuk.id).push(t);
  }
  info.textContent = `${treffers.length} ${treffers.length === 1 ? "paragraaf" : "paragrafen"} in ${groepen.size} ${groepen.size === 1 ? "hoofdstuk" : "hoofdstukken"}.`;

  const q = encodeURIComponent(invoer);
  for (const [, lijst] of groepen) {
    lijst.sort((a, b) => b.score - a.score);
    const h = lijst[0].hoofdstuk;
    const sectie = document.createElement("section");
    sectie.className = "res-hoofdstuk";
    const h3 = document.createElement("h3");
    h3.textContent = `Hoofdstuk ${h.number} — ${h.title} (${lijst.length})`;
    sectie.appendChild(h3);
    for (const t of lijst) {
      const a = document.createElement("a");
      a.className = "res-item";
      a.href = `/hoofdstuk.html?h=${h.id}&q=${q}#${t.sectie.id}`;
      const titel = document.createElement("span");
      titel.className = "res-titel";
      titel.textContent = `${t.sectie.number ? t.sectie.number + " " : ""}${t.sectie.title}`;
      const id = document.createElement("span");
      id.className = "hulp num";
      id.textContent = `  ${t.sectie.id}`;
      const p = document.createElement("p");
      p.textContent = fragment(t.plat, termen);
      a.append(titel, id, p);
      markeer(titel, termen);
      markeer(p, termen);
      sectie.appendChild(a);
    }
    wrap.appendChild(sectie);
  }
  resultatenEl.appendChild(wrap);
}

beeldenTerugval();
kopZoekbalk(zoek);
toonRedacteurKeuze();
laadStart();
