// Formulier voor een bijlage-voorstel: toevoegen, wijzigen of laten vervallen.
// Bestanden: Word, pdf en Excel, maximaal 5 MB. Een bestand wordt eerst geüpload en is pas
// zichtbaar in de kennisbank nadat de andere redacteur het voorstel heeft goedgekeurd.
import {
  maakVoorstel, voorstelActie, uploadBestand, gekozenRedacteur, kiesRedacteur, haalRedacteuren,
  SOORT_NAAM, BIJLAGE_NAAM, BESTAND_EXTENSIES, grootteTekst, datumNL,
} from "./data.js";
import { escapeHtml } from "./tekst.js";

let venster = null;

function vandaagIso() {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
}

function veld(label, invoer, hulp = "") {
  return `<label class="vv-veld">${label}${hulp ? `<span class="hulp">${hulp}</span>` : ""}${invoer}</label>`;
}

export function bijlageSamenvatting(b) {
  if (!b) return "";
  const bestand = b.soort === "link" || b.type === "link"
    ? `<a href="${escapeHtml(b.url)}" target="_blank" rel="noopener noreferrer">${escapeHtml(b.url)}</a>`
    : `${escapeHtml(b.bestandsnaam || b.file_name || "")} ${b.grootte || b.file_size ? `(${grootteTekst(b.grootte || b.file_size)})` : ""}`;
  return `<dl class="vs-velden">
    <dt>Soort</dt><dd>${escapeHtml(BIJLAGE_NAAM[b.soort || b.type] || "")}</dd>
    <dt>Titel</dt><dd>${escapeHtml(b.titel || b.title || "")}</dd>
    <dt>Omschrijving</dt><dd>${escapeHtml(b.omschrijving || b.description || "")}</dd>
    <dt>Datum</dt><dd>${datumNL(b.datum || b.date)}</dd>
    <dt>${(b.soort || b.type) === "link" ? "Adres" : "Bestand"}</dt><dd>${bestand}</dd>
  </dl>`;
}

// opties: { soort: 'bijlage_toevoegen' | 'bijlage_wijzigen' | 'bijlage_verwijderen', hoofdstuk, bijlage (huidige), bestaand (voorstel) }
export async function openBijlageFormulier({ soort, hoofdstuk, bijlage, bestaand }) {
  if (!venster) {
    venster = document.createElement("dialog");
    venster.className = "voorstel-venster";
    venster.setAttribute("aria-labelledby", "bv-kop");
    document.body.appendChild(venster);
    venster.addEventListener("cancel", (e) => { if (venster.dataset.bezig) e.preventDefault(); });
  }
  let namen = [];
  try { namen = await haalRedacteuren(); } catch { namen = []; }

  // Beginwaarden: uit het voorstel dat wordt bewerkt, anders uit de huidige bijlage.
  const b = bestaand?.bijlage || (bijlage ? {
    soort: bijlage.type, titel: bijlage.title, omschrijving: bijlage.description, datum: bijlage.date,
    url: bijlage.external ? bijlage.url : "", bestandsnaam: bijlage.file_name, grootte: bijlage.file_size,
  } : { soort: "download", datum: vandaagIso() });
  const verwijderen = soort === "bijlage_verwijderen";
  const huidigBestand = b.soort !== "link" && b.bestandsnaam ? `${b.bestandsnaam} (${grootteTekst(b.grootte)})` : "";

  const kop = {
    bijlage_toevoegen: "Bijlage voorstellen",
    bijlage_wijzigen: `Wijziging voorstellen voor ${bijlage?.id ?? bestaand?.bijlage_id ?? ""}`,
    bijlage_verwijderen: `Bijlage ${bijlage?.id ?? bestaand?.bijlage_id ?? ""} laten vervallen`,
  }[soort];

  venster.innerHTML = `
    <form method="dialog" class="vv" novalidate>
      <header class="vv-kop">
        <span class="label">${escapeHtml(SOORT_NAAM[soort])} · Hoofdstuk ${hoofdstuk.number}</span>
        <h2 id="bv-kop">${escapeHtml(kop)}</h2>
      </header>
      <div class="vv-inhoud">
        <div class="vv-naam" ${gekozenRedacteur() ? "hidden" : ""}>
          ${veld("Wie ben je?", `<select class="veld" name="redacteur"><option value="">kies je naam</option>${namen.map((n) => `<option>${escapeHtml(n)}</option>`).join("")}</select>`)}
        </div>

        ${verwijderen ? `
          <p>Deze bijlage verdwijnt uit het hoofdstuk na goedkeuring. Ze blijft bewaard in de geschiedenis.</p>
          ${bijlageSamenvatting(bijlage ? { ...b } : bestaand?.basis_bijlage)}
        ` : `
          <fieldset class="bv-soort">
            <legend>Soort bijlage</legend>
            ${Object.entries(BIJLAGE_NAAM).map(([w, n]) => `<label><input type="radio" name="bijlage_soort" value="${w}" ${b.soort === w ? "checked" : ""}> ${n}</label>`).join("")}
          </fieldset>
          ${veld("Titel", `<input class="veld" name="bijlage_titel" maxlength="200" required value="${escapeHtml(b.titel || "")}">`)}
          ${veld("Omschrijving", `<textarea class="veld" name="bijlage_omschrijving" rows="2" required>${escapeHtml(b.omschrijving || "")}</textarea>`, "Eén of twee zinnen: wat is het en wanneer gebruik je het?")}
          ${veld("Datum", `<input class="veld" type="date" name="bijlage_datum" required value="${escapeHtml(b.datum || vandaagIso())}">`, "Datum of peildatum van het document.")}
          <div class="bv-bestand">
            ${veld("Bestand", `<input class="veld" type="file" name="bestand" accept="${BESTAND_EXTENSIES.map((e) => "." + e).join(",")}">`,
              `Word, pdf of Excel, maximaal 5 MB.${huidigBestand ? ` Huidig bestand: <strong>${escapeHtml(huidigBestand)}</strong>. Kies alleen een nieuw bestand als je het wilt vervangen.` : ""}`)}
          </div>
          <div class="bv-link">
            ${veld("Webadres", `<input class="veld" type="url" name="bijlage_url" placeholder="https://" value="${escapeHtml(b.url || "")}">`)}
          </div>
        `}

        <fieldset class="vv-onderbouwing">
          <legend>Onderbouwing</legend>
          ${veld("Wat wijzig je?", `<textarea class="veld" name="wat" rows="2" required>${escapeHtml(bestaand?.wat || "")}</textarea>`)}
          ${veld("Waarom?", `<textarea class="veld" name="waarom" rows="2" required>${escapeHtml(bestaand?.waarom || "")}</textarea>`)}
          ${veld("Bron of onderbouwing", `<textarea class="veld" name="bron" rows="2" required>${escapeHtml(bestaand?.bron || "")}</textarea>`)}
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
  const toonVelden = () => {
    const s = form.querySelector('input[name="bijlage_soort"]:checked')?.value;
    form.querySelector(".bv-bestand")?.toggleAttribute("hidden", s === "link");
    form.querySelector(".bv-link")?.toggleAttribute("hidden", s !== "link");
  };
  form.querySelectorAll('input[name="bijlage_soort"]').forEach((r) => r.addEventListener("change", toonVelden));
  toonVelden();

  return new Promise((klaar) => {
    const sluit = (uit) => { venster.close(); klaar(uit); };
    form.querySelector('[data-actie="annuleren"]').addEventListener("click", () => sluit(null));

    async function verstuur(indienen) {
      melding.hidden = true;
      if (!gekozenRedacteur()) {
        const keuze = form.redacteur?.value;
        if (!keuze) { melding.textContent = "Kies eerst je naam."; melding.hidden = false; return; }
        kiesRedacteur(keuze);
        const kopKeuze = document.getElementById("ik-ben");
        if (kopKeuze) { kopKeuze.value = keuze; kopKeuze.classList.remove("nog-kiezen"); }
      }
      const verplicht = [...form.querySelectorAll("[required]")].filter((el) => !el.closest("[hidden]"));
      const leeg = verplicht.find((el) => !el.value.trim());
      if (leeg) { melding.textContent = "Vul alle verplichte velden in."; melding.hidden = false; leeg.focus(); return; }

      const gegevens = {
        wat: form.wat.value, waarom: form.waarom.value, bron: form.bron.value,
      };
      let bestand = null;
      if (!verwijderen) {
        gegevens.bijlage_soort = form.querySelector('input[name="bijlage_soort"]:checked')?.value;
        gegevens.bijlage_titel = form.bijlage_titel.value;
        gegevens.bijlage_omschrijving = form.bijlage_omschrijving.value;
        gegevens.bijlage_datum = form.bijlage_datum.value;
        if (gegevens.bijlage_soort === "link") {
          gegevens.bijlage_url = form.bijlage_url.value.trim();
          if (!/^https?:\/\/\S+$/i.test(gegevens.bijlage_url)) { melding.textContent = "Vul een volledig webadres in, beginnend met https://"; melding.hidden = false; form.bijlage_url.focus(); return; }
        } else {
          bestand = form.bestand.files[0] || null;
          if (!bestand && !huidigBestand) { melding.textContent = "Kies een bestand om te uploaden."; melding.hidden = false; form.bestand.focus(); return; }
        }
      }

      venster.dataset.bezig = "1";
      const knoppen = [...form.querySelectorAll("button")];
      knoppen.forEach((k) => { k.disabled = true; });
      const hoofdknop = form.querySelector(`[data-actie="${indienen ? "indienen" : "concept"}"]`);
      const oudeTekst = hoofdknop.textContent;
      try {
        if (bestand) {
          hoofdknop.textContent = "Bestand uploaden…";
          const up = await uploadBestand(bestand);
          gegevens.bestand_sleutel = up.sleutel;
        }
        hoofdknop.textContent = "Opslaan…";
        let uit;
        if (bestaand) {
          uit = await voorstelActie({ ...gegevens, id: bestaand.id, actie: "bewerken" });
        } else {
          uit = await maakVoorstel({ ...gegevens, soort, indienen, hoofdstuk_id: hoofdstuk.id, bijlage_id: bijlage?.id });
        }
        delete venster.dataset.bezig;
        sluit({ id: uit.id ?? bestaand?.id, ingediend: indienen });
      } catch (e) {
        delete venster.dataset.bezig;
        hoofdknop.textContent = oudeTekst;
        knoppen.forEach((k) => { k.disabled = false; });
        melding.textContent = e.message;
        melding.hidden = false;
      }
    }
    form.querySelector('[data-actie="concept"]').addEventListener("click", () => verstuur(false));
    form.querySelector('[data-actie="indienen"]')?.addEventListener("click", () => verstuur(true));
    venster.showModal();
  });
}
