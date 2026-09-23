// GET  /api/voorstellen?groep=open|afgerond&hoofdstuk=H01 – lijst met voorstellen
// POST /api/voorstellen – nieuw voorstel (als concept, of direct ter validatie)
import { behandel, json, sql, vereisRedacteur, vereisZelfdeHerkomst, leesJson } from "../lib/server.mjs";
import { lijstVoorstellen, maakVoorstel } from "../lib/voorstellen.mjs";

export default behandel(async (req) => {
  if (req.method === "POST") {
    vereisZelfdeHerkomst(req);
    const auteur = vereisRedacteur(req);
    const id = await maakVoorstel(auteur, await leesJson(req));
    return json({ id }, 201);
  }
  const params = new URL(req.url).searchParams;
  const groep = params.get("groep") === "afgerond" ? "afgerond" : "open";
  const hoofdstuk = (params.get("hoofdstuk") || "").toUpperCase() || null;
  return json({ voorstellen: await lijstVoorstellen(sql, { groep, hoofdstukId: hoofdstuk }) });
});

export const config = { path: "/api/voorstellen", method: ["GET", "POST"] };
