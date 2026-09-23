// Hulpfuncties voor paragraaftekst (zelfde regels als bij de import).
import { createHash } from "node:crypto";

export function controlegetal(tekst) {
  return createHash("sha256").update(tekst, "utf8").digest("hex").slice(0, 16);
}

export function bronnenUit(tekst) {
  const gezien = new Set();
  const bronnen = [];
  for (const m of tekst.matchAll(/\[([^\]]+)\]\((https?:\/\/[^)\s]+)\)/g)) {
    if (!gezien.has(m[2])) { gezien.add(m[2]); bronnen.push({ label: m[1], url: m[2] }); }
  }
  return bronnen;
}

// Tekst uit een formulier: regeleinden gelijktrekken, spaties aan begin en eind weg.
export function schoon(waarde, max) {
  if (waarde === null || waarde === undefined) return null;
  const t = String(waarde).replace(/\r\n?/g, "\n").trim();
  if (max && t.length > max) return { teLang: true, tekst: t };
  return t;
}

export function volgendeVersie(nummer) {
  const [hoofd, sub] = String(nummer).split(".").map((x) => parseInt(x, 10));
  return `${Number.isFinite(hoofd) ? hoofd : 1}.${(Number.isFinite(sub) ? sub : 0) + 1}`;
}
