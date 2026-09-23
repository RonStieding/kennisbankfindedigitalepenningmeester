// Datums altijd in Nederlandse tijd, als 'JJJJ-MM-DD'.
export function vandaagNL() {
  return new Intl.DateTimeFormat("en-CA", { timeZone: "Europe/Amsterdam", year: "numeric", month: "2-digit", day: "2-digit" }).format(new Date());
}

export function plusMaanden(iso, maanden) {
  const [j, m, d] = iso.split("-").map(Number);
  const doel = new Date(Date.UTC(j, m - 1 + maanden, 1));
  const laatsteDag = new Date(Date.UTC(doel.getUTCFullYear(), doel.getUTCMonth() + 1, 0)).getUTCDate();
  doel.setUTCDate(Math.min(d, laatsteDag));
  return doel.toISOString().slice(0, 10);
}

export function geldigeDatum(iso) {
  if (typeof iso !== "string" || !/^\d{4}-\d{2}-\d{2}$/.test(iso)) return false;
  const [j, m, d] = iso.split("-").map(Number);
  const t = new Date(Date.UTC(j, m - 1, d));
  return t.getUTCFullYear() === j && t.getUTCMonth() === m - 1 && t.getUTCDate() === d;
}
