-- Kennisbank Fin – basisschema (bouwstap 2)
-- Netlify voert deze migratie automatisch uit bij de deploy. Nooit achteraf wijzigen:
-- wijzigingen in het schema gaan altijd via een nieuwe migratie.

CREATE TABLE hoofdstuk (
  id            TEXT PRIMARY KEY,                 -- bijvoorbeeld 'H01'
  nummer        INTEGER NOT NULL UNIQUE,
  aangemaakt_op TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Elke versie van een hoofdstuk is een volledige momentopname.
-- Een oude versie blijft altijd bewaard in de geschiedenis.
CREATE TABLE hoofdstuk_versie (
  id               SERIAL PRIMARY KEY,
  hoofdstuk_id     TEXT NOT NULL REFERENCES hoofdstuk(id),
  versie           TEXT NOT NULL,
  status           TEXT NOT NULL CHECK (status IN ('concept', 'ter_validatie', 'goedgekeurd', 'afgewezen')),
  titel            TEXT NOT NULL,
  omschrijving     TEXT NOT NULL,
  kop_origineel    TEXT,
  versiedatum      DATE NOT NULL,
  auteur           TEXT NOT NULL,
  goedgekeurd_door TEXT,
  goedgekeurd_op   DATE,
  basisversie      BOOLEAN NOT NULL DEFAULT FALSE,
  toelichting      TEXT,
  aangemaakt_op    TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (hoofdstuk_id, versie),
  CHECK (status <> 'goedgekeurd' OR (goedgekeurd_door IS NOT NULL AND goedgekeurd_op IS NOT NULL)),
  -- vier-ogenprincipe: niemand keurt een eigen voorstel goed
  CHECK (goedgekeurd_door IS NULL OR goedgekeurd_door <> auteur)
);

CREATE TABLE paragraaf (
  hoofdstuk_versie_id   INTEGER NOT NULL REFERENCES hoofdstuk_versie(id),
  paragraaf_id          TEXT NOT NULL,             -- bijvoorbeeld 'H04-P03'
  volgorde              INTEGER NOT NULL,
  soort                 TEXT NOT NULL,             -- inleiding, vraag, checklist, overzicht, voorbeeld, kern
  nummer                TEXT,
  titel                 TEXT NOT NULL,
  kop_origineel         TEXT,
  tekst                 TEXT NOT NULL,             -- Markdown, letterlijk
  bronnen               TEXT NOT NULL DEFAULT '[]', -- JSON-lijst met {label, url}
  reviewdatum           DATE NOT NULL,
  reviewtermijn_maanden INTEGER NOT NULL DEFAULT 12,
  controlegetal         TEXT NOT NULL,             -- eerste 16 tekens sha256 van tekst
  PRIMARY KEY (hoofdstuk_versie_id, paragraaf_id),
  UNIQUE (hoofdstuk_versie_id, volgorde)
);

CREATE INDEX paragraaf_id_idx ON paragraaf (paragraaf_id);
CREATE INDEX hoofdstuk_versie_status_idx ON hoofdstuk_versie (hoofdstuk_id, status);

-- Logboek van alle acties (wie deed wat, wanneer).
CREATE TABLE logboek (
  id         SERIAL PRIMARY KEY,
  moment     TIMESTAMPTZ NOT NULL DEFAULT now(),
  gebruiker  TEXT NOT NULL,
  actie      TEXT NOT NULL,
  onderwerp  TEXT,
  details    TEXT
);

-- Regels: goedgekeurde content wordt nooit direct aangepast of verwijderd,
-- en een versie wordt nooit direct als goedgekeurd ingevoegd.
-- Dit wordt in de database zelf afgedwongen, dus ook als code in de toekomst een fout bevat.
CREATE FUNCTION blokkeer_wijziging_goedgekeurde_versie() RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.status = 'goedgekeurd' THEN
      RAISE EXCEPTION 'Een nieuwe versie kan niet direct als goedgekeurd worden vastgelegd. Een versie wordt pas goedgekeurd na validatie.';
    END IF;
    RETURN NEW;
  END IF;
  IF OLD.status IN ('goedgekeurd', 'afgewezen') THEN
    RAISE EXCEPTION 'Versie % van % is % en mag niet worden gewijzigd of verwijderd. Dien een nieuw voorstel in.',
      OLD.versie, OLD.hoofdstuk_id, OLD.status;
  END IF;
  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER hoofdstuk_versie_bescherming
  BEFORE INSERT OR UPDATE OR DELETE ON hoofdstuk_versie
  FOR EACH ROW EXECUTE FUNCTION blokkeer_wijziging_goedgekeurde_versie();

CREATE FUNCTION blokkeer_wijziging_goedgekeurde_paragraaf() RETURNS trigger AS $$
DECLARE
  st TEXT;
  versie_id INTEGER;
  pid TEXT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    versie_id := NEW.hoofdstuk_versie_id;
    pid := NEW.paragraaf_id;
  ELSE
    versie_id := OLD.hoofdstuk_versie_id;
    pid := OLD.paragraaf_id;
  END IF;
  SELECT status INTO st FROM hoofdstuk_versie WHERE id = versie_id;
  IF st IN ('goedgekeurd', 'afgewezen') THEN
    RAISE EXCEPTION 'Paragraaf % hoort bij een % versie en mag niet worden toegevoegd, gewijzigd of verwijderd. Dien een voorstel in.',
      pid, st;
  END IF;
  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER paragraaf_bescherming
  BEFORE INSERT OR UPDATE OR DELETE ON paragraaf
  FOR EACH ROW EXECUTE FUNCTION blokkeer_wijziging_goedgekeurde_paragraaf();

-- Het logboek is alleen aanvullen: regels worden nooit aangepast of verwijderd.
CREATE FUNCTION blokkeer_wijziging_logboek() RETURNS trigger AS $$
BEGIN
  RAISE EXCEPTION 'Het logboek kan niet worden aangepast of verwijderd.';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER logboek_bescherming
  BEFORE UPDATE OR DELETE ON logboek
  FOR EACH ROW EXECUTE FUNCTION blokkeer_wijziging_logboek();
