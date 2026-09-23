// GET  /api/voorstel?id=12 – één voorstel met de tekst ervoor en erna
// POST /api/voorstel – actie: bewerken, indienen, terug_naar_concept, intrekken, goedkeuren, afwijzen
import { behandel, fout, json, sql, vereisRedacteur, vereisZelfdeHerkomst, leesJson } from "../lib/server.mjs";
import { eenVoorstel, voerActieUit, CHECKLIST } from "../lib/voorstellen.mjs";

export default behandel(async (req) => {
  if (req.method === "POST") {
    vereisZelfdeHerkomst(req);
    const gebruiker = vereisRedacteur(req);
    return json(await voerActieUit(gebruiker, await leesJson(req)));
  }
  const id = Number(new URL(req.url).searchParams.get("id"));
  if (!Number.isInteger(id) || id < 1) return fout(400, "Onbekend voorstel.");
  const voorstel = await eenVoorstel(sql, id);
  if (!voorstel) return fout(404, `Voorstel ${id} bestaat niet.`);
  return json({ voorstel, checklist: CHECKLIST });
});

export const config = { path: "/api/voorstel", method: ["GET", "POST"] };
