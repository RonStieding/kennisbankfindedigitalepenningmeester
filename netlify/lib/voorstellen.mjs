// Workflow voor voorstellen. Alle regels worden hier aan de serverkant afgedwongen;
// de database controleert de belangrijkste regels daarnaast nog een keer.
//
// Statussen: concept → ter_validatie → goedgekeurd | afgewezen (met reden).
// Een indiener kan een voorstel terugzetten naar concept of intrekken zolang het niet is beoordeeld.

import { db, fout } from "./server.mjs";
import { vandaagNL, plusMaanden, geldigeDatum } from "./datum.mjs";
import { controlegetal, bronnenUit, schoon, volgendeVersie } from "./tekstregels.mjs";
import { gegevensVan } from "./bestanden.mjs";

export const CHECKLIST = [
  { id: "inhoud", tekst: "Klopt het inhoudelijk?" },
  { id: "bron", tekst: "Is de bron vermeld?" },
  { id: "peildatum", tekst: "Is de peildatum actueel?" },
  { id: "tegenstrijdig", tekst: "Is er geen tegenstrijdigheid met andere hoofdstukken?" },
  { id: "b1", tekst: "Is het begrijpelijk op B1-niveau?" },
];

const MAX = { titel: 200, tekst: 20000, veld: 3000 };
const SOORTEN = ["wijzigen", "toevoegen", "verwijderen", "nieuw_hoofdstuk", "bijlage_toevoegen", "bijlage_wijzigen", "bijlage_verwijderen"];
const BIJLAGESOORTEN = ["download", "template", "stappenplan", "link"];
const IS_BIJLAGE = (soort) => soort.startsWith("bijlage_");

// ---------- kleine hulpjes ----------

async function query(client, tekst, params = []) {
  const res = await client.query(tekst, params);
  return res.rows;
}

async function inTransactie(werk) {
  const client = await db().pool.connect();
  try {
    await client.query("BEGIN");
    const uitkomst = await werk(client);
    await client.query("COMMIT");
    return uitkomst;
  } catch (e) {
    try { await client.query("ROLLBACK"); } catch { /* verbinding al weg */ }
    throw e;
  } finally {
    client.release();
  }
}

function veld(invoer, naam, max, verplicht = true) {
  const w = schoon(invoer?.[naam], max);
  if (w && typeof w === "object" && w.teLang) throw fout(400, `Het veld "${naam}" is te lang (maximaal ${max} tekens).`);
  if (verplicht && !w) throw fout(400, `Vul het veld "${naam}" in.`);
  return w || null;
}

async function actueleVersie(client, hoofdstukId) {
  const [v] = await query(client, `
    SELECT id, hoofdstuk_id, versie, titel, omschrijving, kop_origineel
    FROM hoofdstuk_versie
    WHERE hoofdstuk_id = $1 AND status = 'goedgekeurd'
    ORDER BY id DESC LIMIT 1`, [hoofdstukId]);
  return v || null;
}

async function paragrafen(client, versieId) {
  return query(client, `
    SELECT paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen,
           CAST(reviewdatum AS TEXT) AS reviewdatum, reviewtermijn_maanden, controlegetal
    FROM paragraaf WHERE hoofdstuk_versie_id = $1 ORDER BY volgorde`, [versieId]);
}

async function logboek(client, gebruiker, actie, onderwerp, details) {
  await query(client, "INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ($1, $2, $3, $4)",
    [gebruiker, actie, onderwerp, details]);
}

async function haalVoorstel(client, id, opslot = false) {
  const [v] = await query(client,
    `SELECT *, CAST(vaste_reviewdatum AS TEXT) AS vaste_reviewdatum_tekst, CAST(bijlage_datum AS TEXT) AS bijlage_datum_tekst
     FROM voorstel WHERE id = $1${opslot ? " FOR UPDATE" : ""}`, [id]);
  if (!v) throw fout(404, `Voorstel ${id} bestaat niet.`);
  return v;
}

function reviewInvoer(invoer) {
  let termijn = invoer?.reviewtermijn_maanden;
  if (termijn === "" || termijn === undefined || termijn === null) termijn = null;
  else {
    termijn = Number(termijn);
    if (!Number.isInteger(termijn) || termijn < 1 || termijn > 60) throw fout(400, "De reviewtermijn moet tussen 1 en 60 maanden liggen.");
  }
  let vast = invoer?.vaste_reviewdatum || null;
  if (vast) {
    if (!geldigeDatum(vast)) throw fout(400, "De vaste reviewdatum is geen geldige datum.");
    if (vast <= vandaagNL()) throw fout(400, "De vaste reviewdatum moet in de toekomst liggen.");
  }
  return { termijn, vast };
}

async function actieveBijlage(client, hoofdstukId, bijlageId) {
  const [b] = await query(client, `
    SELECT *, CAST(datum AS TEXT) AS datum_tekst FROM bijlage
    WHERE hoofdstuk_id = $1 AND bijlage_id = $2 AND status = 'actief'`, [hoofdstukId, bijlageId]);
  return b || null;
}

// Leest en controleert de velden van een bijlage. 'basis' is de huidige bijlage bij een wijziging.
async function bijlageInvoer(invoer, basis = null) {
  const soort = invoer?.bijlage_soort;
  if (!BIJLAGESOORTEN.includes(soort)) throw fout(400, "Kies de soort bijlage: download, template, stappenplan of link.");
  const uit = {
    bijlage_soort: soort,
    bijlage_titel: veld(invoer, "bijlage_titel", MAX.titel),
    bijlage_omschrijving: veld(invoer, "bijlage_omschrijving", MAX.veld),
    bijlage_datum: invoer?.bijlage_datum || null,
    bijlage_url: null, bestand_sleutel: null, bestandsnaam: null, bestand_mime: null, bestand_grootte: null,
  };
  if (!geldigeDatum(uit.bijlage_datum)) throw fout(400, "Vul een geldige datum in bij de bijlage.");
  if (soort === "link") {
    const url = veld(invoer, "bijlage_url", 2000);
    let geldig = false;
    try { geldig = ["http:", "https:"].includes(new URL(url).protocol); } catch { geldig = false; }
    if (!geldig) throw fout(400, "Vul een volledig webadres in, beginnend met https://");
    uit.bijlage_url = url;
  } else {
    const sleutel = invoer?.bestand_sleutel || (basis && basis.soort !== "link" ? basis.bestand_sleutel : null);
    if (!sleutel) throw fout(400, "Kies een bestand om te uploaden.");
    if (basis && sleutel === basis.bestand_sleutel) {
      Object.assign(uit, { bestand_sleutel: sleutel, bestandsnaam: basis.bestandsnaam, bestand_mime: basis.bestand_mime, bestand_grootte: basis.bestand_grootte });
    } else {
      const g = await gegevensVan(sleutel);
      if (!g) throw fout(400, "Het geüploade bestand is niet gevonden. Upload het opnieuw.");
      Object.assign(uit, { bestand_sleutel: g.sleutel, bestandsnaam: g.bestandsnaam, bestand_mime: g.mime, bestand_grootte: g.grootte });
    }
  }
  return uit;
}

// ---------- aanmaken ----------

export async function maakVoorstel(auteur, invoer) {
  const soort = invoer?.soort;
  if (!SOORTEN.includes(soort)) throw fout(400, "Onbekende soort voorstel.");
  const wat = veld(invoer, "wat", MAX.veld);
  const waarom = veld(invoer, "waarom", MAX.veld);
  const bron = veld(invoer, "bron", MAX.veld);
  const status = invoer?.indienen ? "ter_validatie" : "concept";
  const { termijn, vast } = reviewInvoer(invoer);

  return inTransactie(async (client) => {
    const rij = {
      soort, status, wat, waarom, bron, auteur,
      hoofdstuk_id: null, paragraaf_id: null, na_paragraaf_id: null, basis_versie_id: null,
      basis_controlegetal: null, basis_titel: null, basis_tekst: null,
      nieuw_nummer: null, nieuw_titel: null, nieuw_tekst: null, nieuw_soort: null,
      reviewtermijn_maanden: termijn, vaste_reviewdatum: vast,
      hoofdstuk_titel: null, hoofdstuk_omschrijving: null,
      bijlage_id: null, basis_bijlage_rij: null, bijlage_soort: null, bijlage_titel: null, bijlage_omschrijving: null,
      bijlage_datum: null, bijlage_url: null, bestand_sleutel: null, bestandsnaam: null, bestand_mime: null, bestand_grootte: null,
    };

    if (IS_BIJLAGE(soort)) {
      const hoofdstukId = String(invoer?.hoofdstuk_id || "").toUpperCase();
      const versie = /^H\d{2}$/.test(hoofdstukId) ? await actueleVersie(client, hoofdstukId) : null;
      if (!versie) throw fout(404, "Dit hoofdstuk bestaat niet of heeft geen goedgekeurde versie.");
      rij.hoofdstuk_id = hoofdstukId;
      rij.basis_versie_id = versie.id;
      rij.reviewtermijn_maanden = null;
      rij.vaste_reviewdatum = null;
      let basis = null;
      if (soort !== "bijlage_toevoegen") {
        basis = await actieveBijlage(client, hoofdstukId, invoer?.bijlage_id);
        if (!basis) throw fout(404, "Deze bijlage bestaat niet (meer).");
        rij.bijlage_id = basis.bijlage_id;
        rij.basis_bijlage_rij = basis.id;
        rij.basis_titel = basis.titel;
      }
      if (soort !== "bijlage_verwijderen") {
        Object.assign(rij, await bijlageInvoer(invoer, basis));
        if (basis) {
          const zelfde = rij.bijlage_soort === basis.soort && rij.bijlage_titel === basis.titel
            && rij.bijlage_omschrijving === basis.omschrijving && rij.bijlage_datum === basis.datum_tekst
            && rij.bijlage_url === basis.url && rij.bestand_sleutel === basis.bestand_sleutel;
          if (zelfde) throw fout(400, "Er is niets gewijzigd aan de bijlage.");
        }
      }
    } else if (soort === "nieuw_hoofdstuk") {
      rij.hoofdstuk_titel = veld(invoer, "hoofdstuk_titel", MAX.titel);
      rij.hoofdstuk_omschrijving = veld(invoer, "hoofdstuk_omschrijving", MAX.veld);
      rij.nieuw_tekst = veld(invoer, "nieuw_tekst", MAX.tekst);
      rij.nieuw_titel = "Inleiding";
      rij.nieuw_soort = "inleiding";
    } else {
      const hoofdstukId = String(invoer?.hoofdstuk_id || "").toUpperCase();
      const versie = /^H\d{2}$/.test(hoofdstukId) ? await actueleVersie(client, hoofdstukId) : null;
      if (!versie) throw fout(404, "Dit hoofdstuk bestaat niet of heeft geen goedgekeurde versie.");
      const alle = await paragrafen(client, versie.id);
      rij.hoofdstuk_id = hoofdstukId;
      rij.basis_versie_id = versie.id;

      if (soort === "wijzigen" || soort === "verwijderen") {
        const p = alle.find((x) => x.paragraaf_id === invoer?.paragraaf_id);
        if (!p) throw fout(404, "Deze paragraaf bestaat niet in de actuele versie.");
        rij.paragraaf_id = p.paragraaf_id;
        rij.basis_controlegetal = p.controlegetal;
        rij.basis_titel = p.titel;
        rij.basis_tekst = p.tekst;
        if (soort === "verwijderen" && alle.length <= 1) throw fout(400, "Een hoofdstuk moet minstens één paragraaf houden.");
        if (soort === "wijzigen") {
          rij.nieuw_titel = veld(invoer, "nieuw_titel", MAX.titel);
          rij.nieuw_tekst = veld(invoer, "nieuw_tekst", MAX.tekst);
          rij.nieuw_nummer = veld(invoer, "nieuw_nummer", 20, false) ?? p.nummer;
          const niksGewijzigd = rij.nieuw_titel === p.titel && rij.nieuw_tekst === p.tekst
            && (rij.nieuw_nummer ?? null) === (p.nummer ?? null) && termijn === null && vast === null;
          if (niksGewijzigd) throw fout(400, "Er is niets gewijzigd ten opzichte van de huidige tekst.");
        }
      } else if (soort === "toevoegen") {
        const na = invoer?.na_paragraaf_id;
        if (!alle.some((x) => x.paragraaf_id === na)) throw fout(400, "Kies na welke paragraaf de nieuwe paragraaf komt.");
        rij.na_paragraaf_id = na;
        rij.nieuw_titel = veld(invoer, "nieuw_titel", MAX.titel);
        rij.nieuw_tekst = veld(invoer, "nieuw_tekst", MAX.tekst);
        rij.nieuw_nummer = veld(invoer, "nieuw_nummer", 20, false);
        rij.nieuw_soort = "vraag";
      }
    }

    const kolommen = Object.keys(rij);
    const [nieuw] = await query(client,
      `INSERT INTO voorstel (${kolommen.join(", ")}, ingediend_op)
       VALUES (${kolommen.map((_, i) => "$" + (i + 1)).join(", ")}, ${status === "ter_validatie" ? "CURRENT_TIMESTAMP" : "NULL"})
       RETURNING id`, kolommen.map((k) => rij[k]));
    await logboek(client, auteur, status === "ter_validatie" ? "voorstel_ingediend" : "voorstel_concept",
      `voorstel ${nieuw.id}`, `${soort} ${rij.paragraaf_id || rij.hoofdstuk_id || rij.hoofdstuk_titel}: ${wat}`);
    return nieuw.id;
  });
}

// ---------- acties op een bestaand voorstel ----------

export async function voerActieUit(gebruiker, invoer) {
  const id = Number(invoer?.id);
  if (!Number.isInteger(id) || id < 1) throw fout(400, "Onbekend voorstel.");
  const actie = invoer?.actie;

  return inTransactie(async (client) => {
    const v = await haalVoorstel(client, id, true);
    const eigen = v.auteur === gebruiker;

    switch (actie) {
      case "bewerken": {
        if (!eigen) throw fout(403, "Alleen de indiener kan een voorstel bewerken.");
        if (v.status !== "concept") throw fout(409, "Alleen een concept kan worden bewerkt. Zet het voorstel eerst terug naar concept.");
        const wat = veld(invoer, "wat", MAX.veld);
        const waarom = veld(invoer, "waarom", MAX.veld);
        const bron = veld(invoer, "bron", MAX.veld);
        const { termijn, vast } = reviewInvoer(invoer);
        let titel = v.nieuw_titel, tekst = v.nieuw_tekst, nummer = v.nieuw_nummer;
        let hTitel = v.hoofdstuk_titel, hOmschr = v.hoofdstuk_omschrijving;
        if (v.soort === "wijzigen" || v.soort === "toevoegen") {
          titel = veld(invoer, "nieuw_titel", MAX.titel);
          tekst = veld(invoer, "nieuw_tekst", MAX.tekst);
          nummer = veld(invoer, "nieuw_nummer", 20, false) ?? (v.soort === "wijzigen" ? v.nieuw_nummer : null);
        }
        if (v.soort === "nieuw_hoofdstuk") {
          hTitel = veld(invoer, "hoofdstuk_titel", MAX.titel);
          hOmschr = veld(invoer, "hoofdstuk_omschrijving", MAX.veld);
          tekst = veld(invoer, "nieuw_tekst", MAX.tekst);
        }
        if (IS_BIJLAGE(v.soort)) {
          let b = {};
          if (v.soort !== "bijlage_verwijderen") {
            const basis = v.basis_bijlage_rij
              ? (await query(client, "SELECT *, CAST(datum AS TEXT) AS datum_tekst FROM bijlage WHERE id = $1", [v.basis_bijlage_rij]))[0]
              : null;
            // Bij bewerken zonder nieuw bestand blijft het eerder geüploade bestand van dit voorstel staan.
            const eerder = v.bestand_sleutel ? { soort: "download", bestand_sleutel: v.bestand_sleutel, bestandsnaam: v.bestandsnaam, bestand_mime: v.bestand_mime, bestand_grootte: v.bestand_grootte } : basis;
            b = await bijlageInvoer(invoer, eerder);
          }
          await query(client, `
            UPDATE voorstel SET wat = $2, waarom = $3, bron = $4, bijlage_soort = $5, bijlage_titel = $6, bijlage_omschrijving = $7,
                   bijlage_datum = $8, bijlage_url = $9, bestand_sleutel = $10, bestandsnaam = $11, bestand_mime = $12,
                   bestand_grootte = $13, gewijzigd_op = CURRENT_TIMESTAMP
            WHERE id = $1`, [id, wat, waarom, bron, b.bijlage_soort ?? v.bijlage_soort, b.bijlage_titel ?? v.bijlage_titel,
              b.bijlage_omschrijving ?? v.bijlage_omschrijving, b.bijlage_datum ?? v.bijlage_datum_tekst, b.bijlage_url ?? null,
              b.bestand_sleutel ?? null, b.bestandsnaam ?? null, b.bestand_mime ?? null, b.bestand_grootte ?? null]);
          await logboek(client, gebruiker, "voorstel_bewerkt", `voorstel ${id}`, wat);
          return { id, status: "concept" };
        }
        await query(client, `
          UPDATE voorstel SET wat = $2, waarom = $3, bron = $4, nieuw_titel = $5, nieuw_tekst = $6, nieuw_nummer = $7,
                 reviewtermijn_maanden = $8, vaste_reviewdatum = $9, hoofdstuk_titel = $10, hoofdstuk_omschrijving = $11,
                 gewijzigd_op = CURRENT_TIMESTAMP
          WHERE id = $1`, [id, wat, waarom, bron, titel, tekst, nummer, termijn, vast, hTitel, hOmschr]);
        await logboek(client, gebruiker, "voorstel_bewerkt", `voorstel ${id}`, wat);
        return { id, status: "concept" };
      }

      case "indienen": {
        if (!eigen) throw fout(403, "Alleen de indiener kan een voorstel indienen.");
        if (v.status !== "concept") throw fout(409, "Dit voorstel is al ingediend of afgerond.");
        await query(client, "UPDATE voorstel SET status = 'ter_validatie', ingediend_op = CURRENT_TIMESTAMP, gewijzigd_op = CURRENT_TIMESTAMP WHERE id = $1", [id]);
        await logboek(client, gebruiker, "voorstel_ingediend", `voorstel ${id}`, v.wat);
        return { id, status: "ter_validatie" };
      }

      case "terug_naar_concept": {
        if (!eigen) throw fout(403, "Alleen de indiener kan een voorstel terugzetten naar concept.");
        if (v.status !== "ter_validatie") throw fout(409, "Alleen een voorstel dat ter validatie ligt, kan terug naar concept.");
        await query(client, "UPDATE voorstel SET status = 'concept', gewijzigd_op = CURRENT_TIMESTAMP WHERE id = $1", [id]);
        await logboek(client, gebruiker, "voorstel_terug_naar_concept", `voorstel ${id}`, v.wat);
        return { id, status: "concept" };
      }

      case "intrekken": {
        if (!eigen) throw fout(403, "Alleen de indiener kan een voorstel intrekken.");
        if (!["concept", "ter_validatie"].includes(v.status)) throw fout(409, "Dit voorstel is al afgerond.");
        await query(client, "UPDATE voorstel SET status = 'ingetrokken', gewijzigd_op = CURRENT_TIMESTAMP WHERE id = $1", [id]);
        await logboek(client, gebruiker, "voorstel_ingetrokken", `voorstel ${id}`, v.wat);
        return { id, status: "ingetrokken" };
      }

      case "afwijzen": {
        if (eigen) throw fout(403, "Je kunt je eigen voorstel niet beoordelen. Dat doet de andere redacteur.");
        if (v.status !== "ter_validatie") throw fout(409, "Alleen een voorstel dat ter validatie ligt, kan worden afgewezen.");
        const reden = veld(invoer, "reden", MAX.veld);
        const checklist = JSON.stringify(checklistUit(invoer));
        await query(client, `
          UPDATE voorstel SET status = 'afgewezen', beoordelaar = $2, beoordeeld_op = CURRENT_TIMESTAMP,
                 reden_afwijzing = $3, checklist = $4, gewijzigd_op = CURRENT_TIMESTAMP
          WHERE id = $1`, [id, gebruiker, reden, checklist]);
        await logboek(client, gebruiker, "voorstel_afgewezen", `voorstel ${id}`, reden);
        return { id, status: "afgewezen" };
      }

      case "goedkeuren": {
        if (eigen) throw fout(403, "Je kunt je eigen voorstel niet goedkeuren. Dat doet de andere redacteur.");
        if (v.status !== "ter_validatie") throw fout(409, "Alleen een voorstel dat ter validatie ligt, kan worden goedgekeurd.");
        const checklist = checklistUit(invoer);
        const open = CHECKLIST.filter((c) => !checklist[c.id]).map((c) => c.tekst);
        if (open.length) throw fout(400, `Vink eerst alle punten van de checklist aan. Nog open: ${open.join(" ")}`);
        const versieId = await pasToe(client, v, gebruiker);
        await query(client, `
          UPDATE voorstel SET status = 'goedgekeurd', beoordelaar = $2, beoordeeld_op = CURRENT_TIMESTAMP,
                 checklist = $3, resultaat_versie_id = $4, gewijzigd_op = CURRENT_TIMESTAMP
          WHERE id = $1`, [id, gebruiker, JSON.stringify(checklist), versieId]);
        await logboek(client, gebruiker, "voorstel_goedgekeurd", `voorstel ${id}`, `nieuwe versie ${versieId}`);
        return { id, status: "goedgekeurd", versie_id: versieId };
      }

      default:
        throw fout(400, "Onbekende actie.");
    }
  });
}

function checklistUit(invoer) {
  const uit = {};
  for (const c of CHECKLIST) uit[c.id] = invoer?.checklist?.[c.id] === true;
  return uit;
}

// ---------- goedkeuren: nieuwe versie maken ----------

// Maakt de nieuwe hoofdstukversie en geeft het id terug. Oude versies blijven ongewijzigd bewaard.
async function pasToe(client, v, beoordelaar) {
  const vandaag = vandaagNL();

  if (v.soort === "nieuw_hoofdstuk") {
    const [{ max }] = await query(client, "SELECT COALESCE(MAX(nummer), 0) AS max FROM hoofdstuk");
    const nummer = Number(max) + 1;
    const hoofdstukId = "H" + String(nummer).padStart(2, "0");
    await query(client, "INSERT INTO hoofdstuk (id, nummer) VALUES ($1, $2)", [hoofdstukId, nummer]);
    const [versie] = await query(client, `
      INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, versiedatum, auteur, toelichting, voorstel_id)
      VALUES ($1, '1.0', 'concept', $2, $3, $4, $5, $6, $7) RETURNING id`,
      [hoofdstukId, v.hoofdstuk_titel, v.hoofdstuk_omschrijving, vandaag, v.auteur, `Nieuw hoofdstuk (voorstel ${v.id}): ${v.wat}`, v.id]);
    const termijn = v.reviewtermijn_maanden || 12;
    await voegParagraafToe(client, versie.id, {
      paragraaf_id: `${hoofdstukId}-P00`, volgorde: 0, soort: "inleiding", nummer: null, titel: "Inleiding",
      kop_origineel: null, tekst: v.nieuw_tekst,
      reviewdatum: v.vaste_reviewdatum_tekst || plusMaanden(vandaag, termijn),
      reviewtermijn_maanden: termijn,
    });
    await keurGoed(client, versie.id, beoordelaar, vandaag);
    return versie.id;
  }

  // Wijzigingen in een bestaand hoofdstuk: één voor één, zodat niets ongemerkt wordt overschreven.
  await query(client, "SELECT id FROM hoofdstuk WHERE id = $1 FOR UPDATE", [v.hoofdstuk_id]);
  const huidig = await actueleVersie(client, v.hoofdstuk_id);
  if (!huidig) throw fout(409, "Dit hoofdstuk heeft geen goedgekeurde versie meer.");
  let lijst = await paragrafen(client, huidig.id);

  if (v.soort === "wijzigen" || v.soort === "verwijderen") {
    const p = lijst.find((x) => x.paragraaf_id === v.paragraaf_id);
    if (!p) throw fout(409, `Paragraaf ${v.paragraaf_id} bestaat niet meer in de actuele versie. Het voorstel kan niet worden toegepast; wijs het af en dien zo nodig een nieuw voorstel in.`);
    if (p.controlegetal !== v.basis_controlegetal) {
      throw fout(409, `Paragraaf ${v.paragraaf_id} is gewijzigd sinds dit voorstel werd gemaakt. Wijs dit voorstel af met als reden "achterhaald", en laat de indiener een nieuw voorstel maken op basis van de actuele tekst.`);
    }
  }
  if (v.soort === "toevoegen" && !lijst.some((x) => x.paragraaf_id === v.na_paragraaf_id)) {
    throw fout(409, `Paragraaf ${v.na_paragraaf_id}, waarna de nieuwe paragraaf zou komen, bestaat niet meer.`);
  }

  let bijlageToelichting = null;
  if (IS_BIJLAGE(v.soort)) bijlageToelichting = await pasBijlageToe(client, v, beoordelaar, vandaag);

  const reviewVoor = (bestaandeTermijn) => {
    const termijn = v.reviewtermijn_maanden || bestaandeTermijn || 12;
    return {
      reviewdatum: v.vaste_reviewdatum_tekst || plusMaanden(vandaag, termijn),
      reviewtermijn_maanden: termijn,
    };
  };

  if (v.soort === "wijzigen") {
    lijst = lijst.map((p) => p.paragraaf_id !== v.paragraaf_id ? p : {
      ...p,
      nummer: v.nieuw_nummer,
      titel: v.nieuw_titel,
      kop_origineel: v.nieuw_titel === p.titel && v.nieuw_nummer === p.nummer ? p.kop_origineel : null,
      tekst: v.nieuw_tekst,
      ...reviewVoor(p.reviewtermijn_maanden),
    });
  } else if (v.soort === "verwijderen") {
    lijst = lijst.filter((p) => p.paragraaf_id !== v.paragraaf_id);
  } else if (v.soort === "toevoegen") {
    // Nieuw paragraaf-ID: hoogste nummer ooit gebruikt in dit hoofdstuk + 1 (ID's worden nooit hergebruikt).
    const ids = await query(client, `
      SELECT DISTINCT p.paragraaf_id FROM paragraaf p
      JOIN hoofdstuk_versie hv ON hv.id = p.hoofdstuk_versie_id
      WHERE hv.hoofdstuk_id = $1`, [v.hoofdstuk_id]);
    const hoogste = Math.max(0, ...ids.map((r) => parseInt(String(r.paragraaf_id).split("-P")[1], 10)).filter(Number.isFinite));
    const nieuwId = `${v.hoofdstuk_id}-P${String(hoogste + 1).padStart(2, "0")}`;
    const plek = lijst.findIndex((x) => x.paragraaf_id === v.na_paragraaf_id);
    lijst.splice(plek + 1, 0, {
      paragraaf_id: nieuwId, soort: v.nieuw_soort || "vraag", nummer: v.nieuw_nummer, titel: v.nieuw_titel,
      kop_origineel: null, tekst: v.nieuw_tekst, ...reviewVoor(12),
    });
  }

  const [versie] = await query(client, `
    INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, toelichting, voorstel_id)
    VALUES ($1, $2, 'concept', $3, $4, $5, $6, $7, $8, $9) RETURNING id`,
    [v.hoofdstuk_id, volgendeVersie(huidig.versie), huidig.titel, huidig.omschrijving, huidig.kop_origineel,
      vandaag, v.auteur, `Voorstel ${v.id}: ${bijlageToelichting ? bijlageToelichting + " – " : ""}${v.wat}`, v.id]);

  let volgorde = 0;
  for (const p of lijst) await voegParagraafToe(client, versie.id, { ...p, volgorde: volgorde++ });
  await keurGoed(client, versie.id, beoordelaar, vandaag);
  return versie.id;
}

// Bijlagen: nieuwe regel toevoegen en/of de huidige regel laten vervallen.
async function pasBijlageToe(client, v, beoordelaar, vandaag) {
  let basis = null;
  if (v.soort !== "bijlage_toevoegen") {
    basis = await actieveBijlage(client, v.hoofdstuk_id, v.bijlage_id);
    if (!basis || basis.id !== v.basis_bijlage_rij) {
      throw fout(409, `Bijlage ${v.bijlage_id} is gewijzigd of vervallen sinds dit voorstel werd gemaakt. Wijs dit voorstel af met als reden "achterhaald".`);
    }
    await query(client, "UPDATE bijlage SET status = 'vervallen' WHERE id = $1", [basis.id]);
  }
  if (v.soort === "bijlage_verwijderen") return `bijlage ${v.bijlage_id} vervallen`;

  let bijlageId = v.bijlage_id;
  if (v.soort === "bijlage_toevoegen") {
    const ids = await query(client, "SELECT DISTINCT bijlage_id FROM bijlage WHERE hoofdstuk_id = $1", [v.hoofdstuk_id]);
    const hoogste = Math.max(0, ...ids.map((r) => parseInt(String(r.bijlage_id).split("-B")[1], 10)).filter(Number.isFinite));
    bijlageId = `${v.hoofdstuk_id}-B${String(hoogste + 1).padStart(2, "0")}`;
  }
  await query(client, `
    INSERT INTO bijlage (bijlage_id, hoofdstuk_id, soort, titel, omschrijving, datum, url, bestand_sleutel, bestandsnaam,
                         bestand_mime, bestand_grootte, status, voorstel_id, auteur, goedgekeurd_door, goedgekeurd_op, vervangt_id)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, 'actief', $12, $13, $14, $15, $16)`,
    [bijlageId, v.hoofdstuk_id, v.bijlage_soort, v.bijlage_titel, v.bijlage_omschrijving, v.bijlage_datum_tekst, v.bijlage_url,
      v.bestand_sleutel, v.bestandsnaam, v.bestand_mime, v.bestand_grootte, v.id, v.auteur, beoordelaar, vandaag, basis?.id ?? null]);
  return v.soort === "bijlage_toevoegen" ? `bijlage ${bijlageId} toegevoegd` : `bijlage ${bijlageId} gewijzigd`;
}

async function voegParagraafToe(client, versieId, p) {
  await query(client, `
    INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst,
                           bronnen, reviewdatum, reviewtermijn_maanden, controlegetal)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)`,
    [versieId, p.paragraaf_id, p.volgorde, p.soort, p.nummer ?? null, p.titel, p.kop_origineel ?? null, p.tekst,
      JSON.stringify(bronnenUit(p.tekst)), p.reviewdatum, p.reviewtermijn_maanden, controlegetal(p.tekst)]);
}

async function keurGoed(client, versieId, beoordelaar, vandaag) {
  await query(client, `
    UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = $2, goedgekeurd_op = $3
    WHERE id = $1`, [versieId, beoordelaar, vandaag]);
}

// ---------- lezen ----------

function samenvatting(r) {
  return {
    id: r.id, soort: r.soort, status: r.status, hoofdstuk_id: r.hoofdstuk_id, paragraaf_id: r.paragraaf_id,
    na_paragraaf_id: r.na_paragraaf_id, titel: r.bijlage_titel || r.nieuw_titel || r.basis_titel || r.hoofdstuk_titel,
    bijlage_id: r.bijlage_id,
    hoofdstuk_titel: r.hoofdstuk_titel_actueel || r.hoofdstuk_titel, wat: r.wat, auteur: r.auteur,
    aangemaakt_op: r.aangemaakt_op, ingediend_op: r.ingediend_op, beoordelaar: r.beoordelaar,
    beoordeeld_op: r.beoordeeld_op,
  };
}

export async function lijstVoorstellen(sql, { groep = "open", hoofdstukId = null } = {}) {
  const rijen = groep === "afgerond"
    ? await sql`
        SELECT v.*, (SELECT hv.titel FROM hoofdstuk_versie hv
                     WHERE hv.hoofdstuk_id = v.hoofdstuk_id AND hv.status = 'goedgekeurd'
                     ORDER BY hv.id DESC LIMIT 1) AS hoofdstuk_titel_actueel
        FROM voorstel v
        WHERE v.status IN ('goedgekeurd', 'afgewezen', 'ingetrokken')
        ORDER BY v.id DESC LIMIT 200`
    : await sql`
        SELECT v.*, (SELECT hv.titel FROM hoofdstuk_versie hv
                     WHERE hv.hoofdstuk_id = v.hoofdstuk_id AND hv.status = 'goedgekeurd'
                     ORDER BY hv.id DESC LIMIT 1) AS hoofdstuk_titel_actueel
        FROM voorstel v
        WHERE v.status IN ('concept', 'ter_validatie')
        ORDER BY v.id DESC`;
  return rijen.filter((r) => !hoofdstukId || r.hoofdstuk_id === hoofdstukId).map(samenvatting);
}

export async function eenVoorstel(sql, id) {
  const [v] = await sql`SELECT *, CAST(vaste_reviewdatum AS TEXT) AS vaste_reviewdatum_tekst,
    CAST(bijlage_datum AS TEXT) AS bijlage_datum_tekst FROM voorstel WHERE id = ${id}`;
  if (!v) return null;
  const uit = {
    ...samenvatting(v),
    waarom: v.waarom, bron: v.bron, basis_titel: v.basis_titel, basis_tekst: v.basis_tekst,
    nieuw_nummer: v.nieuw_nummer, nieuw_titel: v.nieuw_titel, nieuw_tekst: v.nieuw_tekst,
    hoofdstuk_titel: v.hoofdstuk_titel, hoofdstuk_omschrijving: v.hoofdstuk_omschrijving,
    reviewtermijn_maanden: v.reviewtermijn_maanden,
    vaste_reviewdatum: v.vaste_reviewdatum_tekst || null,
    reden_afwijzing: v.reden_afwijzing, resultaat_versie_id: v.resultaat_versie_id,
    checklist: v.checklist ? JSON.parse(v.checklist) : null,
    achterhaald: false, actueel: null,
    bijlage: IS_BIJLAGE(v.soort) ? {
      soort: v.bijlage_soort, titel: v.bijlage_titel, omschrijving: v.bijlage_omschrijving, datum: v.bijlage_datum_tekst,
      url: v.bijlage_url, bestand_sleutel: v.bestand_sleutel, bestandsnaam: v.bestandsnaam, grootte: v.bestand_grootte,
    } : null,
    basis_bijlage: null,
  };
  if (v.basis_bijlage_rij) {
    const [b] = await sql`SELECT *, CAST(datum AS TEXT) AS datum_tekst FROM bijlage WHERE id = ${v.basis_bijlage_rij}`;
    if (b) {
      uit.basis_bijlage = { soort: b.soort, titel: b.titel, omschrijving: b.omschrijving, datum: b.datum_tekst, url: b.url,
        bestand_sleutel: b.bestand_sleutel, bestandsnaam: b.bestandsnaam, grootte: b.bestand_grootte };
      if (["concept", "ter_validatie"].includes(v.status)) uit.achterhaald = b.status !== "actief";
    }
  }
  // Is de paragraaf sinds het voorstel veranderd? Dan zie je dat meteen.
  if (v.hoofdstuk_id && v.paragraaf_id && ["concept", "ter_validatie"].includes(v.status)) {
    const [p] = await sql`
      SELECT p.titel, p.tekst, p.controlegetal, p.nummer, CAST(p.reviewdatum AS TEXT) AS reviewdatum, p.reviewtermijn_maanden
      FROM paragraaf p JOIN hoofdstuk_versie hv ON hv.id = p.hoofdstuk_versie_id
      WHERE hv.hoofdstuk_id = ${v.hoofdstuk_id} AND hv.status = 'goedgekeurd' AND p.paragraaf_id = ${v.paragraaf_id}
        AND hv.id = (SELECT MAX(h2.id) FROM hoofdstuk_versie h2 WHERE h2.hoofdstuk_id = ${v.hoofdstuk_id} AND h2.status = 'goedgekeurd')`;
    uit.actueel = p ? { titel: p.titel, tekst: p.tekst, nummer: p.nummer, reviewdatum: p.reviewdatum, reviewtermijn_maanden: p.reviewtermijn_maanden } : null;
    uit.achterhaald = !p || p.controlegetal !== v.basis_controlegetal;
  }
  return uit;
}

// Aantal open voorstellen per hoofdstuk en per paragraaf (voor tegels en paragrafen).
export async function openTellingen(sql) {
  const rijen = await sql`
    SELECT hoofdstuk_id, paragraaf_id, na_paragraaf_id, bijlage_id, soort, status FROM voorstel
    WHERE status IN ('concept', 'ter_validatie')`;
  return rijen;
}
