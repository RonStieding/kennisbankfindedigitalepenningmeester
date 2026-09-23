// Gedeeld gedrag voor alle pagina's.
import { gekozenRedacteur, kiesRedacteur, haalRedacteuren, haalVoorstellen } from "./data.js";

// "Ik ben …" in de kopbalk. De gekozen naam wordt bewaard in deze browser en
// meegestuurd met elke actie, zodat vastligt wie een voorstel indient of goedkeurt.
export async function toonRedacteurKeuze(opWissel = null) {
  const plek = document.getElementById("gebruiker");
  if (!plek) return;
  let namen = [];
  try { namen = await haalRedacteuren(); } catch { return; }
  const huidig = gekozenRedacteur();
  if (huidig && !namen.includes(huidig)) kiesRedacteur("");

  plek.innerHTML = "";
  const label = document.createElement("label");
  label.className = "ik-ben";
  label.htmlFor = "ik-ben";
  label.textContent = "Ik ben";
  const keuze = document.createElement("select");
  keuze.id = "ik-ben";
  keuze.className = "ik-ben-keuze";
  const leeg = new Option("kies je naam", "");
  keuze.add(leeg);
  for (const n of namen) keuze.add(new Option(n, n));
  keuze.value = gekozenRedacteur();
  keuze.classList.toggle("nog-kiezen", !keuze.value);
  keuze.addEventListener("change", () => {
    kiesRedacteur(keuze.value);
    keuze.classList.toggle("nog-kiezen", !keuze.value);
    if (opWissel) opWissel(keuze.value);
  });
  plek.append(label, keuze);
}

// Teller "Openstaande voorstellen" in de kopbalk: voorstellen die ter validatie liggen.
export async function werkTellerBij() {
  try {
    const { voorstellen } = await haalVoorstellen("open");
    const n = voorstellen.filter((v) => v.status === "ter_validatie").length;
    document.querySelectorAll("[data-teller-voorstellen]").forEach((el) => { el.textContent = n; });
  } catch { /* teller is niet essentieel */ }
}

// Afbeeldingen van Fin en het logo zijn nog niet aangeleverd.
// Ontbreekt een bestand, dan verdwijnt het beeld netjes (of verschijnt de tekstvariant van het logo).
export function beeldenTerugval(root = document) {
  root.querySelectorAll("img[data-optioneel]").forEach((img) => {
    const weg = () => {
      const doel = img.closest("[data-beeldvak]") || img;
      doel.remove();
    };
    if (img.complete && img.naturalWidth === 0) weg();
    else img.addEventListener("error", weg, { once: true });
  });
  root.querySelectorAll("img[data-logo]").forEach((img) => {
    const tekst = () => { img.hidden = true; img.nextElementSibling?.removeAttribute("hidden"); };
    if (img.complete && img.naturalWidth === 0) tekst();
    else img.addEventListener("error", tekst, { once: true });
  });
}

// Zoekbalk in de kopbalk: op de startpagina wordt direct gezocht,
// op andere pagina's ga je naar de startpagina met de zoekvraag.
export function kopZoekbalk(opZoek) {
  const form = document.getElementById("zoek-globaal");
  const veld = document.getElementById("zoek-globaal-veld");
  if (!form || !veld) return;
  const q = new URLSearchParams(location.search).get("q");
  if (q && opZoek) veld.value = q;
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const waarde = veld.value.trim();
    if (opZoek) opZoek(waarde);
    else location.href = "/" + (waarde ? "?q=" + encodeURIComponent(waarde) : "");
  });
  if (opZoek) {
    let timer;
    veld.addEventListener("input", () => {
      clearTimeout(timer);
      timer = setTimeout(() => opZoek(veld.value.trim()), 200);
    });
  }
}

export function toonFout(el, bericht) {
  el.innerHTML = "";
  const wrap = document.createElement("div");
  wrap.className = "wrap";
  wrap.style.padding = "32px 24px";
  const p = document.createElement("p");
  p.className = "melding fout";
  p.textContent = bericht;
  wrap.appendChild(p);
  el.appendChild(wrap);
}
