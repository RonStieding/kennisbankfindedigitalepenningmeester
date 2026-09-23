// Gegevenslaag van de kennisbank.
// Alle inhoud komt uit Netlify Functions (/api/...), die alleen goedgekeurde inhoud teruggeven.
// Toegang tot de site regelt Netlify: het project staat op Private.

export class ApiFout extends Error {
  constructor(status, bericht) { super(bericht); this.status = status; }
}

const SLEUTEL_REDACTEUR = "fin-redacteur";

export function gekozenRedacteur() {
  try { return localStorage.getItem(SLEUTEL_REDACTEUR) || ""; } catch { return ""; }
}

export function kiesRedacteur(naam) {
  try {
    if (naam) localStorage.setItem(SLEUTEL_REDACTEUR, naam);
    else localStorage.removeItem(SLEUTEL_REDACTEUR);
  } catch { /* opslag niet beschikbaar: keuze geldt dan alleen voor deze pagina */ }
}

async function haalApi(pad, opties = {}) {
  const headers = { Accept: "application/json", ...(opties.headers || {}) };
  const naam = gekozenRedacteur();
  if (naam) headers["X-Redacteur"] = encodeURIComponent(naam);
  let res;
  try {
    res = await fetch(pad, { ...opties, headers, credentials: "same-origin" });
  } catch {
    throw new ApiFout(0, "Er is geen verbinding met de server. Controleer je internetverbinding en probeer het opnieuw.");
  }
  let data = null;
  try { data = await res.json(); } catch { data = null; }
  if (!res.ok) throw new ApiFout(res.status, data?.fout || `De server gaf een fout (status ${res.status}).`);
  return data;
}

let kennisbankBelofte = null;
export function haalKennisbank() {
  if (!kennisbankBelofte) kennisbankBelofte = haalApi("/api/kennisbank");
  return kennisbankBelofte;
}

export function haalHoofdstuk(id) {
  if (!/^H\d{2}$/.test(id)) return Promise.reject(new ApiFout(400, `Onbekend hoofdstuk: ${id || "(geen)"}`));
  return haalApi("/api/hoofdstuk?id=" + encodeURIComponent(id));
}

let redacteurenBelofte = null;
export function haalRedacteuren() {
  if (!redacteurenBelofte) redacteurenBelofte = haalApi("/api/redacteuren").then((d) => d.redacteuren);
  return redacteurenBelofte;
}

// ---------- voorstellen ----------

export function haalVoorstellen(groep = "open", hoofdstukId = "") {
  const q = new URLSearchParams({ groep });
  if (hoofdstukId) q.set("hoofdstuk", hoofdstukId);
  return haalApi("/api/voorstellen?" + q.toString());
}

export function haalVoorstel(id) {
  return haalApi("/api/voorstel?id=" + encodeURIComponent(id));
}

export function haalVersie(hoofdstukId, versieId) {
  return haalApi(`/api/hoofdstuk?id=${encodeURIComponent(hoofdstukId)}&versie=${encodeURIComponent(versieId)}`);
}

function postJson(pad, body) {
  return haalApi(pad, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) });
}

export function maakVoorstel(gegevens) {
  kennisbankBelofte = null;
  return postJson("/api/voorstellen", gegevens);
}

export function voorstelActie(gegevens) {
  kennisbankBelofte = null;
  return postJson("/api/voorstel", gegevens);
}

export const SOORT_NAAM = {
  wijzigen: "Paragraaf wijzigen",
  toevoegen: "Paragraaf toevoegen",
  verwijderen: "Paragraaf verwijderen",
  nieuw_hoofdstuk: "Nieuw hoofdstuk",
  bijlage_toevoegen: "Bijlage toevoegen",
  bijlage_wijzigen: "Bijlage wijzigen",
  bijlage_verwijderen: "Bijlage laten vervallen",
};

export const BIJLAGE_NAAM = { download: "Download", template: "Template", stappenplan: "Stappenplan", link: "Link" };

export const BESTAND_EXTENSIES = ["pdf", "doc", "docx", "dotx", "xls", "xlsx", "xltx"];
export const MAX_BESTAND = 5 * 1024 * 1024;

export function grootteTekst(bytes) {
  if (!bytes) return "";
  if (bytes < 1024 * 1024) return `${Math.max(1, Math.round(bytes / 1024))} kB`;
  return `${(bytes / 1024 / 1024).toFixed(1).replace(".", ",")} MB`;
}

// Bestand uploaden (ruwe bytes). Geeft { sleutel, bestandsnaam, grootte } terug.
export async function uploadBestand(bestand) {
  const ext = (bestand.name.split(".").pop() || "").toLowerCase();
  if (!BESTAND_EXTENSIES.includes(ext)) throw new ApiFout(415, "Alleen Word (.docx, .doc, .dotx), pdf en Excel (.xlsx, .xls, .xltx) zijn toegestaan.");
  if (bestand.size > MAX_BESTAND) throw new ApiFout(413, "Het bestand is groter dan 5 MB. Maak het kleiner (bijvoorbeeld als pdf) en probeer het opnieuw.");
  return haalApi("/api/upload", {
    method: "POST",
    headers: { "Content-Type": "application/octet-stream", "X-Bestandsnaam": encodeURIComponent(bestand.name) },
    body: bestand,
  });
}

export const STATUS = {
  concept: { naam: "Concept", klasse: "concept", icoon: "✎" },
  ter_validatie: { naam: "Ter validatie", klasse: "validatie", icoon: "◷" },
  goedgekeurd: { naam: "Goedgekeurd", klasse: "goed", icoon: "✓" },
  afgewezen: { naam: "Afgewezen", klasse: "afgewezen", icoon: "✕" },
  ingetrokken: { naam: "Ingetrokken", klasse: "concept", icoon: "–" },
};

export function statusLabel(status) {
  const s = STATUS[status] || STATUS.concept;
  return `<span class="status ${s.klasse}"><span aria-hidden="true">${s.icoon}</span> ${s.naam}</span>`;
}

export function datumTijdNL(waarde) {
  if (!waarde) return "–";
  let t = String(waarde);
  if (/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/.test(t)) t = t.replace(" ", "T") + "Z";
  const d = new Date(t);
  if (Number.isNaN(d.getTime())) return String(waarde);
  return d.toLocaleString("nl-NL", { day: "2-digit", month: "2-digit", year: "numeric", hour: "2-digit", minute: "2-digit" });
}

export function vandaag() {
  const d = new Date();
  return new Date(d.getFullYear(), d.getMonth(), d.getDate());
}

export function isVerlopen(isoDatum) {
  if (!isoDatum) return false;
  const [j, m, d] = isoDatum.split("-").map(Number);
  return new Date(j, m - 1, d) < vandaag();
}

export function aantalVerlopen(hoofdstuk) {
  return hoofdstuk.sections.filter((s) => isVerlopen(s.review?.date)).length;
}

export function datumNL(isoDatum) {
  if (!isoDatum) return "–";
  const [j, m, d] = isoDatum.split("-");
  return `${d}-${m}-${j}`;
}

export function tweeCijfers(n) {
  return String(n).padStart(2, "0");
}
