// GET /api/bestand?sleutel=… – een bestand van een bijlage (of van een bijlage-voorstel) downloaden.
// Alleen bestanden die in de database bij een bijlage of voorstel horen, worden geleverd.
// Deze route blijft achter de redactielogin: hier zijn ook conceptbestanden bij voorstellen te zien.
// De publieke route voor goedgekeurde bijlagen staat in publiek-bestand.mjs.
import { behandel, fout, sql } from "../lib/server.mjs";
import { geldigeSleutel, haalBestand } from "../lib/bestanden.mjs";
import { bestandsAntwoord } from "../lib/download.mjs";

export default behandel(async (req) => {
  const sleutel = new URL(req.url).searchParams.get("sleutel") || "";
  if (!geldigeSleutel(sleutel)) return fout(400, "Onbekend bestand.");
  const [rij] = await sql`
    SELECT bestandsnaam, bestand_mime FROM bijlage WHERE bestand_sleutel = ${sleutel}
    UNION ALL
    SELECT bestandsnaam, bestand_mime FROM voorstel WHERE bestand_sleutel = ${sleutel}
    LIMIT 1`;
  if (!rij) return fout(404, "Dit bestand hoort niet bij een bijlage of voorstel.");
  const inhoud = await haalBestand(sleutel);
  if (!inhoud) return fout(404, "Het bestand is niet gevonden in de opslag.");
  return bestandsAntwoord(inhoud, rij.bestandsnaam, rij.bestand_mime);
});

export const config = { path: "/api/bestand", method: "GET" };
