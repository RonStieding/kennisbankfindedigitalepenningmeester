// GET /api/publiek/bijlage/H03-B02 – publieke download van een goedgekeurde bestandsbijlage.
// Geen login, geen token: wat goedgekeurd in de kennisbank staat, mag Fin delen.
// De Edge Function (wachtwoord.js) laat dit pad door; alle controle staat in lib/publieke-bijlage.mjs.
import { db } from "../lib/server.mjs";
import { haalBestand } from "../lib/bestanden.mjs";
import { maakPubliekeBijlageHandler, ZOEK_ACTIEVE_BESTANDSBIJLAGE } from "../lib/publieke-bijlage.mjs";

export default maakPubliekeBijlageHandler({
  zoekBijlage: async (id) => (await db().pool.query(ZOEK_ACTIEVE_BESTANDSBIJLAGE, [id])).rows[0] || null,
  leesBestand: haalBestand,
});

// Geen method-filter in de config: de handler geeft zelf een JSON 405 bij andere methoden.
export const config = { path: "/api/publiek/bijlage/:id" };
