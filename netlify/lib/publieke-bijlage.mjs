// Publieke download van goedgekeurde bestandsbijlagen, zonder login.
//
// Regel: wat goedgekeurd in de kennisbank staat, mag Fin delen. De tabel `bijlage` bevat per
// definitie alleen goedgekeurde bijlagen; concepten en voorstellen staan in `voorstel` en zijn
// hier nooit bereikbaar. Alleen de actieve revisie van een bijlage-ID wordt geleverd, dus na
// vervanging levert dezelfde link het nieuwe bestand en is de oude revisie weg.
//
// Alleen Web APIs plus de twee meegegeven functies, zodat de route zonder Netlify te testen is.
import { publiekeBijlageId } from "./agent-access.mjs";
import { bestandsAntwoord } from "./download.mjs";

function jsonAntwoord(data, status, extraHeaders = {}) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": "private, no-store",
      "X-Content-Type-Options": "nosniff",
      "X-Robots-Tag": "noindex, nofollow",
      ...extraHeaders,
    },
  });
}

// Eén antwoord voor alles wat niet geleverd wordt: onbekend, vervallen, link of alleen bij een voorstel.
const nietBeschikbaar = () => jsonAntwoord({ fout: "Deze bijlage is niet (meer) beschikbaar." }, 404);

// zoekBijlage(id) geeft de actieve bestandsbijlage terug ({ bestand_sleutel, bestandsnaam, bestand_mime,
// bestand_grootte }) of null. leesBestand(sleutel) geeft een ArrayBuffer of null.
export function maakPubliekeBijlageHandler({ zoekBijlage, leesBestand, logError = console.error }) {
  return async (request) => {
    if (request.method !== "GET") {
      return jsonAntwoord({ fout: "Alleen GET." }, 405, { Allow: "GET" });
    }
    const id = publiekeBijlageId(new URL(request.url));
    if (!id) return nietBeschikbaar();
    try {
      const rij = await zoekBijlage(id);
      if (!rij || !rij.bestand_sleutel) return nietBeschikbaar();
      const inhoud = await leesBestand(rij.bestand_sleutel);
      if (!inhoud || inhoud.byteLength !== Number(rij.bestand_grootte)) {
        logError(`Publieke bijlage ${id}: bestand ontbreekt of heeft een andere grootte dan vastgelegd.`);
        return nietBeschikbaar();
      }
      return bestandsAntwoord(inhoud, rij.bestandsnaam, rij.bestand_mime, { "X-Robots-Tag": "noindex, nofollow" });
    } catch {
      logError(`Publieke bijlage ${id}: bron niet beschikbaar.`);
      return jsonAntwoord({ fout: "De bijlage kan nu niet worden geleverd. Probeer het later opnieuw." }, 503);
    }
  };
}

// SQL voor de Function: alleen de actieve revisie, alleen bestanden (geen links).
export const ZOEK_ACTIEVE_BESTANDSBIJLAGE = `
  SELECT bestand_sleutel, bestandsnaam, bestand_mime, bestand_grootte
  FROM bijlage
  WHERE bijlage_id = $1 AND status = 'actief' AND soort <> 'link' AND bestand_sleutel IS NOT NULL`;
