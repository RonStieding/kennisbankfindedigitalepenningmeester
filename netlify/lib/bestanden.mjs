// Bestanden bij bijlagen: alleen Word, pdf en Excel, maximaal 5 MB.
// Opslag in Netlify Blobs (store 'bijlagen'). De database bewaart alleen de sleutel.
import { getStore } from "@netlify/blobs";
import { createHash, randomUUID } from "node:crypto";
import { fout } from "./server.mjs";

export const MAX_GROOTTE = 5 * 1024 * 1024;

// Toegestane soorten, met de eerste bytes waaraan het echte bestandstype te herkennen is.
const PDF = [0x25, 0x50, 0x44, 0x46];              // %PDF
const ZIP = [0x50, 0x4b, 0x03, 0x04];              // .docx, .xlsx, .dotx, .xltx (Office Open XML)
const OLE = [0xd0, 0xcf, 0x11, 0xe0, 0xa1, 0xb1, 0x1a, 0xe1]; // oude .doc en .xls
export const TYPES = {
  pdf: { mime: "application/pdf", handtekening: PDF, naam: "pdf" },
  docx: { mime: "application/vnd.openxmlformats-officedocument.wordprocessingml.document", handtekening: ZIP, naam: "Word" },
  dotx: { mime: "application/vnd.openxmlformats-officedocument.wordprocessingml.template", handtekening: ZIP, naam: "Word-sjabloon" },
  doc: { mime: "application/msword", handtekening: OLE, naam: "Word (oud)" },
  xlsx: { mime: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", handtekening: ZIP, naam: "Excel" },
  xltx: { mime: "application/vnd.openxmlformats-officedocument.spreadsheetml.template", handtekening: ZIP, naam: "Excel-sjabloon" },
  xls: { mime: "application/vnd.ms-excel", handtekening: OLE, naam: "Excel (oud)" },
};

const SLEUTEL_PATROON = /^bestanden\/\d{8}-[0-9a-f-]{36}$/;

function store() {
  return getStore({ name: "bijlagen", consistency: "strong" });
}

export function geldigeSleutel(sleutel) {
  return typeof sleutel === "string" && SLEUTEL_PATROON.test(sleutel);
}

// Bestandsnaam veilig maken: geen mappen, geen vreemde tekens, maximaal 120 tekens.
export function veiligeNaam(naam) {
  const basis = String(naam || "").split(/[\\/]/).pop().replace(/[\u0000-\u001f"<>|:*?]/g, "").trim();
  return basis.slice(-120) || "bestand";
}

export function extensie(naam) {
  const m = /\.([a-z0-9]+)$/i.exec(naam || "");
  return m ? m[1].toLowerCase() : "";
}

function begintMet(bytes, handtekening) {
  return handtekening.every((b, i) => bytes[i] === b);
}

// Controleert en bewaart een bestand. Geeft de gegevens terug die bij het voorstel worden opgeslagen.
export async function bewaarBestand(inhoud, bestandsnaam, uploader) {
  const naam = veiligeNaam(bestandsnaam);
  const ext = extensie(naam);
  const type = TYPES[ext];
  if (!type) throw fout(415, "Alleen Word (.docx, .doc, .dotx), pdf en Excel (.xlsx, .xls, .xltx) zijn toegestaan.");
  const bytes = new Uint8Array(inhoud);
  if (bytes.length === 0) throw fout(400, "Het bestand is leeg.");
  if (bytes.length > MAX_GROOTTE) throw fout(413, "Het bestand is groter dan 5 MB. Maak het kleiner (bijvoorbeeld als pdf) en probeer het opnieuw.");
  if (!begintMet(bytes, type.handtekening)) {
    throw fout(415, `Dit bestand is geen echt ${type.naam}-bestand, ook al eindigt de naam op .${ext}.`);
  }
  const vandaag = new Date().toISOString().slice(0, 10).replace(/-/g, "");
  const sleutel = `bestanden/${vandaag}-${randomUUID()}`;
  await store().set(sleutel, bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength), {
    metadata: { bestandsnaam: naam, mime: type.mime, grootte: bytes.length, geupload_door: uploader, geupload_op: new Date().toISOString(),
      sha256: createHash("sha256").update(bytes).digest("hex") },
  });
  return { sleutel, bestandsnaam: naam, mime: type.mime, grootte: bytes.length };
}

export async function haalBestand(sleutel) {
  if (!geldigeSleutel(sleutel)) return null;
  return store().get(sleutel, { type: "arrayBuffer" });
}

// Gegevens van een eerder geüpload bestand, rechtstreeks uit de opslag (niet uit de browser).
export async function gegevensVan(sleutel) {
  if (!geldigeSleutel(sleutel)) return null;
  const uit = await store().getMetadata(sleutel);
  if (!uit) return null;
  const m = uit.metadata || {};
  return { sleutel, bestandsnaam: m.bestandsnaam, mime: m.mime, grootte: Number(m.grootte) || null };
}
