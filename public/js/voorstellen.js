// Pagina "Openstaande voorstellen": overzicht en één voorstel met beoordeling.
import {
  haalVoorstellen, haalVoorstel, voorstelActie, haalHoofdstuk, gekozenRedacteur,
  SOORT_NAAM, statusLabel, datumTijdNL, datumNL,
} from "./data.js";
import { escapeHtml, markdownNaarHtml } from "./tekst.js";
import { vergelijkHtml } from "./vergelijk.js";
import { openVoorstelFormulier, reviewTekst } from "./voorstelformulier.js";
import { openBijlageFormulier, bijlageSamenvatting } from "./bijlageformulier.js";
import { beeldenTerugval, kopZoekbalk, toonFout, toonRedacteurKeuze, werkTellerBij } from "./algemeen.js";

const params = new URLSearchParams(location.search);
const hoofdEl = document.getElementById("voorstellen");

function onderwerp(v) {
  if (v.soort === "nieuw_hoofdstuk") return `Nieuw hoofdstuk: ${v.hoofdstuk_titel || v.titel}`;
  if (v.soort.startsWith("bijlage_")) return `${v.hoofdstuk_id} · ${v.bijlage_id || "nieuwe bijlage"} · ${v.titel || ""}`;
  const plek = v.soort === "toevoegen" ? `na ${v.na_paragraaf_id}` : v.paragraaf_id;
  return `${v.hoofdstuk_id} · ${plek} · ${v.titel || ""}`;
}

function rijHtml(v) {
  return `<a class="vs-rij" href="/voorstellen.html?id=${v.id}">
    <span class="vs-nr num">#${v.id}</span>
    <span class="vs-hoofd">
      <strong>${escapeHtml(onderwerp(v))}</strong>
      <span class="hulp">${escapeHtml(SOORT_NAAM[v.soort])} · ${escapeHtml(v.auteur)} · ${datumTijdNL(v.ingediend_op || v.aangemaakt_op)}</span>
      <span>${escapeHtml(v.wat)}</span>
    </span>
    <span class="vs-status">${statusLabel(v.status)}</span>
  </a>`;
}

function groepHtml(titel, lijst, leeg) {
  return `<section class="vs-groep"><h2>${titel} <span class="hulp num">(${lijst.length})</span></h2>
    ${lijst.length ? lijst.map(rijHtml).join("") : `<p class="hulp">${leeg}</p>`}</section>`;
}

async function toonOverzicht() {
  const afgerond = params.get("groep") === "afgerond";
  const ik = gekozenRedacteur();
  const { voorstellen } = await haalVoorstellen(afgerond ? "afgerond" : "open", params.get("hoofdstuk") || "");

  let inhoud;
  if (afgerond) {
    inhoud = groepHtml("Afgeronde voorstellen", voorstellen, "Er zijn nog geen afgeronde voorstellen.");
  } else if (ik) {
    const teBeoordelen = voorstellen.filter((v) => v.status === "ter_validatie" && v.auteur !== ik);
    const mijnValidatie = voorstellen.filter((v) => v.status === "ter_validatie" && v.auteur === ik);
    const mijnConcepten = voorstellen.filter((v) => v.status === "concept" && v.auteur === ik);
    const andereConcepten = voorstellen.filter((v) => v.status === "concept" && v.auteur !== ik);
    const niets = !voorstellen.length;
    inhoud = (niets ? `
        <div class="vs-leeg" data-beeldvak>
          <img data-optioneel src="/assets/fin/fin-scene-alles-in-orde.png" alt="Fin met een factuur en de tekst Alles in orde">
          <p>Er liggen geen voorstellen open.</p>
        </div>` : "")
      + groepHtml("Wacht op jouw beoordeling", teBeoordelen, "Er ligt niets voor je klaar om te beoordelen.")
      + groepHtml("Jouw voorstellen ter validatie", mijnValidatie, "Je hebt geen voorstellen ter validatie.")
      + groepHtml("Jouw concepten", mijnConcepten, "Je hebt geen concepten.")
      + groepHtml("Concepten van de andere redacteur", andereConcepten, "Geen concepten.");
  } else {
    inhoud = `<p class="melding">Kies rechtsboven wie je bent. Dan zie je welke voorstellen op jouw beoordeling wachten.</p>`
      + groepHtml("Ter validatie", voorstellen.filter((v) => v.status === "ter_validatie"), "Geen voorstellen ter validatie.")
      + groepHtml("Concepten", voorstellen.filter((v) => v.status === "concept"), "Geen concepten.");
  }

  hoofdEl.innerHTML = `
    <div class="wrap vs-wrap">
      <nav class="kruimel" aria-label="Kruimelpad"><a href="/">Start</a> / Voorstellen</nav>
      <div class="vs-titel">
        <h1>${afgerond ? "Afgeronde voorstellen" : "Openstaande voorstellen"}</h1>
        <div class="vs-tabs">
          <a href="/voorstellen.html" ${afgerond ? "" : 'aria-current="page"'}>Open</a>
          <a href="/voorstellen.html?groep=afgerond" ${afgerond ? 'aria-current="page"' : ""}>Afgerond</a>
        </div>
      </div>
      ${params.get("hoofdstuk") ? `<p class="hulp">Alleen hoofdstuk ${escapeHtml(params.get("hoofdstuk"))}. <a href="/voorstellen.html${afgerond ? "?groep=afgerond" : ""}">Toon alles</a></p>` : ""}
      ${inhoud}
      <p class="vs-nieuw"><button type="button" class="knop tweede" id="nieuw-hoofdstuk">Nieuw hoofdstuk voorstellen</button></p>
    </div>`;
  document.getElementById("nieuw-hoofdstuk").addEventListener("click", nieuwHoofdstuk);
  beeldenTerugval(hoofdEl);
}

async function nieuwHoofdstuk() {
  const uit = await openVoorstelFormulier({ soort: "nieuw_hoofdstuk" });
  if (uit) location.href = `/voorstellen.html?id=${uit.id}&klaar=${uit.ingediend ? "ingediend" : "concept"}`;
}

function bestandLink(b) {
  if (!b || b.soort === "link" || !b.bestand_sleutel) return "";
  return `<p><a class="knop tweede klein" href="/api/bestand?sleutel=${encodeURIComponent(b.bestand_sleutel)}" download>Bestand openen: ${escapeHtml(b.bestandsnaam || "")}</a></p>`;
}

function vergelijkingHtml(v) {
  if (v.soort === "bijlage_toevoegen") {
    return `<p>Nieuwe bijlage:</p>${bijlageSamenvatting(v.bijlage)}${bestandLink(v.bijlage)}`;
  }
  if (v.soort === "bijlage_verwijderen") {
    return `<p>Deze bijlage vervalt na goedkeuring (ze blijft bewaard in de geschiedenis):</p>${bijlageSamenvatting(v.basis_bijlage)}`;
  }
  if (v.soort === "bijlage_wijzigen") {
    const o = v.basis_bijlage || {}, n = v.bijlage || {};
    const rij = (label, a, b) => a === b ? "" : `<p class="hulp">${label}</p><pre class="vergelijking">${vergelijkHtml(a || "", b || "")}</pre>`;
    const nieuwBestand = n.bestand_sleutel && n.bestand_sleutel !== o.bestand_sleutel;
    return rij("Soort", o.soort, n.soort) + rij("Titel", o.titel, n.titel) + rij("Omschrijving", o.omschrijving, n.omschrijving)
      + rij("Datum", datumNL(o.datum), datumNL(n.datum)) + rij("Webadres", o.url, n.url)
      + (nieuwBestand ? `<p class="hulp">Bestand</p><pre class="vergelijking"><del>${escapeHtml(o.bestandsnaam || "")}</del> <ins>${escapeHtml(n.bestandsnaam || "")}</ins></pre>${bestandLink(n)}` : "")
      + `<details class="vv-blok"><summary>Hele bijlage na de wijziging</summary>${bijlageSamenvatting(n)}</details>`;
  }
  if (v.soort === "nieuw_hoofdstuk") {
    return `<dl class="vs-velden">
        <dt>Titel</dt><dd>${escapeHtml(v.hoofdstuk_titel || "")}</dd>
        <dt>Korte omschrijving</dt><dd>${escapeHtml(v.hoofdstuk_omschrijving || "")}</dd>
      </dl>
      <h3>Inleiding</h3><div class="md vv-weergave">${markdownNaarHtml(v.nieuw_tekst || "")}</div>`;
  }
  if (v.soort === "verwijderen") {
    return `<p>Deze paragraaf verdwijnt uit het hoofdstuk:</p><pre class="vergelijking"><del>${escapeHtml(v.basis_tekst || "")}</del></pre>`;
  }
  if (v.soort === "toevoegen") {
    return `<p>Nieuwe paragraaf na ${escapeHtml(v.na_paragraaf_id)}:</p>
      <pre class="vergelijking"><ins>${escapeHtml((v.nieuw_nummer ? v.nieuw_nummer + " " : "") + v.nieuw_titel + "\n\n" + v.nieuw_tekst)}</ins></pre>
      <details class="vv-blok"><summary>Zo ziet het eruit</summary><div class="md vv-weergave"><h3>${escapeHtml(v.nieuw_titel)}</h3>${markdownNaarHtml(v.nieuw_tekst)}</div></details>`;
  }
  const titel = v.nieuw_titel !== v.basis_titel
    ? `<p class="hulp">Titel</p><pre class="vergelijking">${vergelijkHtml(v.basis_titel, v.nieuw_titel)}</pre>` : "";
  const tekst = v.nieuw_tekst !== v.basis_tekst
    ? `<p class="hulp">Tekst</p><pre class="vergelijking">${vergelijkHtml(v.basis_tekst, v.nieuw_tekst)}</pre>`
    : `<p class="hulp">De tekst zelf is niet gewijzigd.</p>`;
  return titel + tekst + `<details class="vv-blok"><summary>Zo ziet de nieuwe tekst eruit</summary><div class="md vv-weergave">${markdownNaarHtml(v.nieuw_tekst)}</div></details>`;
}

function uitkomstHtml(v, checklist) {
  if (v.status === "ingetrokken") return `<p class="melding">Dit voorstel is ingetrokken door ${escapeHtml(v.auteur)}.</p>`;
  const punten = checklist.map((c) => `<li>${v.checklist?.[c.id] ? "✓" : "–"} ${escapeHtml(c.tekst)}</li>`).join("");
  return `<div class="vs-uitkomst">
    <p>${statusLabel(v.status)} door <strong>${escapeHtml(v.beoordelaar || "")}</strong> op ${datumTijdNL(v.beoordeeld_op)}.</p>
    ${v.reden_afwijzing ? `<p><strong>Reden:</strong> ${escapeHtml(v.reden_afwijzing)}</p>` : ""}
    ${v.checklist ? `<ul class="vs-checklist-uitkomst">${punten}</ul>` : ""}
    ${v.status === "goedgekeurd" && v.hoofdstuk_id ? `<p><a href="/hoofdstuk.html?h=${escapeHtml(v.hoofdstuk_id)}${v.paragraaf_id ? "#" + escapeHtml(v.paragraaf_id) : v.bijlage_id || v.soort.startsWith("bijlage_") ? "#bijlagen-kop" : ""}">Bekijk de nieuwe versie van het hoofdstuk →</a></p>` : ""}
  </div>`;
}

function actiesHtml(v, checklist, ik) {
  if (!["concept", "ter_validatie"].includes(v.status)) return "";
  if (!ik) return `<p class="melding">Kies rechtsboven wie je bent om dit voorstel te bewerken of te beoordelen.</p>`;
  const eigen = v.auteur === ik;
  if (eigen && v.status === "concept") {
    return `<div class="vs-acties">
      <button type="button" class="knop hoofd" data-actie="indienen">Indienen ter validatie</button>
      <button type="button" class="knop tweede" data-actie="bewerken">Bewerken</button>
      <button type="button" class="knop tekstknop" data-actie="intrekken">Intrekken</button>
    </div>`;
  }
  if (eigen && v.status === "ter_validatie") {
    return `<p class="melding">Dit voorstel wacht op beoordeling door de andere redacteur. Je kunt het niet zelf goedkeuren.</p>
      <div class="vs-acties">
        <button type="button" class="knop tweede" data-actie="terug_naar_concept">Terug naar concept</button>
        <button type="button" class="knop tekstknop" data-actie="intrekken">Intrekken</button>
      </div>`;
  }
  if (!eigen && v.status === "concept") {
    return `<p class="melding">Dit is nog een concept van ${escapeHtml(v.auteur)}. Je kunt het beoordelen zodra het ter validatie is ingediend.</p>`;
  }
  // beoordelen door de andere redacteur
  return `<form class="vs-beoordeling" novalidate>
    <h2>Beoordelen</h2>
    ${v.achterhaald ? `<p class="melding fout">Deze paragraaf is gewijzigd sinds het voorstel werd gemaakt. Goedkeuren kan niet meer. Wijs het voorstel af met als reden "achterhaald".</p>` : ""}
    <fieldset class="vs-checklist">
      <legend>Checklist</legend>
      ${checklist.map((c) => `<label><input type="checkbox" name="${c.id}"> ${escapeHtml(c.tekst)}</label>`).join("")}
    </fieldset>
    <label class="vv-veld">Reden bij afwijzen
      <textarea class="veld" name="reden" rows="2" placeholder="Verplicht als je afwijst"></textarea>
    </label>
    <p class="melding fout" role="alert" hidden></p>
    <div class="vs-acties">
      <button type="button" class="knop hoofd" data-actie="goedkeuren" disabled>✓ Goedkeuren</button>
      <button type="button" class="knop tweede afwijzen" data-actie="afwijzen">✕ Afwijzen</button>
    </div>
  </form>`;
}

const BEVESTIGING = {
  ingediend: { tekst: "Je voorstel is ingediend. De andere redacteur beoordeelt het.", beeld: "fin-pose-ok.png", alt: "Fin maakt een oké-gebaar" },
  concept: { tekst: "Je voorstel is opgeslagen als concept. Dien het in als het klaar is.", beeld: "fin-pose-ok.png", alt: "Fin maakt een oké-gebaar" },
  goedgekeurd: { tekst: "Goedgekeurd. De nieuwe versie is nu de actuele versie; de oude staat in de versiegeschiedenis.", beeld: "fin-pose-duim.png", alt: "Fin steekt zijn duim op" },
  afgewezen: { tekst: "Het voorstel is afgewezen. De reden is vastgelegd.", beeld: null },
  ingetrokken: { tekst: "Het voorstel is ingetrokken.", beeld: null },
  terug_naar_concept: { tekst: "Het voorstel is teruggezet naar concept. Je kunt het nu bewerken.", beeld: null },
};

async function toonVoorstel(id) {
  const { voorstel: v, checklist } = await haalVoorstel(id);
  const ik = gekozenRedacteur();
  const klaar = BEVESTIGING[params.get("klaar")];
  let hoofdstukTitel = "";
  if (v.hoofdstuk_id) {
    try { hoofdstukTitel = (await haalHoofdstuk(v.hoofdstuk_id)).hoofdstuk.chapter.title; } catch { hoofdstukTitel = ""; }
  }

  hoofdEl.innerHTML = `
    <div class="wrap vs-wrap">
      <nav class="kruimel" aria-label="Kruimelpad"><a href="/">Start</a> / <a href="/voorstellen.html">Voorstellen</a> / #${v.id}</nav>
      ${klaar ? `<div class="vs-bevestiging" role="status">
          ${klaar.beeld ? `<span data-beeldvak><img data-optioneel src="/assets/fin/${klaar.beeld}" alt="${klaar.alt}"></span>` : ""}
          <p>${klaar.tekst}</p></div>` : ""}
      <header class="vs-kop">
        <span class="label">${escapeHtml(SOORT_NAAM[v.soort])}</span>
        <h1>Voorstel #${v.id}</h1>
        <p>${statusLabel(v.status)}</p>
      </header>

      <div class="vs-grid">
        <div>
          <dl class="vs-velden">
            <dt>Hoofdstuk</dt><dd>${v.hoofdstuk_id ? `<a href="/hoofdstuk.html?h=${escapeHtml(v.hoofdstuk_id)}${v.paragraaf_id ? "#" + escapeHtml(v.paragraaf_id) : ""}">${escapeHtml(v.hoofdstuk_id)} ${escapeHtml(hoofdstukTitel)}</a>` : "Nieuw hoofdstuk"}</dd>
            ${v.paragraaf_id ? `<dt>Paragraaf</dt><dd class="num">${escapeHtml(v.paragraaf_id)}</dd>` : ""}
            ${v.bijlage_id ? `<dt>Bijlage</dt><dd class="num">${escapeHtml(v.bijlage_id)}</dd>` : ""}
            <dt>Wat</dt><dd>${escapeHtml(v.wat)}</dd>
            <dt>Waarom</dt><dd>${escapeHtml(v.waarom)}</dd>
            <dt>Bron of onderbouwing</dt><dd>${escapeHtml(v.bron)}</dd>
            ${["wijzigen", "toevoegen", "nieuw_hoofdstuk"].includes(v.soort) ? `<dt>Reviewdatum</dt><dd>${escapeHtml(reviewTekst(v))}</dd>` : ""}
            <dt>Ingediend door</dt><dd>${escapeHtml(v.auteur)}</dd>
            <dt>Aangemaakt</dt><dd>${datumTijdNL(v.aangemaakt_op)}</dd>
            ${v.ingediend_op ? `<dt>Ingediend</dt><dd>${datumTijdNL(v.ingediend_op)}</dd>` : ""}
          </dl>
          ${v.achterhaald && v.status !== "ter_validatie" ? `<p class="melding fout">Let op: de paragraaf is gewijzigd sinds dit voorstel werd gemaakt. Maak een nieuw voorstel op basis van de actuele tekst.</p>` : ""}
          ${!["concept", "ter_validatie"].includes(v.status) ? uitkomstHtml(v, checklist) : ""}
          ${actiesHtml(v, checklist, ik)}
        </div>
        <section class="vs-vergelijking" aria-labelledby="vgl-kop">
          <h2 id="vgl-kop">${["wijzigen", "bijlage_wijzigen"].includes(v.soort) ? "Wat verandert er" : "Inhoud"}</h2>
          ${vergelijkingHtml(v)}
        </section>
      </div>
    </div>`;
  beeldenTerugval(hoofdEl);
  koppelActies(v);
}

function koppelActies(v) {
  const beoordeling = hoofdEl.querySelector(".vs-beoordeling");
  if (beoordeling) {
    const goed = beoordeling.querySelector('[data-actie="goedkeuren"]');
    const vakjes = [...beoordeling.querySelectorAll('input[type="checkbox"]')];
    const check = () => { goed.disabled = v.achterhaald || !vakjes.every((x) => x.checked); };
    vakjes.forEach((x) => x.addEventListener("change", check));
    check();
  }
  hoofdEl.querySelectorAll("[data-actie]").forEach((knop) => {
    knop.addEventListener("click", async () => {
      const actie = knop.dataset.actie;
      if (actie === "bewerken" && v.soort.startsWith("bijlage_")) {
        const h = (await haalHoofdstuk(v.hoofdstuk_id)).hoofdstuk;
        const bijlage = h.attachments.find((a) => a.id === v.bijlage_id) || null;
        const uit = await openBijlageFormulier({ soort: v.soort, hoofdstuk: h.chapter, bijlage, bestaand: v });
        if (uit) location.href = `/voorstellen.html?id=${v.id}&klaar=concept`;
        return;
      }
      if (actie === "bewerken") {
        let sectie = null, hoofdstuk = null;
        if (v.hoofdstuk_id) {
          const h = (await haalHoofdstuk(v.hoofdstuk_id)).hoofdstuk;
          hoofdstuk = h.chapter;
          sectie = h.sections.find((s) => s.id === (v.paragraaf_id || v.na_paragraaf_id))
            || { id: v.paragraaf_id || v.na_paragraaf_id, title: v.basis_titel, body: v.basis_tekst, number: null };
          if (v.soort === "wijzigen") sectie = { ...sectie, title: v.basis_titel, body: v.basis_tekst };
        }
        const uit = await openVoorstelFormulier({ soort: v.soort, hoofdstuk, sectie, bestaand: v });
        if (uit) location.href = `/voorstellen.html?id=${v.id}&klaar=concept`;
        return;
      }
      const invoer = { id: v.id, actie };
      const beoordeling = hoofdEl.querySelector(".vs-beoordeling");
      if (beoordeling && (actie === "goedkeuren" || actie === "afwijzen")) {
        invoer.checklist = Object.fromEntries([...beoordeling.querySelectorAll('input[type="checkbox"]')].map((x) => [x.name, x.checked]));
        invoer.reden = beoordeling.reden.value;
        if (actie === "afwijzen" && !invoer.reden.trim()) {
          const m = beoordeling.querySelector(".melding"); m.textContent = "Vul bij afwijzen een reden in."; m.hidden = false; beoordeling.reden.focus();
          return;
        }
      }
      if (actie === "intrekken" && !confirm("Weet je zeker dat je dit voorstel wilt intrekken? Het blijft zichtbaar bij de afgeronde voorstellen.")) return;
      hoofdEl.querySelectorAll("[data-actie]").forEach((k) => { k.disabled = true; });
      try {
        await voorstelActie(invoer);
        const klaar = { indienen: "ingediend", goedkeuren: "goedgekeurd", afwijzen: "afgewezen", intrekken: "ingetrokken", terug_naar_concept: "terug_naar_concept" }[actie];
        location.href = `/voorstellen.html?id=${v.id}&klaar=${klaar}`;
      } catch (e) {
        hoofdEl.querySelectorAll("[data-actie]").forEach((k) => { k.disabled = false; });
        const m = hoofdEl.querySelector(".vs-beoordeling .melding") || document.createElement("p");
        if (!m.parentElement) { m.className = "melding fout"; knop.closest(".vs-acties").after(m); }
        m.textContent = e.message; m.hidden = false;
      }
    });
  });
}

beeldenTerugval();
kopZoekbalk(null);
toonRedacteurKeuze(() => location.reload());
werkTellerBij();
const id = params.get("id");
(id ? toonVoorstel(id) : toonOverzicht())
  .then(() => { if (params.get("nieuw") === "hoofdstuk") nieuwHoofdstuk(); })
  .catch((e) => toonFout(hoofdEl, `De voorstellen konden niet worden geladen. ${e.message}`));
