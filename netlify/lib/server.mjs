// Gedeelde serverlogica voor alle Netlify Functions van de kennisbank.
//
// Toegang: het Netlify-project staat op Private. Alleen leden van het Netlify-team
// kunnen de site en deze functies bereiken. Er is daarom geen aparte inlog.
//
// Wie iets doet: de redacteur kiest in de site "Ik ben Paul" of "Ik ben Ron". Die naam gaat
// mee in de kop X-Redacteur. Bij schrijfacties (vanaf bouwstap 3) controleert de server die
// naam tegen de lijst van redacteuren, en weigert de server en de database dat iemand zijn
// eigen voorstel goedkeurt.

import { getDatabase } from "@netlify/database";
import { REDACTEUREN } from "./redacteuren.mjs";

let database = null;
export function db() {
  if (!database) database = getDatabase();
  return database;
}

// Tagged-template-query die altijd via het databaseobject wordt aangeroepen.
export function sql(strings, ...waarden) {
  return db().sql(strings, ...waarden);
}

export function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": "private, no-store",
      "X-Content-Type-Options": "nosniff",
    },
  });
}

export function fout(status, bericht) {
  return json({ fout: bericht }, status);
}

// Geeft de gekozen redacteur terug, of gooit een 400-antwoord als de naam ontbreekt of onbekend is.
export function vereisRedacteur(req) {
  let naam = req.headers.get("x-redacteur") || "";
  try { naam = decodeURIComponent(naam); } catch { /* laat zoals het is */ }
  naam = naam.trim();
  if (!REDACTEUREN.includes(naam)) {
    throw fout(400, "Kies eerst bovenin wie je bent (Paul Baans of Ron Stieding).");
  }
  return naam;
}

// Schrijfacties alleen vanaf de eigen site (bescherming tegen verzoeken vanaf andere websites).
export function vereisZelfdeHerkomst(req) {
  const herkomst = req.headers.get("origin");
  if (herkomst && new URL(herkomst).host !== new URL(req.url).host) {
    throw fout(403, "Dit verzoek komt niet van de kennisbank zelf en is geweigerd.");
  }
  const type = req.headers.get("content-type") || "";
  if (!type.includes("application/json")) throw fout(415, "Verwacht JSON.");
}

export async function leesJson(req) {
  try { return await req.json(); } catch { throw fout(400, "Het verzoek kon niet worden gelezen."); }
}

// Vier-ogenprincipe: niemand keurt een eigen voorstel goed.
export function vereisAndereRedacteur(indiener, beoordelaar) {
  if (indiener === beoordelaar) {
    throw fout(403, "Je kunt je eigen voorstel niet goedkeuren of afwijzen. Dat doet de andere redacteur.");
  }
}

// Omhulsel voor een functie: vangt nette foutantwoorden en onverwachte fouten af.
export function behandel(fn) {
  return async (req, context) => {
    try {
      return await fn(req, context);
    } catch (e) {
      if (e instanceof Response) return e;
      console.error(e);
      return fout(500, "Er ging iets mis op de server. Probeer het later opnieuw.");
    }
  };
}
