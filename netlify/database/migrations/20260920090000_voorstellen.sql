-- Kennisbank Fin – bouwstap 3: voorstellen en goedkeuring
-- Nooit wijzigen nadat deze migratie is uitgevoerd; aanpassingen via een nieuwe migratie.

CREATE TABLE voorstel (
  id                   SERIAL PRIMARY KEY,
  soort                TEXT NOT NULL CHECK (soort IN ('wijzigen', 'toevoegen', 'verwijderen', 'nieuw_hoofdstuk')),
  status               TEXT NOT NULL CHECK (status IN ('concept', 'ter_validatie', 'goedgekeurd', 'afgewezen', 'ingetrokken')),
  hoofdstuk_id         TEXT REFERENCES hoofdstuk(id),        -- leeg bij een nieuw hoofdstuk
  paragraaf_id         TEXT,                                 -- bij wijzigen en verwijderen
  na_paragraaf_id      TEXT,                                 -- bij toevoegen: nieuwe paragraaf komt hierna
  basis_versie_id      INTEGER REFERENCES hoofdstuk_versie(id),
  basis_controlegetal  TEXT,                                 -- controlegetal van de paragraaf waarop het voorstel is gebaseerd
  basis_titel          TEXT,
  basis_tekst          TEXT,
  nieuw_nummer         TEXT,
  nieuw_titel          TEXT,
  nieuw_tekst          TEXT,
  nieuw_soort          TEXT,
  reviewtermijn_maanden INTEGER CHECK (reviewtermijn_maanden IS NULL OR reviewtermijn_maanden BETWEEN 1 AND 60),
  vaste_reviewdatum    DATE,
  hoofdstuk_titel      TEXT,                                 -- bij nieuw hoofdstuk
  hoofdstuk_omschrijving TEXT,                               -- bij nieuw hoofdstuk
  wat                  TEXT NOT NULL,
  waarom               TEXT NOT NULL,
  bron                 TEXT NOT NULL,
  auteur               TEXT NOT NULL,
  aangemaakt_op        TIMESTAMPTZ NOT NULL DEFAULT now(),
  gewijzigd_op         TIMESTAMPTZ NOT NULL DEFAULT now(),
  ingediend_op         TIMESTAMPTZ,
  beoordelaar          TEXT,
  beoordeeld_op        TIMESTAMPTZ,
  checklist            TEXT,                                 -- JSON met de vijf controlepunten
  reden_afwijzing      TEXT,
  resultaat_versie_id  INTEGER REFERENCES hoofdstuk_versie(id),
  -- vier-ogenprincipe
  CHECK (beoordelaar IS NULL OR beoordelaar <> auteur),
  -- afwijzen alleen met reden
  CHECK (status <> 'afgewezen' OR (reden_afwijzing IS NOT NULL AND length(trim(reden_afwijzing)) > 0)),
  -- goedgekeurd alleen met beoordelaar, checklist en resulterende versie
  CHECK (status <> 'goedgekeurd' OR (beoordelaar IS NOT NULL AND checklist IS NOT NULL AND resultaat_versie_id IS NOT NULL)),
  -- verplichte velden per soort
  CHECK (soort <> 'wijzigen'    OR (hoofdstuk_id IS NOT NULL AND paragraaf_id IS NOT NULL AND nieuw_titel IS NOT NULL AND nieuw_tekst IS NOT NULL)),
  CHECK (soort <> 'toevoegen'   OR (hoofdstuk_id IS NOT NULL AND nieuw_titel IS NOT NULL AND nieuw_tekst IS NOT NULL)),
  CHECK (soort <> 'verwijderen' OR (hoofdstuk_id IS NOT NULL AND paragraaf_id IS NOT NULL)),
  CHECK (soort <> 'nieuw_hoofdstuk' OR (hoofdstuk_titel IS NOT NULL AND hoofdstuk_omschrijving IS NOT NULL AND nieuw_tekst IS NOT NULL))
);

CREATE INDEX voorstel_status_idx ON voorstel (status);
CREATE INDEX voorstel_hoofdstuk_idx ON voorstel (hoofdstuk_id, status);

-- Een afgerond voorstel (goedgekeurd, afgewezen of ingetrokken) ligt vast en kan niet meer
-- worden aangepast of verwijderd. Zo blijft altijd terug te zien wat er is besloten en waarom.
CREATE FUNCTION blokkeer_wijziging_afgerond_voorstel() RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    RAISE EXCEPTION 'Voorstellen worden nooit verwijderd. Trek een voorstel in als het niet meer nodig is.';
  END IF;
  IF OLD.status IN ('goedgekeurd', 'afgewezen', 'ingetrokken') THEN
    RAISE EXCEPTION 'Voorstel % is % en kan niet meer worden aangepast.', OLD.id, OLD.status;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER voorstel_bescherming
  BEFORE UPDATE OR DELETE ON voorstel
  FOR EACH ROW EXECUTE FUNCTION blokkeer_wijziging_afgerond_voorstel();

-- Koppeling van een versie aan het voorstel waaruit zij is ontstaan.
ALTER TABLE hoofdstuk_versie ADD COLUMN voorstel_id INTEGER REFERENCES voorstel(id);
