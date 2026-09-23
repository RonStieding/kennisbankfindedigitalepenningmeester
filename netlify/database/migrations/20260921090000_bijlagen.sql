-- Kennisbank Fin – bijlagen (downloads, templates, stappenplannen, links)
-- Bijlagen volgen dezelfde goedkeuring als tekst: eerst een voorstel, dan beoordeling door de andere redacteur.
-- Nooit wijzigen nadat deze migratie is uitgevoerd; aanpassingen via een nieuwe migratie.

-- Goedgekeurde bijlagen. Een wijziging maakt een nieuwe regel; de oude regel krijgt de status 'vervallen'
-- en blijft bewaard. Zo is altijd terug te zien welke bijlage wanneer gold.
CREATE TABLE bijlage (
  id               SERIAL PRIMARY KEY,
  bijlage_id       TEXT NOT NULL,                  -- vast ID, bijvoorbeeld 'H02-B01'
  hoofdstuk_id     TEXT NOT NULL REFERENCES hoofdstuk(id),
  soort            TEXT NOT NULL CHECK (soort IN ('download', 'template', 'stappenplan', 'link')),
  titel            TEXT NOT NULL,
  omschrijving     TEXT NOT NULL,
  datum            DATE NOT NULL,
  url              TEXT,                           -- bij een link
  bestand_sleutel  TEXT,                           -- bij een bestand: sleutel in Netlify Blobs
  bestandsnaam     TEXT,
  bestand_mime     TEXT,
  bestand_grootte  INTEGER,
  status           TEXT NOT NULL CHECK (status IN ('actief', 'vervallen')),
  voorstel_id      INTEGER NOT NULL REFERENCES voorstel(id),
  auteur           TEXT NOT NULL,
  goedgekeurd_door TEXT NOT NULL,
  goedgekeurd_op   DATE NOT NULL,
  vervangt_id      INTEGER REFERENCES bijlage(id),
  aangemaakt_op    TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (goedgekeurd_door <> auteur),
  CHECK ((soort = 'link' AND url IS NOT NULL) OR (soort <> 'link' AND bestand_sleutel IS NOT NULL))
);

CREATE INDEX bijlage_hoofdstuk_idx ON bijlage (hoofdstuk_id, status);
-- Per bijlage-ID is er hooguit één actieve regel.
CREATE UNIQUE INDEX bijlage_een_actief ON bijlage (bijlage_id) WHERE status = 'actief';

-- Een bijlage wordt nooit verwijderd of inhoudelijk aangepast. Alleen actief → vervallen mag.
CREATE FUNCTION bescherm_bijlage() RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    RAISE EXCEPTION 'Bijlagen worden nooit verwijderd. Dien een voorstel in om een bijlage te laten vervallen.';
  END IF;
  IF OLD.status <> 'actief' OR NEW.status <> 'vervallen'
     OR NEW.bijlage_id IS DISTINCT FROM OLD.bijlage_id
     OR NEW.hoofdstuk_id IS DISTINCT FROM OLD.hoofdstuk_id
     OR NEW.soort IS DISTINCT FROM OLD.soort
     OR NEW.titel IS DISTINCT FROM OLD.titel
     OR NEW.omschrijving IS DISTINCT FROM OLD.omschrijving
     OR NEW.datum IS DISTINCT FROM OLD.datum
     OR NEW.url IS DISTINCT FROM OLD.url
     OR NEW.bestand_sleutel IS DISTINCT FROM OLD.bestand_sleutel
     OR NEW.voorstel_id IS DISTINCT FROM OLD.voorstel_id
     OR NEW.goedgekeurd_door IS DISTINCT FROM OLD.goedgekeurd_door THEN
    RAISE EXCEPTION 'Een goedgekeurde bijlage kan niet worden aangepast. Dien een voorstel in.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bijlage_bescherming
  BEFORE UPDATE OR DELETE ON bijlage
  FOR EACH ROW EXECUTE FUNCTION bescherm_bijlage();

-- Voorstellen uitbreiden met drie soorten voor bijlagen.
ALTER TABLE voorstel DROP CONSTRAINT voorstel_soort_check;
ALTER TABLE voorstel ADD CONSTRAINT voorstel_soort_check CHECK (soort IN (
  'wijzigen', 'toevoegen', 'verwijderen', 'nieuw_hoofdstuk',
  'bijlage_toevoegen', 'bijlage_wijzigen', 'bijlage_verwijderen'));

ALTER TABLE voorstel ADD COLUMN bijlage_id TEXT;
ALTER TABLE voorstel ADD COLUMN basis_bijlage_rij INTEGER REFERENCES bijlage(id);
ALTER TABLE voorstel ADD COLUMN bijlage_soort TEXT CHECK (bijlage_soort IS NULL OR bijlage_soort IN ('download', 'template', 'stappenplan', 'link'));
ALTER TABLE voorstel ADD COLUMN bijlage_titel TEXT;
ALTER TABLE voorstel ADD COLUMN bijlage_omschrijving TEXT;
ALTER TABLE voorstel ADD COLUMN bijlage_datum DATE;
ALTER TABLE voorstel ADD COLUMN bijlage_url TEXT;
ALTER TABLE voorstel ADD COLUMN bestand_sleutel TEXT;
ALTER TABLE voorstel ADD COLUMN bestandsnaam TEXT;
ALTER TABLE voorstel ADD COLUMN bestand_mime TEXT;
ALTER TABLE voorstel ADD COLUMN bestand_grootte INTEGER;

ALTER TABLE voorstel ADD CONSTRAINT voorstel_bijlage_velden CHECK (
  soort NOT IN ('bijlage_toevoegen', 'bijlage_wijzigen')
  OR (hoofdstuk_id IS NOT NULL AND bijlage_soort IS NOT NULL AND bijlage_titel IS NOT NULL
      AND bijlage_omschrijving IS NOT NULL AND bijlage_datum IS NOT NULL
      AND ((bijlage_soort = 'link' AND bijlage_url IS NOT NULL) OR (bijlage_soort <> 'link' AND bestand_sleutel IS NOT NULL))));
ALTER TABLE voorstel ADD CONSTRAINT voorstel_bijlage_basis CHECK (
  soort NOT IN ('bijlage_wijzigen', 'bijlage_verwijderen') OR (bijlage_id IS NOT NULL AND basis_bijlage_rij IS NOT NULL));
