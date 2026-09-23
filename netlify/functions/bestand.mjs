// GET /api/bestand?sleutel=… – een bestand van een bijlage (of van een bijlage-voorstel) downloaden.
// Alleen bestanden die in de database bij een bijlage of voorstel horen, worden geleverd.
import { behandel, fout, sql } from "../lib/server.mjs";
import { geldigeSleutel, haalBestand } from "../lib/bestanden.mjs";

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
  const naam = rij.bestandsnaam || "bestand";
  const ascii = naam.replace(/[^\x20-\x7e]/g, "_").replace(/"/g, "");
  return new Response(inhoud, {
    status: 200,
    headers: {
      "Content-Type": rij.bestand_mime || "application/octet-stream",
      "Content-Disposition": `attachment; filename="${ascii}"; filename*=UTF-8''${encodeURIComponent(naam)}`,
      "Cache-Control": "private, no-store",
      "X-Content-Type-Options": "nosniff",
    },
  });
});

export const config = { path: "/api/bestand", method: "GET" };
