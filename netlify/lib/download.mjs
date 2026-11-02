// Downloadantwoord met veilige bestandsnaam. Gedeeld door de redactie- en de publieke downloadroute.
// Alleen Web APIs, geen Netlify-afhankelijkheden.
export function bestandsAntwoord(inhoud, bestandsnaam, mime, extraHeaders = {}) {
  const naam = bestandsnaam || "bestand";
  const ascii = naam.replace(/[^\x20-\x7e]/g, "_").replace(/["\\]/g, "");
  return new Response(inhoud, {
    status: 200,
    headers: {
      "Content-Type": mime || "application/octet-stream",
      "Content-Disposition": `attachment; filename="${ascii}"; filename*=UTF-8''${encodeURIComponent(naam)}`,
      "Cache-Control": "private, no-store",
      "X-Content-Type-Options": "nosniff",
      ...extraHeaders,
    },
  });
}
