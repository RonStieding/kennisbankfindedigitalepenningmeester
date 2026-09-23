#!/usr/bin/env python3
"""Zet de Word-kennisbank (tekstexport) om naar importbestanden per hoofdstuk.

Uitgangspunt: de inhoud wordt NIET gewijzigd. Alleen structuur wordt toegevoegd
(paragraaf-ID's, volgorde, reviewdatum, bronnenlijst afgeleid uit de links in de tekst).
"""
import json, re, sys, hashlib, datetime, pathlib

SRC = pathlib.Path(sys.argv[1])
OUT = pathlib.Path(sys.argv[2])
IMPORT_DATE = datetime.date(2026, 9, 19)
REVIEW_MONTHS = 12
SOURCE_DOC = "Vragenlijst Fin – FinSport versie 2 (Word)"
APPROVED_BY = "Paul Baans"

def add_months(d, m):
    y, mo = divmod(d.month - 1 + m, 12)
    return d.replace(year=d.year + y, month=mo + 1)

lines = SRC.read_text(encoding="utf-8").splitlines()

# 1. Inhoudsopgave uitlezen: dit is de gezaghebbende lijst van koppen.
toc = []
for ln in lines:
    if ln.startswith("\t") and ln.count("\t") >= 2:
        title = ln.split("\t")[1].strip()
        toc.append(title)
toc_set = set(toc)

# 2. Body: alles vanaf de eerste hoofdstukkop die NA de inhoudsopgave staat.
start = next(i for i, ln in enumerate(lines) if ln.startswith("Hoofdstuk 1 ") and not ln.startswith("\t"))
body = lines[start:]

chap_re = re.compile(r"^Hoofdstuk (\d+) — (.+)$")
num_re = re.compile(r"^(\d+(?:\.\d+)?)\.?\s+(.+)$")
link_re = re.compile(r"\[([^\]]+)\]\((https?://[^)]+)\)")

chapters = []
cur = None
sec = None

def close_section():
    global sec
    if sec is not None:
        # verwijder lege regels aan begin/eind, verder letterlijk laten staan
        while sec["_lines"] and not sec["_lines"][0].strip():
            sec["_lines"].pop(0)
        while sec["_lines"] and not sec["_lines"][-1].strip():
            sec["_lines"].pop()
        sec["body"] = "\n".join(sec.pop("_lines"))
        cur["sections"].append(sec)
    sec = None

for ln in body:
    m = chap_re.match(ln)
    if m and ln in toc_set:
        if cur:
            close_section()
            chapters.append(cur)
        cur = {"number": int(m.group(1)), "title": m.group(2).strip(), "heading_original": ln, "sections": []}
        sec = {"kind": "inleiding", "number": None, "title": "Inleiding", "heading_original": None, "_lines": []}
        continue
    if ln in toc_set:
        close_section()
        nm = num_re.match(ln)
        if nm:
            sec = {"kind": "vraag", "number": nm.group(1), "title": nm.group(2).strip(), "heading_original": ln, "_lines": []}
        else:
            low = ln.lower()
            kind = "checklist" if ("checklist" in low or "controlelijst" in low or "jaarcontrole" in low or "controle voor" in low) else "overzicht"
            if low.startswith("praktisch voorbeeld"):
                kind = "voorbeeld"
            sec = {"kind": kind, "number": None, "title": ln.strip(), "heading_original": ln, "_lines": []}
        continue
    if ln.startswith("Kern van dit hoofdstuk:"):
        close_section()
        sec = {"kind": "kern", "number": None, "title": "Kern van dit hoofdstuk", "heading_original": None, "_lines": [ln]}
        continue
    sec["_lines"].append(ln)
close_section()
chapters.append(cur)

# 3. Controle: zijn alle koppen uit de inhoudsopgave gevonden?
found = set()
for c in chapters:
    found.add(c["heading_original"])
    for s in c["sections"]:
        if s["heading_original"]:
            found.add(s["heading_original"])
missing = [t for t in toc if t not in found]
assert not missing, f"Koppen uit inhoudsopgave niet gevonden: {missing}"

# 4. Verrijken met ID's, reviewdatum, bronnen; wegschrijven.
OUT.mkdir(parents=True, exist_ok=True)
review = add_months(IMPORT_DATE, REVIEW_MONTHS).isoformat()
manifest = []
total_words = 0
for c in chapters:
    cid = f"H{c['number']:02d}"
    # korte omschrijving: eerste zin van de inleiding, letterlijk
    intro = c["sections"][0]["body"].split("\n")[0]
    first_sentence = re.split(r"(?<=[.?!])\s", intro, maxsplit=1)[0]
    secs = []
    for i, s in enumerate(c["sections"]):
        sources, seen = [], set()
        for label, url in link_re.findall(s["body"]):
            if url not in seen:
                seen.add(url); sources.append({"label": label, "url": url})
        words = len(re.sub(r"\(https?://[^)]+\)", "", s["body"]).split())
        total_words += words
        secs.append({
            "id": f"{cid}-P{i:02d}",
            "order": i,
            "kind": s["kind"],
            "number": s["number"],
            "title": s["title"],
            "heading_original": s["heading_original"],
            "body": s["body"],
            "format": "markdown",
            "sources": sources,
            "review": {"date": review, "term_months": REVIEW_MONTHS},
            "checksum": hashlib.sha256(s["body"].encode("utf-8")).hexdigest()[:16],
        })
    data = {
        "schema": "fin-kennisbank/import@1",
        "chapter": {
            "id": cid,
            "number": c["number"],
            "title": c["title"],
            "heading_original": c["heading_original"],
            "description": first_sentence,
        },
        "version": {
            "number": "1.0",
            "status": "goedgekeurd",
            "date": IMPORT_DATE.isoformat(),
            "basisversie": True,
            "author": "Import uit " + SOURCE_DOC,
            "approved_by": APPROVED_BY,
            "note": "Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.",
        },
        "sections": secs,
        "attachments": [],
    }
    fn = OUT / f"{cid}.json"
    fn.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    manifest.append({"id": cid, "number": c["number"], "title": c["title"], "description": first_sentence,
                     "file": fn.name, "sections": len(secs), "version": "1.0", "date": IMPORT_DATE.isoformat()})
    print(f"{cid}: {len(secs):2d} paragrafen – {c['title']}")

(OUT / "manifest.json").write_text(json.dumps({"schema": "fin-kennisbank/manifest@1", "source": SOURCE_DOC,
    "generated": IMPORT_DATE.isoformat(), "chapters": manifest}, ensure_ascii=False, indent=2), encoding="utf-8")
print("woorden (zonder URL's):", total_words)
