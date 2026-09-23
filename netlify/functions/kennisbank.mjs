// GET /api/kennisbank – alle hoofdstukken, alleen de actuele goedgekeurde versies.
// Gebruikt door de startpagina (tegels, signaleringen en de zoekfunctie).
import { behandel, json, sql } from "../lib/server.mjs";
import { alleHoofdstukken } from "../lib/kennisbank.mjs";

export default behandel(async () => {
  const hoofdstukken = await alleHoofdstukken(sql);
  return json({ hoofdstukken });
});

export const config = { path: "/api/kennisbank", method: "GET" };
