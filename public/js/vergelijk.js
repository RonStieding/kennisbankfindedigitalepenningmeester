// Vergelijking tussen twee teksten op woordniveau.
// Verwijderde tekst wordt doorgestreept (<del>), nieuwe tekst gemarkeerd (<ins>).
import { escapeHtml } from "./tekst.js";

function stukken(tekst) {
  return (tekst || "").split(/(\s+)/).filter((x) => x !== "");
}

// Kortste bewerkingsreeks via de langste gemeenschappelijke deelreeks (LCS).
function bewerkingen(a, b) {
  const n = a.length, m = b.length;
  if (n * m > 6_000_000) return null; // te groot: val terug op regelvergelijking
  const breedte = m + 1;
  const tabel = new Uint32Array((n + 1) * breedte);
  for (let i = n - 1; i >= 0; i--) {
    for (let j = m - 1; j >= 0; j--) {
      tabel[i * breedte + j] = a[i] === b[j]
        ? tabel[(i + 1) * breedte + j + 1] + 1
        : Math.max(tabel[(i + 1) * breedte + j], tabel[i * breedte + j + 1]);
    }
  }
  const uit = [];
  let i = 0, j = 0;
  while (i < n && j < m) {
    if (a[i] === b[j]) { uit.push(["=", a[i]]); i++; j++; }
    else if (tabel[(i + 1) * breedte + j] >= tabel[i * breedte + j + 1]) { uit.push(["-", a[i]]); i++; }
    else { uit.push(["+", b[j]]); j++; }
  }
  while (i < n) uit.push(["-", a[i++]]);
  while (j < m) uit.push(["+", b[j++]]);
  return uit;
}

// Voegt opeenvolgende gelijke soorten samen voor een rustiger beeld.
function samenvoegen(lijst) {
  const uit = [];
  for (const [soort, tekst] of lijst) {
    const laatste = uit[uit.length - 1];
    if (laatste && laatste[0] === soort) laatste[1] += tekst;
    else uit.push([soort, tekst]);
  }
  return uit;
}

export function vergelijkHtml(oud, nieuw) {
  let ops = bewerkingen(stukken(oud), stukken(nieuw));
  if (!ops) {
    const regelsA = (oud || "").split(/(\n)/), regelsB = (nieuw || "").split(/(\n)/);
    ops = bewerkingen(regelsA, regelsB) || [["-", oud], ["+", nieuw]];
  }
  return samenvoegen(ops).map(([soort, tekst]) => {
    const t = escapeHtml(tekst);
    if (soort === "-") return `<del>${t}</del>`;
    if (soort === "+") return `<ins>${t}</ins>`;
    return t;
  }).join("");
}

export function isGelijk(a, b) {
  return (a || "") === (b || "");
}
