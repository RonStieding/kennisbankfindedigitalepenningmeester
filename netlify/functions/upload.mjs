// POST /api/upload – een bestand (Word, pdf of Excel, max. 5 MB) uploaden voor een bijlage-voorstel.
// Het bestand is pas zichtbaar in de kennisbank nadat het voorstel is goedgekeurd.
// De inhoud komt als ruwe bytes; de bestandsnaam in de kop X-Bestandsnaam.
import { behandel, fout, json, vereisRedacteur } from "../lib/server.mjs";
import { bewaarBestand, MAX_GROOTTE } from "../lib/bestanden.mjs";

export default behandel(async (req) => {
  const herkomst = req.headers.get("origin");
  if (herkomst && new URL(herkomst).host !== new URL(req.url).host) return fout(403, "Dit verzoek komt niet van de kennisbank zelf en is geweigerd.");
  const uploader = vereisRedacteur(req);
  const lengte = Number(req.headers.get("content-length") || 0);
  if (lengte > MAX_GROOTTE) return fout(413, "Het bestand is groter dan 5 MB.");
  let naam = req.headers.get("x-bestandsnaam") || "";
  try { naam = decodeURIComponent(naam); } catch { /* laat zoals het is */ }
  const inhoud = await req.arrayBuffer();
  return json(await bewaarBestand(inhoud, naam, uploader), 201);
});

export const config = { path: "/api/upload", method: "POST" };
