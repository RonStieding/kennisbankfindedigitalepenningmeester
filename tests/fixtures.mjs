export const TOKEN = "test-only-service-token-0123456789abcdef";
export const FILE_KEY = "bestanden/20261008-12345678-1234-1234-1234-123456789abc";
export function rijen() {
  return {
    versies: [{ id: 1, hoofdstuk_id: "H01", nummer: 1, versie: "1.0", status: "goedgekeurd",
      titel: "Penningmeester", omschrijving: "Over de rol", versiedatum: "2026-10-08",
      goedgekeurd_door: "Reviewer", goedgekeurd_op: "2026-10-08", basisversie: true }],
    paragrafen: [0, 1].map((i) => ({ hoofdstuk_versie_id: 1, paragraaf_id: `H01-P0${i}`,
      volgorde: i, soort: "vraag", nummer: String(i), titel: `Vraag ${i}`,
      tekst: `Letterlijke tekst € 1.234,56\n\n**Voorwaarde ${i}**: niet wijzigen.`,
      bronnen: '[{"label":"Bron","url":"https://example.org/bron"}]',
      reviewdatum: "2027-10-08", reviewtermijn_maanden: 12 })),
    bijlagen: [],
  };
}
export function bestand() {
  return { id: 1, bijlage_id: "H01-B01", hoofdstuk_id: "H01", soort: "download",
    titel: "Handleiding", omschrijving: "Beschrijving", datum: "2026-10-08",
    url: null, bestand_sleutel: FILE_KEY, bestandsnaam: "handleiding.pdf",
    bestand_mime: "application/pdf", bestand_grootte: 4,
    goedgekeurd_door: "Reviewer", goedgekeurd_op: "2026-10-08" };
}
export const fileInfo = async () => ({ sha256: "a".repeat(64), size: 4, mime: "application/pdf" });
