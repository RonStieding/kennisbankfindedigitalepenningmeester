// Formulier voor een voorstel: paragraaf wijzigen, toevoegen of verwijderen, of een nieuw hoofdstuk.
// Opent als venster over de pagina. Na opslaan ga je naar het voorstel.
import { maakVoorstel, voorstelActie, gekozenRedacteur, kiesRedacteur, haalRedacteuren, SOORT_NAAM, datumNL } from "./data.js";
import { markdownNaarHtml, escapeHtml } from "./tekst.js";
import { vergelijkHtml } from "./vergelijk.js";

let venster = null;

function maakVenster() {
  venster = document.createElement("dialog");
  venster.className = "voorstel-venster";
  venster.setAttribute("aria-labelledby", "vv-kop");
  document.body.appendChild(venster);
  venster.addEventListener("cancel", (e) => { if (venster.dataset.bezig) e.preventDefault(); });
}

function veld(label, invoer, hulp = "") {
  return `<label class="vv-veld">${label}${hulp ? `<span class="hulp">${hulp}</span>` : ""}${invoer}</label>`;
}

// opties: { soort, hoofdstuk: {id, title}, sectie, bestaand }
export async function openVoorstelFormulier(opties) {
  if (!venster) maakVenster();
  const { soort, hoofdstuk, sectie, bestaand } = opties;
  const b = bestaand || {};
  const metTekst = soort === "wijzigen" || soort === "toevoegen";
  const basisTekst = soort === "wijzigen" ? sectie.body : "";
  const basisTitel = soort === "wijzigen" ? sectie.title : "";

  let namen = [];
  try { namen = await haalRedacteuren(); } catch { namen = []; }

  const kop = {
    wijzigen: `Wijziging voorstellen voor ${sectie?.id ?? ""}`,
    toevoegen: `Nieuwe paragraaf voorstellen na ${sectie?.id ?? ""}`,
    verwijderen: `Verwijderen voorstellen van ${sectie?.id ?? ""}`,
    nieuw_hoofdstuk: "Nieuw hoofdstuk voorstellen",
  }[soort];

  const termijnNu = sectie?.review?.term_months ?? 12;
  venster.innerHTML = `
    <form method="dialog" class="vv" novalidate>
      <header class="vv-kop">
        <span class="label">${escapeHtml(SOORT_NAAM[soort])}${hoofdstuk ? ` · Hoofdstuk ${hoofdstuk.number}` : ""}</span>
        <h2 id="vv-kop">${escapeHtml(kop)}</h2>
        ${sectie && soort !== "toevoegen" ? `<p class="hulp">${escapeHtml((sectie.number ? sectie.number + " " : "") + sectie.title)}</p>` : ""}
      </header>

      <div class="vv-inhoud">
        <div class="vv-naam" ${gekozenRedacteur() ? "hidden" : ""}>
          ${veld("Wie ben je?", `<select class="veld" name="redacteur"><option value="">kies je naam</option>${namen.map((n) => `<option>${escapeHtml(n)}</option>`).join("")}</select>`, "Je naam komt bij het voorstel te staan.")}
        </div>

        ${soort === "nieuw_hoofdstuk" ? `
          ${veld("Titel van het hoofdstuk", `<input class="veld" name="hoofdstuk_titel" maxlength="200" required value="${escapeHtml(b.hoofdstuk_titel || "")}">`)}
          ${veld("Korte omschrijving", `<textarea class="veld" name="hoofdstuk_omschrijving" rows="2" required>${escapeHtml(b.hoofdstuk_omschrijving || "")}</textarea>`, "Eén of twee zinnen. Deze tekst staat op de tegel op de startpagina.")}
          ${veld("Inleiding", `<textarea class="veld vv-tekst" name="nieuw_tekst" rows="8" required>${escapeHtml(b.nieuw_tekst || "")}</textarea>`, "De eerste paragraaf van het hoofdstuk. Meer paragrafen voeg je na goedkeuring toe.")}
        ` : ""}

        ${soort === "verwijderen" ? `
          <div class="vv-blok"><span class="label">Deze tekst verdwijnt</span>
            <pre class="vergelijking"><del>${escapeHtml(sectie.body)}</del></pre></div>
        ` : ""}

        ${metTekst ? `
          <div class="vv-rij">
            ${veld("Nummer", `<input class="veld" name="nieuw_nummer" maxlength="20" value="${escapeHtml(b.nieuw_nummer ?? (soort === "wijzigen" ? sectie.number ?? "" : ""))}">`, "Mag leeg blijven.")}
            ${veld("Titel of vraag", `<input class="veld" name="nieuw_titel" maxlength="200" required value="${escapeHtml(b.nieuw_titel ?? basisTitel)}">`)}
          </div>
          ${veld("Tekst", `<textarea class="veld vv-tekst" name="nieuw_tekst" rows="14" required>${escapeHtml(b.nieuw_tekst ?? basisTekst)}</textarea>`,
            "Opmaak: lege regel = nieuwe alinea; regel met <code>- </code> = opsomming; <code>**vet**</code>; link: <code>[naam](https://…)</code>. Verwijs naar andere paragrafen met hun ID, bijvoorbeeld H03-P04.")}
          <div class="vv-rij">
            ${veld("Reviewtermijn in maanden", `<input class="veld" type="number" min="1" max="60" name="reviewtermijn_maanden" value="${escapeHtml(String(b.reviewtermijn_maanden ?? ""))}" placeholder="${termijnNu}">`, `Leeg = ${termijnNu} maanden na goedkeuring.`)}
            ${veld("Of een vaste reviewdatum", `<input class="veld" type="date" name="vaste_reviewdatum" value="${escapeHtml(b.vaste_reviewdatum || "")}">`, "Bijvoorbeeld bij bedragen die per 1 januari wijzigen.")}
          </div>
          <details class="vv-blok" ${soort === "wijzigen" ? "open" : ""}>
            <summary>${soort === "wijzigen" ? "Vergelijking met de huidige tekst" : "Voorbeeld"}</summary>
            <div class="vv-voorbeeld"></div>
          </details>
        ` : ""}

        <fieldset class="vv-onderbouwing">
          <legend>Onderbouwing</legend>
          ${veld("Wat wijzig je?", `<textarea class="veld" name="wat" rows="2" required>${escapeHtml(b.wat || "")}</textarea>`)}
          ${veld("Waarom?", `<textarea class="veld" name="waarom" rows="2" required>${escapeHtml(b.waarom || "")}</textarea>`)}
          ${veld("Bron of onderbouwing", `<textarea class="veld" name="bron" rows="2" required>${escapeHtml(b.bron || "")}</textarea>`, "Bij bedragen, percentages, termijnen en regels: noem ook de peildatum of het jaar.")}
        </fieldset>

        <p class="melding fout" role="alert" hidden></p>
      </div>

      <footer class="vv-knoppen">
        <button type="button" class="knop tekstknop" data-actie="annuleren">Annuleren</button>
        <button type="button" class="knop tweede" data-actie="concept">Opslaan als concept</button>
        ${bestaand ? "" : `<button type="button" class="knop hoofd" data-actie="indienen">Indienen ter validatie</button>`}
      </footer>
    </form>`;

  const form = venster.querySelector("form");
  const melding = form.querySelector(".melding");
  const voorbeeld = form.querySelector(".vv-voorbeeld");

  function werkVoorbeeldBij() {
    if (!voorbeeld) return;
    const titel = form.nieuw_titel.value, tekst = form.nieuw_tekst.value;
    if (soort === "wijzigen") {
      const titelDeel = titel !== basisTitel ? `<p class="hulp">Titel</p><pre class="vergelijking">${vergelijkHtml(basisTitel, titel)}</pre>` : "";
      const tekstDeel = tekst !== basisTekst ? `<pre class="vergelijking">${vergelijkHtml(basisTekst, tekst)}</pre>` : `<p class="hulp">De tekst is nog niet gewijzigd.</p>`;
      voorbeeld.innerHTML = titelDeel + tekstDeel + `<p class="hulp">Zo ziet de nieuwe tekst eruit:</p><div class="md vv-weergave">${markdownNaarHtml(tekst)}</div>`;
    } else {
      voorbeeld.innerHTML = `<div class="md vv-weergave"><h3>${escapeHtml(titel)}</h3>${markdownNaarHtml(tekst)}</div>`;
    }
  }
  if (voorbeeld) {
    let t;
    form.addEventListener("input", (e) => {
      if (!["nieuw_titel", "nieuw_tekst"].includes(e.target.name)) return;
      clearTimeout(t); t = setTimeout(werkVoorbeeldBij, 250);
    });
    werkVoorbeeldBij();
  }

  return new Promise((klaar) => {
    const sluit = (uitkomst) => { venster.close(); klaar(uitkomst); };
    form.querySelector('[data-actie="annuleren"]').addEventListener("click", () => sluit(null));

    async function verstuur(indienen) {
      melding.hidden = true;
      if (!gekozenRedacteur()) {
        const keuze = form.redacteur?.value;
        if (!keuze) { melding.textContent = "Kies eerst je naam."; melding.hidden = false; form.redacteur?.focus(); return; }
        kiesRedacteur(keuze);
        const kopKeuze = document.getElementById("ik-ben");
        if (kopKeuze) { kopKeuze.value = keuze; kopKeuze.classList.remove("nog-kiezen"); }
      }
      const g = Object.fromEntries(new FormData(form).entries());
      delete g.redacteur;
      const leeg = [...form.querySelectorAll("[required]")].find((el) => !el.value.trim());
      if (leeg) { melding.textContent = "Vul alle verplichte velden in."; melding.hidden = false; leeg.focus(); return; }

      venster.dataset.bezig = "1";
      form.querySelectorAll("button").forEach((k) => { k.disabled = true; });
      try {
        let uit;
        if (bestaand) {
          uit = await voorstelActie({ ...g, id: bestaand.id, actie: "bewerken" });
        } else {
          uit = await maakVoorstel({
            ...g, soort, indienen,
            hoofdstuk_id: hoofdstuk?.id, paragraaf_id: sectie?.id,
            na_paragraaf_id: soort === "toevoegen" ? sectie.id : undefined,
          });
        }
        delete venster.dataset.bezig;
        sluit({ id: uit.id ?? bestaand?.id, ingediend: indienen });
      } catch (e) {
        delete venster.dataset.bezig;
        form.querySelectorAll("button").forEach((k) => { k.disabled = false; });
        melding.textContent = e.message;
        melding.hidden = false;
      }
    }
    form.querySelector('[data-actie="concept"]').addEventListener("click", () => verstuur(false));
    form.querySelector('[data-actie="indienen"]')?.addEventListener("click", () => verstuur(true));

    venster.showModal();
    (form.querySelector(".vv-naam:not([hidden]) select") || form.querySelector("input, textarea"))?.focus();
  });
}

export function reviewTekst(v) {
  if (v.vaste_reviewdatum) return `vaste reviewdatum ${datumNL(v.vaste_reviewdatum)}`;
  if (v.reviewtermijn_maanden) return `${v.reviewtermijn_maanden} maanden na goedkeuring`;
  return "standaardtermijn na goedkeuring";
}
