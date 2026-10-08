import { createHash } from "node:crypto";

export function canoniek(value) {
  if (Array.isArray(value)) return `[${value.map(canoniek).join(",")}]`;
  if (value !== null && typeof value === "object") {
    return `{${Object.keys(value).sort().map((key) => `${JSON.stringify(key)}:${canoniek(value[key])}`).join(",")}}`;
  }
  const encoded = JSON.stringify(value);
  if (encoded === undefined || (typeof value === "number" && !Number.isFinite(value))) {
    throw new Error("Ongeldige waarde in snapshot");
  }
  return encoded;
}

export const hash = (value) => `sha256:${createHash("sha256").update(canoniek(value)).digest("hex")}`;

// Alle queries delen één MVCC-snapshot, ook wanneer een redacteur ondertussen
// goedkeurt. Geen openTellingen/voorstellen: dit is uitsluitend gepubliceerde data.
export async function leesAgentRijen(pool) {
  const client = await pool.connect();
  try {
    await client.query("BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY");
    const versies = (await client.query(`
      SELECT v.id, v.hoofdstuk_id, h.nummer, v.versie, v.status, v.titel, v.omschrijving,
             CAST(v.versiedatum AS TEXT) AS versiedatum, v.goedgekeurd_door,
             CAST(v.goedgekeurd_op AS TEXT) AS goedgekeurd_op, v.basisversie
      FROM hoofdstuk_versie v JOIN hoofdstuk h ON h.id = v.hoofdstuk_id
      WHERE v.status = 'goedgekeurd'
        AND v.id = (SELECT MAX(v2.id) FROM hoofdstuk_versie v2
                    WHERE v2.hoofdstuk_id = v.hoofdstuk_id AND v2.status = 'goedgekeurd')
      ORDER BY h.nummer`)).rows;
    const paragrafen = (await client.query(`
      SELECT p.hoofdstuk_versie_id, p.paragraaf_id, p.volgorde, p.soort, p.nummer,
             p.titel, p.tekst, p.bronnen, CAST(p.reviewdatum AS TEXT) AS reviewdatum,
             p.reviewtermijn_maanden
      FROM paragraaf p JOIN hoofdstuk_versie v ON v.id = p.hoofdstuk_versie_id
      WHERE v.status = 'goedgekeurd'
        AND v.id = (SELECT MAX(v2.id) FROM hoofdstuk_versie v2
                    WHERE v2.hoofdstuk_id = v.hoofdstuk_id AND v2.status = 'goedgekeurd')
      ORDER BY v.hoofdstuk_id, p.volgorde`)).rows;
    const bijlagen = (await client.query(`
      SELECT b.id, b.bijlage_id, b.hoofdstuk_id, b.soort, b.titel, b.omschrijving,
             CAST(b.datum AS TEXT) AS datum, b.url, b.bestand_sleutel, b.bestandsnaam,
             b.bestand_mime, b.bestand_grootte, b.goedgekeurd_door,
             CAST(b.goedgekeurd_op AS TEXT) AS goedgekeurd_op
      FROM bijlage b WHERE b.status = 'actief'
      ORDER BY b.hoofdstuk_id, b.bijlage_id`)).rows;
    await client.query("COMMIT");
    return { versies, paragrafen, bijlagen };
  } catch (error) {
    try { await client.query("ROLLBACK"); } catch { /* behoud oorspronkelijke fout */ }
    throw error;
  } finally {
    client.release();
  }
}

function vereis(ok) {
  if (!ok) throw new Error("Onvolledige of ongeldige goedgekeurde kennisbank");
}
const tekst = (v) => typeof v === "string" && v.trim().length > 0;
const datum = (v) => typeof v === "string" && /^\d{4}-\d{2}-\d{2}$/.test(v) &&
  !Number.isNaN(Date.parse(v)) && new Date(v).toISOString().slice(0, 10) === v;
const positief = (v) => Number.isSafeInteger(v) && v > 0;

function bronnenUit(raw) {
  const bronnen = JSON.parse(raw);
  vereis(Array.isArray(bronnen) && bronnen.every((b) =>
    b && tekst(b.label) && typeof b.url === "string" && /^https?:\/\//.test(b.url)));
  return bronnen.map(({ label, url }) => ({ label, url }));
}

export async function bouwAgentSnapshot({ versies, paragrafen, bijlagen }, bestandscontrole) {
  // Een lege export is nooit stilzwijgend een opdracht om de hele botkennis te wissen.
  vereis(versies.length > 0);
  const hoofdstukIds = new Set();
  const versieIds = new Set();
  for (const v of versies) {
    vereis(/^H\d{2,}$/.test(v.hoofdstuk_id) && !hoofdstukIds.has(v.hoofdstuk_id) &&
      positief(v.id) && !versieIds.has(v.id) && positief(v.nummer) &&
      tekst(v.versie) && tekst(v.titel) && typeof v.omschrijving === "string" &&
      v.status === "goedgekeurd" && tekst(v.goedgekeurd_door) &&
      datum(v.goedgekeurd_op) && datum(v.versiedatum));
    hoofdstukIds.add(v.hoofdstuk_id);
    versieIds.add(v.id);
  }
  vereis(paragrafen.every((p) => versieIds.has(p.hoofdstuk_versie_id)) &&
    bijlagen.every((b) => hoofdstukIds.has(b.hoofdstuk_id)));

  const chapters = [];
  for (const v of [...versies].sort((a, b) => a.nummer - b.nummer)) {
    const ids = new Set();
    const orders = new Set();
    const sections = paragrafen.filter((p) => p.hoofdstuk_versie_id === v.id)
      .sort((a, b) => a.volgorde - b.volgorde).map((p) => {
        vereis(new RegExp(`^${v.hoofdstuk_id}-P\\d{2,}$`).test(p.paragraaf_id) &&
          !ids.has(p.paragraaf_id) && !orders.has(p.volgorde) &&
          Number.isSafeInteger(p.volgorde) && p.volgorde >= 0 &&
          tekst(p.titel) && tekst(p.soort) && typeof p.tekst === "string" &&
          (p.nummer === null || typeof p.nummer === "string") &&
          datum(p.reviewdatum) && positief(p.reviewtermijn_maanden));
        ids.add(p.paragraaf_id);
        orders.add(p.volgorde);
        const content = {
          id: p.paragraaf_id, order: p.volgorde, kind: p.soort, number: p.nummer,
          title: p.titel, body: p.tekst, format: "markdown", sources: bronnenUit(p.bronnen),
        };
        const review = { date: p.reviewdatum, term_months: p.reviewtermijn_maanden };
        return { ...content, review, url: `/p/${p.paragraaf_id}`,
          content_hash: hash(content), metadata_hash: hash(review) };
      });
    vereis(sections.length > 0);

    const attachments = [];
    const bijlageIds = new Set();
    for (const b of bijlagen.filter((b) => b.hoofdstuk_id === v.hoofdstuk_id)
      .sort((a, b) => a.bijlage_id < b.bijlage_id ? -1 : a.bijlage_id > b.bijlage_id ? 1 : 0)) {
      vereis(new RegExp(`^${v.hoofdstuk_id}-B\\d{2,}$`).test(b.bijlage_id) &&
        !bijlageIds.has(b.bijlage_id) && positief(b.id) && tekst(b.titel) &&
        typeof b.omschrijving === "string" && datum(b.datum) &&
        datum(b.goedgekeurd_op) && tekst(b.goedgekeurd_door) &&
        ["link", "download", "template", "stappenplan"].includes(b.soort));
      bijlageIds.add(b.bijlage_id);
      const external = b.soort === "link";
      let file = null;
      if (external) {
        vereis(typeof b.url === "string" && new URL(b.url).protocol === "https:");
      } else {
        vereis(tekst(b.bestandsnaam) && tekst(b.bestand_mime) && positief(b.bestand_grootte));
        const checked = await bestandscontrole(b.bestand_sleutel);
        vereis(checked && /^[a-f0-9]{64}$/.test(checked.sha256) &&
          checked.size === b.bestand_grootte && checked.mime === b.bestand_mime);
        file = { name: b.bestandsnaam, mime: checked.mime, size: checked.size,
          content_hash: `sha256:${checked.sha256}` };
      }
      attachments.push({
        id: b.bijlage_id, revision_id: b.id, type: b.soort, title: b.titel,
        description: b.omschrijving, date: b.datum,
        approved_by: b.goedgekeurd_door, approved_at: b.goedgekeurd_op,
        external, access: external ? "external" : "editor_session_required",
        url: external ? b.url : `/api/bestand?sleutel=${encodeURIComponent(b.bestand_sleutel)}`,
        file,
      });
    }
    const version = { id: v.id, number: v.versie, date: v.versiedatum,
      approved_by: v.goedgekeurd_door, approved_at: v.goedgekeurd_op,
      basisversie: v.basisversie === true };
    const content_hash = hash({ id: v.hoofdstuk_id, number: v.nummer, title: v.titel,
      description: v.omschrijving, sections: sections.map((s) => s.content_hash), attachments });
    const metadata_hash = hash({ version, sections: sections.map((s) => ({ id: s.id, review: s.review })) });
    chapters.push({ id: v.hoofdstuk_id, number: v.nummer, title: v.titel, description: v.omschrijving,
      url: `/hoofdstuk.html?h=${v.hoofdstuk_id}`, version, content_hash, metadata_hash,
      section_count: sections.length, attachment_count: attachments.length, sections, attachments });
  }
  const payload = { schema_version: 1, source_id: "fin-kennisbank", language: "nl",
    complete: true, chapter_count: chapters.length, chapters };
  const snapshot_id = hash(payload);
  const manifest = { ...payload, snapshot_id, chapters: chapters.map((h) => ({
    id: h.id, number: h.number, title: h.title, version_id: h.version.id, version: h.version.number,
    content_hash: h.content_hash, metadata_hash: h.metadata_hash,
    section_count: h.section_count, attachment_count: h.attachment_count,
  })) };
  return { manifest, exported: { ...payload, snapshot_id } };
}
