// GET /api/hoofdstuk?id=H01 – één hoofdstuk: actuele goedgekeurde versie plus versiegeschiedenis.
// GET /api/hoofdstuk?id=H01&versie=5 – een eerdere goedgekeurde versie, voor de vergelijking.
import { behandel, fout, json, sql } from "../lib/server.mjs";
import { eenHoofdstuk, geldigHoofdstukId, versieVanHoofdstuk } from "../lib/kennisbank.mjs";

export default behandel(async (req) => {
  const params = new URL(req.url).searchParams;
  const id = (params.get("id") || "").toUpperCase();
  if (!geldigHoofdstukId(id)) return fout(400, "Onbekend hoofdstuknummer.");
  // Een eerdere versie opvragen (voor de vergelijking): ?id=H01&versie=<versie-id>
  if (params.has("versie")) {
    const versieId = Number(params.get("versie"));
    if (!Number.isInteger(versieId) || versieId < 1) return fout(400, "Onbekende versie.");
    const versie = await versieVanHoofdstuk(sql, id, versieId);
    if (!versie) return fout(404, "Deze versie bestaat niet of is niet goedgekeurd.");
    return json({ versie });
  }
  const hoofdstuk = await eenHoofdstuk(sql, id);
  if (!hoofdstuk) return fout(404, `Hoofdstuk ${id} bestaat niet of heeft nog geen goedgekeurde versie.`);
  return json({ hoofdstuk });
});

export const config = { path: "/api/hoofdstuk", method: "GET" };
