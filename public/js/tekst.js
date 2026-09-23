// Weergave van kennisbanktekst (Markdown-subset uit de import) en zoekhulpen.
// Ondersteund: alinea's, opsommingen met "- ", tabellen met "|", **vet** en [links](url).
// De tekst zelf wordt nooit aangepast; dit bestand bepaalt alleen de weergave.

export function escapeHtml(s) {
  return s.replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
}

function inline(tekst) {
  let html = escapeHtml(tekst);
  html = html.replace(/\[([^\]]+)\]\((https?:\/\/[^)\s]+)\)/g,
    (_, label, url) => `<a href="${url}" target="_blank" rel="noopener noreferrer">${label}</a>`);
  html = html.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
  return html;
}

function tabelRij(regel) {
  return regel.trim().replace(/^\|/, "").replace(/\|$/, "").split("|").map((c) => c.trim());
}

function isFormule(regel) {
  return / = /.test(regel) && regel.length < 200 && !/\.\s/.test(regel) && !regel.startsWith("|");
}

export function markdownNaarHtml(bron) {
  const regels = bron.split("\n");
  const uit = [];
  let i = 0;
  while (i < regels.length) {
    const r = regels[i];
    if (!r.trim()) { i++; continue; }

    if (r.trim().startsWith("|")) {
      const rijen = [];
      while (i < regels.length && regels[i].trim().startsWith("|")) rijen.push(regels[i++]);
      const kop = tabelRij(rijen[0]);
      const body = rijen.slice(1).filter((x) => !/^\|\s*-{3,}/.test(x.trim())).map(tabelRij);
      uit.push('<div class="tabel-wrap"><table><thead><tr>' +
        kop.map((c) => `<th scope="col">${inline(c.replace(/^\*\*(.*)\*\*$/, "$1"))}</th>`).join("") +
        "</tr></thead><tbody>" +
        body.map((rij) => "<tr>" + rij.map((c) => `<td>${inline(c)}</td>`).join("") + "</tr>").join("") +
        "</tbody></table></div>");
      continue;
    }

    if (r.startsWith("- ")) {
      const items = [];
      while (i < regels.length) {
        if (regels[i].startsWith("- ")) { items.push(regels[i].slice(2)); i++; }
        else if (!regels[i].trim() && regels[i + 1]?.startsWith("- ")) { i++; }
        else break;
      }
      uit.push("<ul>" + items.map((t) => `<li>${inline(t)}</li>`).join("") + "</ul>");
      continue;
    }

    uit.push(isFormule(r) ? `<p class="formule">${inline(r)}</p>` : `<p>${inline(r)}</p>`);
    i++;
  }
  return uit.join("\n");
}

// Platte tekst voor zoeken en fragmenten.
export function platteTekst(bron) {
  return bron
    .replace(/\[([^\]]+)\]\((https?:\/\/[^)\s]+)\)/g, "$1")
    .replace(/\*\*/g, "")
    .replace(/^\|\s*-{3,}.*$/gm, "")
    .replace(/\|/g, " ")
    .replace(/^- /gm, "")
    .replace(/\s+/g, " ")
    .trim();
}

// Zoeken is ongevoelig voor hoofdletters en accenten (financiele = financiële).
export function normaliseer(s) {
  return s.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
}

export function zoektermen(invoer) {
  return [...new Set(normaliseer(invoer).split(/\s+/)
    .map((t) => t.replace(/[^\p{L}\p{N}€%.,:*-]/gu, "").replace(/^[.,:*-]+|[.,:*-]+$/g, ""))
    .filter((t) => t.length >= 2))];
}

function telVoorkomens(hooiberg, naald) {
  let n = 0, p = hooiberg.indexOf(naald);
  while (p !== -1) { n++; p = hooiberg.indexOf(naald, p + naald.length); }
  return n;
}

// Scoort een paragraaf; 0 = geen treffer (alle termen moeten voorkomen).
export function scoor(titelNorm, tekstNorm, termen) {
  let score = 0;
  for (const t of termen) {
    const inTitel = telVoorkomens(titelNorm, t);
    const inTekst = telVoorkomens(tekstNorm, t);
    if (!inTitel && !inTekst) return 0;
    score += inTitel * 5 + inTekst;
  }
  return score;
}

export function fragment(plat, termen, breedte = 110) {
  const norm = normaliseer(plat);
  let pos = -1;
  for (const t of termen) { const p = norm.indexOf(t); if (p !== -1 && (pos === -1 || p < pos)) pos = p; }
  if (pos === -1) pos = 0;
  let begin = Math.max(0, pos - breedte);
  let eind = Math.min(plat.length, pos + breedte);
  // afbreken op woordgrenzen
  if (begin > 0) { const sp = plat.indexOf(" ", begin); if (sp !== -1 && sp < pos) begin = sp + 1; }
  if (eind < plat.length) { const sp = plat.lastIndexOf(" ", eind); if (sp > pos) eind = sp; }
  return (begin > 0 ? "… " : "") + plat.slice(begin, eind).trim() + (eind < plat.length ? " …" : "");
}

// Markeert zoektermen in de tekstknopen van een element. Geeft het aantal markeringen terug.
export function markeer(root, termen) {
  if (!termen.length) return 0;
  const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
    acceptNode: (n) => (n.parentElement.closest("mark, script, style, button, .par-meta, .par-acties") ? NodeFilter.FILTER_REJECT : NodeFilter.FILTER_ACCEPT),
  });
  const knopen = [];
  while (walker.nextNode()) knopen.push(walker.currentNode);
  let totaal = 0;
  for (const knoop of knopen) {
    const origineel = knoop.nodeValue;
    // genormaliseerde tekst met verwijzing naar de oorspronkelijke posities
    let norm = "";
    const kaart = [];
    for (let i = 0; i < origineel.length; i++) {
      const n = normaliseer(origineel[i]);
      for (let k = 0; k < n.length; k++) { norm += n[k]; kaart.push(i); }
    }
    const reeksen = [];
    for (const t of termen) {
      let p = norm.indexOf(t);
      while (p !== -1) { reeksen.push([kaart[p], kaart[p + t.length - 1] + 1]); p = norm.indexOf(t, p + t.length); }
    }
    if (!reeksen.length) continue;
    reeksen.sort((a, b) => a[0] - b[0]);
    const samengevoegd = [];
    for (const r of reeksen) {
      const laatste = samengevoegd[samengevoegd.length - 1];
      if (laatste && r[0] <= laatste[1]) laatste[1] = Math.max(laatste[1], r[1]); else samengevoegd.push([...r]);
    }
    const frag = document.createDocumentFragment();
    let cursor = 0;
    for (const [a, b] of samengevoegd) {
      if (a > cursor) frag.appendChild(document.createTextNode(origineel.slice(cursor, a)));
      const m = document.createElement("mark");
      m.textContent = origineel.slice(a, b);
      frag.appendChild(m);
      cursor = b;
      totaal++;
    }
    if (cursor < origineel.length) frag.appendChild(document.createTextNode(origineel.slice(cursor)));
    knoop.parentNode.replaceChild(frag, knoop);
  }
  return totaal;
}

export function verwijderMarkering(root) {
  root.querySelectorAll("mark").forEach((m) => m.replaceWith(document.createTextNode(m.textContent)));
  root.normalize();
}
