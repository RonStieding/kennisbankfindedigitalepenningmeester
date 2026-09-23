// Leesfuncties voor de kennisbank.
// Regel: de leesweergave toont ALLEEN goedgekeurde content. De actuele versie van een
// hoofdstuk is de meest recent vastgelegde goedgekeurde versie.

import { openTellingen } from "./voorstellen.mjs";

const ID_PATROON = /^H\d{2}$/;

export function geldigHoofdstukId(id) {
  return typeof id === "string" && ID_PATROON.test(id);
}

function versieUit(r) {
  return {
    id: r.id,
    number: r.versie,
    status: r.status,
    date: r.versiedatum,
    author: r.auteur,
    approved_by: r.goedgekeurd_door,
    approved_at: r.goedgekeurd_op,
    basisversie: r.basisversie === true || r.basisversie === 1,
    note: r.toelichting,
    proposal_id: r.voorstel_id ?? null,
  };
}

function paragraafUit(p) {
  let bronnen = [];
  try { bronnen = JSON.parse(p.bronnen || "[]"); } catch { bronnen = []; }
  return {
    id: p.paragraaf_id,
    order: Number(p.volgorde),
    kind: p.soort,
    number: p.nummer,
    title: p.titel,
    heading_original: p.kop_origineel,
    body: p.tekst,
    format: "markdown",
    sources: bronnen,
    review: { date: p.reviewdatum, term_months: Number(p.reviewtermijn_maanden) },
    checksum: p.controlegetal,
  };
}

// Actuele goedgekeurde versie per hoofdstuk (alle hoofdstukken, of één).
async function actueleVersies(sql, hoofdstukId = null) {
  const rijen = hoofdstukId
    ? await sql`
        SELECT v.id, v.hoofdstuk_id, h.nummer, v.versie, v.status, v.titel, v.omschrijving, v.kop_origineel,
               CAST(v.versiedatum AS TEXT) AS versiedatum, v.auteur, v.goedgekeurd_door,
               CAST(v.goedgekeurd_op AS TEXT) AS goedgekeurd_op, v.basisversie, v.toelichting, v.voorstel_id
        FROM hoofdstuk_versie v
        JOIN hoofdstuk h ON h.id = v.hoofdstuk_id
        WHERE v.hoofdstuk_id = ${hoofdstukId}
          AND v.status = 'goedgekeurd'
          AND v.id = (SELECT MAX(v2.id) FROM hoofdstuk_versie v2
                      WHERE v2.hoofdstuk_id = v.hoofdstuk_id AND v2.status = 'goedgekeurd')`
    : await sql`
        SELECT v.id, v.hoofdstuk_id, h.nummer, v.versie, v.status, v.titel, v.omschrijving, v.kop_origineel,
               CAST(v.versiedatum AS TEXT) AS versiedatum, v.auteur, v.goedgekeurd_door,
               CAST(v.goedgekeurd_op AS TEXT) AS goedgekeurd_op, v.basisversie, v.toelichting, v.voorstel_id
        FROM hoofdstuk_versie v
        JOIN hoofdstuk h ON h.id = v.hoofdstuk_id
        WHERE v.status = 'goedgekeurd'
          AND v.id = (SELECT MAX(v2.id) FROM hoofdstuk_versie v2
                      WHERE v2.hoofdstuk_id = v.hoofdstuk_id AND v2.status = 'goedgekeurd')
        ORDER BY h.nummer`;
  return rijen;
}

// Paragrafen van de actuele goedgekeurde versie(s): van één versie, of van alle hoofdstukken.
async function paragrafenVan(sql, versieId = null) {
  if (versieId !== null) {
    return sql`
      SELECT p.hoofdstuk_versie_id, p.paragraaf_id, p.volgorde, p.soort, p.nummer, p.titel, p.kop_origineel,
             p.tekst, p.bronnen, CAST(p.reviewdatum AS TEXT) AS reviewdatum, p.reviewtermijn_maanden, p.controlegetal
      FROM paragraaf p
      JOIN hoofdstuk_versie v ON v.id = p.hoofdstuk_versie_id
      WHERE p.hoofdstuk_versie_id = ${versieId} AND v.status = 'goedgekeurd'
      ORDER BY p.volgorde`;
  }
  return sql`
    SELECT p.hoofdstuk_versie_id, p.paragraaf_id, p.volgorde, p.soort, p.nummer, p.titel, p.kop_origineel,
           p.tekst, p.bronnen, CAST(p.reviewdatum AS TEXT) AS reviewdatum, p.reviewtermijn_maanden, p.controlegetal
    FROM paragraaf p
    JOIN hoofdstuk_versie v ON v.id = p.hoofdstuk_versie_id
    WHERE v.status = 'goedgekeurd'
      AND v.id = (SELECT MAX(v2.id) FROM hoofdstuk_versie v2
                  WHERE v2.hoofdstuk_id = v.hoofdstuk_id AND v2.status = 'goedgekeurd')
    ORDER BY v.hoofdstuk_id, p.volgorde`;
}

function bijlageUit(b, tellingen) {
  return {
    id: b.bijlage_id,
    type: b.soort,
    title: b.titel,
    description: b.omschrijving,
    date: b.datum,
    url: b.soort === "link" ? b.url : `/api/bestand?sleutel=${encodeURIComponent(b.bestand_sleutel)}`,
    external: b.soort === "link",
    file_name: b.bestandsnaam,
    file_size: b.bestand_grootte,
    approved_by: b.goedgekeurd_door,
    approved_at: b.goedgekeurd_op,
    open_proposals: tellingen.filter((t) => t.bijlage_id === b.bijlage_id).length,
  };
}

async function bijlagenVan(sql, hoofdstukId = null) {
  return hoofdstukId
    ? sql`SELECT bijlage_id, hoofdstuk_id, soort, titel, omschrijving, CAST(datum AS TEXT) AS datum, url, bestand_sleutel,
                 bestandsnaam, bestand_grootte, goedgekeurd_door, CAST(goedgekeurd_op AS TEXT) AS goedgekeurd_op
          FROM bijlage WHERE status = 'actief' AND hoofdstuk_id = ${hoofdstukId} ORDER BY bijlage_id`
    : sql`SELECT bijlage_id, hoofdstuk_id, soort, titel, omschrijving, CAST(datum AS TEXT) AS datum, url, bestand_sleutel,
                 bestandsnaam, bestand_grootte, goedgekeurd_door, CAST(goedgekeurd_op AS TEXT) AS goedgekeurd_op
          FROM bijlage WHERE status = 'actief' ORDER BY bijlage_id`;
}

function samenstellen(versies, paragrafen, tellingen = [], bijlagen = []) {
  const perVersie = new Map();
  for (const p of paragrafen) {
    if (!perVersie.has(p.hoofdstuk_versie_id)) perVersie.set(p.hoofdstuk_versie_id, []);
    perVersie.get(p.hoofdstuk_versie_id).push(paragraafUit(p));
  }
  return versies.map((v) => {
    const eigen = tellingen.filter((t) => t.hoofdstuk_id === v.hoofdstuk_id);
    const secties = (perVersie.get(v.id) ?? []).map((s) => ({
      ...s,
      open_proposals: eigen.filter((t) => t.paragraaf_id === s.id).length,
    }));
    return {
      chapter: {
        id: v.hoofdstuk_id,
        number: Number(v.nummer),
        title: v.titel,
        description: v.omschrijving,
        heading_original: v.kop_origineel,
      },
      version: versieUit(v),
      sections: secties,
      attachments: bijlagen.filter((b) => b.hoofdstuk_id === v.hoofdstuk_id).map((b) => bijlageUit(b, eigen)),
      open_proposals: eigen.filter((t) => t.status === "ter_validatie").length,
      open_concepts: eigen.filter((t) => t.status === "concept").length,
    };
  });
}

export async function alleHoofdstukken(sql) {
  const versies = await actueleVersies(sql);
  const paragrafen = await paragrafenVan(sql);
  return samenstellen(versies, paragrafen, await openTellingen(sql), await bijlagenVan(sql));
}

export async function eenHoofdstuk(sql, id) {
  const versies = await actueleVersies(sql, id);
  if (!versies.length) return null;
  const paragrafen = await paragrafenVan(sql, versies[0].id);
  const [hoofdstuk] = samenstellen(versies, paragrafen, await openTellingen(sql), await bijlagenVan(sql, id));
  if (!hoofdstuk) return null;
  // Versiegeschiedenis: alle afgeronde versies (goedgekeurd of afgewezen), nieuwste eerst.
  const geschiedenis = await sql`
    SELECT id, versie, status, CAST(versiedatum AS TEXT) AS versiedatum, auteur, goedgekeurd_door,
           CAST(goedgekeurd_op AS TEXT) AS goedgekeurd_op, basisversie, toelichting, voorstel_id
    FROM hoofdstuk_versie
    WHERE hoofdstuk_id = ${id} AND status IN ('goedgekeurd', 'afgewezen')
    ORDER BY id DESC`;
  hoofdstuk.history = geschiedenis.map(versieUit);
  return hoofdstuk;
}

// Een eerdere goedgekeurde versie van een hoofdstuk (voor de vergelijking in de versiegeschiedenis).
export async function versieVanHoofdstuk(sql, id, versieId) {
  const [v] = await sql`
    SELECT id, versie, CAST(versiedatum AS TEXT) AS versiedatum
    FROM hoofdstuk_versie WHERE id = ${versieId} AND hoofdstuk_id = ${id} AND status = 'goedgekeurd'`;
  if (!v) return null;
  const paragrafen = await paragrafenVan(sql, v.id);
  return { id: v.id, number: v.versie, date: v.versiedatum, sections: paragrafen.map(paragraafUit) };
}
