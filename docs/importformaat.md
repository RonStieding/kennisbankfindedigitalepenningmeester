# Importformaat kennisbank (`fin-kennisbank/import@1`)

Eén JSON-bestand per hoofdstuk in `import/`, plus `manifest.json`. Deze map wordt niet gepubliceerd.

Vanaf bouwstap 2 is de database leidend. `tools/maak_migratie.py` heeft van deze bestanden de datamigratie `netlify/database/migrations/20260919120100_basisversie_1_0.sql` gemaakt, die Netlify één keer uitvoert bij de eerste deploy. De bestanden zelf blijven bewaard als back-up van basisversie 1.0 en worden niet meer bewerkt.

```json
{
  "schema": "fin-kennisbank/import@1",
  "chapter": { "id": "H04", "number": 4, "title": "…", "heading_original": "Hoofdstuk 4 — …", "description": "eerste zin van de inleiding" },
  "version": { "number": "1.0", "status": "goedgekeurd", "date": "2026-09-19", "basisversie": true,
               "author": "Import uit …", "approved_by": "Paul Baans", "note": "…" },
  "sections": [
    { "id": "H04-P03", "order": 3, "kind": "vraag", "number": "3", "title": "…", "heading_original": "3. …",
      "body": "letterlijke tekst in Markdown", "format": "markdown",
      "sources": [{ "label": "…", "url": "https://…" }],
      "review": { "date": "2027-09-19", "term_months": 12 },
      "checksum": "eerste 16 tekens sha256 van body" }
  ],
  "attachments": []
}
```

- `kind`: `inleiding`, `vraag`, `checklist`, `overzicht`, `voorbeeld` of `kern`. Dit bepaalt alleen de weergave.
- `checksum`: hiermee controleert de import dat de tekst onderweg niet is veranderd.
- `attachments` (later): `{ "type": "download|template|stappenplan|link", "title", "description", "date", "url" }`.

Opnieuw genereren vanuit de Word-tekstexport:

```
python3 tools/convert.py <word-tekstexport.md> import
python3 tools/maak_migratie.py   # alleen vóór de eerste deploy van de database
```

Het script stopt met een fout als een kop uit de inhoudsopgave niet in de tekst wordt gevonden.
