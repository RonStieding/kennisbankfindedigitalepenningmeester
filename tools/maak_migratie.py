#!/usr/bin/env python3
"""Maakt de datamigratie voor basisversie 1.0 uit de importbestanden in /import.

Gebruik (vanuit de hoofdmap van de repository):
    python3 tools/maak_migratie.py

Resultaat: netlify/database/migrations/20260919120100_basisversie_1_0.sql
Netlify voert die migratie één keer uit bij de eerste deploy. Draai dit script
daarna niet opnieuw: een uitgevoerde migratie mag nooit meer veranderen.
"""
import hashlib, json, pathlib, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
IMPORT = ROOT / "import"
UIT = ROOT / "netlify" / "database" / "migrations" / "20260919120100_basisversie_1_0.sql"


def q(waarde):
    """SQL-tekstwaarde; NULL voor None."""
    if waarde is None:
        return "NULL"
    s = str(waarde)
    if "\x00" in s:
        raise ValueError("NUL-teken in tekst")
    return "'" + s.replace("'", "''") + "'"


def datum(iso):
    return f"DATE {q(iso)}"


def main():
    manifest = json.loads((IMPORT / "manifest.json").read_text(encoding="utf-8"))
    regels = [
        "-- Kennisbank Fin – datamigratie basisversie 1.0",
        f"-- Gegenereerd door tools/maak_migratie.py uit {manifest['source']}.",
        "-- NIET WIJZIGEN nadat deze migratie is uitgevoerd.",
        "-- Werkwijze per hoofdstuk: versie aanmaken als concept, paragrafen toevoegen,",
        "-- daarna goedkeuren (de database staat niet toe dat een versie direct als goedgekeurd wordt ingevoegd).",
        "",
    ]
    aantal_par = 0
    for item in manifest["chapters"]:
        data = json.loads((IMPORT / item["file"]).read_text(encoding="utf-8"))
        c, v = data["chapter"], data["version"]
        if data["schema"] != "fin-kennisbank/import@1":
            sys.exit(f"Onbekend schema in {item['file']}")
        if not v.get("approved_by"):
            sys.exit(f"Goedkeurder ontbreekt in {item['file']}")
        versie_sel = f"(SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = {q(c['id'])} AND versie = {q(v['number'])})"
        regels += [
            f"-- {c['id']} – {c['title']}",
            f"INSERT INTO hoofdstuk (id, nummer) VALUES ({q(c['id'])}, {int(c['number'])});",
            "INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)",
            f"  VALUES ({q(c['id'])}, {q(v['number'])}, 'concept', {q(c['title'])}, {q(c['description'])}, {q(c['heading_original'])}, "
            f"{datum(v['date'])}, {q(v['author'])}, TRUE, {q(v.get('note'))});",
        ]
        for s in data["sections"]:
            controle = hashlib.sha256(s["body"].encode("utf-8")).hexdigest()[:16]
            if controle != s["checksum"]:
                sys.exit(f"Controlegetal klopt niet voor {s['id']}")
            regels.append(
                "INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ("
                f"{versie_sel}, {q(s['id'])}, {int(s['order'])}, {q(s['kind'])}, {q(s['number'])}, {q(s['title'])}, "
                f"{q(s['heading_original'])}, {q(s['body'])}, {q(json.dumps(s['sources'], ensure_ascii=False))}, "
                f"{datum(s['review']['date'])}, {int(s['review']['term_months'])}, {q(controle)});"
            )
            aantal_par += 1
        logtekst = (f"Basisversie {v['number']} geïmporteerd, {len(data['sections'])} paragrafen, "
                    f"goedgekeurd door {v['approved_by']}")
        regels += [
            f"UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = {q(v['approved_by'])}, goedgekeurd_op = {datum(v['date'])}",
            f"  WHERE hoofdstuk_id = {q(c['id'])} AND versie = {q(v['number'])};",
            "INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ("
            f"'systeem', 'import_basisversie', {q(c['id'])}, {q(logtekst)});",
            "",
        ]
    UIT.write_text("\n".join(regels), encoding="utf-8")
    print(f"{UIT.relative_to(ROOT)}: {len(manifest['chapters'])} hoofdstukken, {aantal_par} paragrafen")


if __name__ == "__main__":
    main()
