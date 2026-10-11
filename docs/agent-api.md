# Agent API voor de Fin kennisbank

Deze API maakt de goedgekeurde kennisbank uitleesbaar voor een latere synchronisatie met Fin. Er draait in dit project geen wekelijkse agent. De klant blijft hoofdstukken en bijlagen via voorstellen op de website beheren.

De bestaande browserindex en llms-bestanden blijven achter de browserlogin. De synchronisatie gebruikt de twee hieronder beschreven routes. De nieuwe API heeft geen databasemigratie nodig.

## Configuratie en toegang

Maak in Netlify een geheim `KNOWLEDGE_SYNC_TOKEN` aan, beschikbaar voor **Functions én Edge Functions**. Gebruik minimaal 32 willekeurige bytes, gecodeerd als hex of base64url (32–256 tekens uit `A-Z`, `a-z`, `0-9`, `_`, `-`). Gebruik een ander geheim dan `SITE_PASSWORD`. Geef previews een eigen token. Stel het token veilig in op de toekomstige afnemer; zet het niet in Git, een browser, querystring, screenshots of logboeken. Deploy opnieuw nadat de Netlify-configuratie is gewijzigd.

Elke aanvraag stuurt `Authorization: Bearer <token>`. Er is bewust geen CORS-toegang voor browserclients. Een cookie of redacteurnaam geeft geen agenttoegang. Het token werkt alleen voor GET op `/api/agent/manifest` en `/api/agent/export`; alle andere websitefuncties behouden hun bestaande browserbeveiliging. Beide lagen controleren het token onafhankelijk. Ontbrekende of te korte tokenconfiguratie geeft 503. Fout of ontbrekend token geeft 401; een geldig token met een andere HTTP-methode geeft 405.

De servicetoegang staat los van het browserwachtwoord: het intrekken van `SITE_PASSWORD` trekt het servicetoken niet in. Verwijder of roteer `KNOWLEDGE_SYNC_TOKEN` om agenttoegang in te trekken. Er is één actief servicetoken per deploycontext; wijzig beide uiteinden bij rotatie.

**Netlify Visitor Access blijft een afzonderlijke laag.** Een private Netlify-site kan een aanvraag al vóór onze Edge Function tegenhouden. Test vanaf een client zonder browsercookies. Als platformlogin blokkeert, moet de beheerder ondersteunde machine-toegang in Netlify regelen of een apart beveiligd exportadres laten inrichten. Maak de website niet publiek om deze API te laten werken. Deze repository configureert geen Netlify-teamrechten of platformloginuitzonderingen.

De function heeft expliciete `config.path`-routes. Netlify documenteert dat zo’n function niet tevens onder `/.netlify/functions/<naam>` bereikbaar is. De handler valideert het pad bovendien zelf. Zie [Netlify Functions routing](https://docs.netlify.com/build/functions/configuration/#routing).

## Leesprotocol

1. Haal `/api/agent/manifest` op. Bewaar de ETag en de bijbehorende lokaal gevalideerde snapshot.
2. Stuur bij volgende controles `If-None-Match: <etag>` mee. Bij 304 is die snapshot ongewijzigd. Bewaar lokale reviewdatums voor actualiteitssignalering, ook zonder wijzigingen.
3. Bij een nieuwe manifestversie: haal `/api/agent/export?snapshot_id=<snapshot_id>` op. URL-encode de querywaarde.
4. Bij 409 is intussen iets goedgekeurd: begin opnieuw bij de index. Beperk retries. De server bewaart geen exporthistorie voor deze route.
5. Controleer schema, bron-ID, aantallen, paragraaf-ID’s en de hash van de volledige export. Verwerk pas daarna verschillen en verwijderingen.

Als een client een 304 ontvangt zonder de daarbij behorende lokale snapshot te hebben, opnieuw ophalen zonder `If-None-Match`. Vergelijk nooit alleen `version.date` of `approved_at`: meerdere goedkeuringen kunnen op dezelfde dag plaatsvinden.

Een lege bron, ontbrekend goedgekeurd bestand of beschadigde brondata geeft een fout, nooit een geldige lege export. Een fout is dus geen opdracht om botkennis te verwijderen. De API kan wel een individuele verwijdering weergeven binnen een verder complete snapshot. Volledig leegmaken van alle hoofdstukken is bewust niet ondersteund als synchronisatieactie.

## Manifestcontract versie 1

Velden bovenaan:

| Veld | Betekenis |
|---|---|
| `schema_version` | Getal `1`; bij een onbekende versie stoppen |
| `source_id` | Vaste waarde `fin-kennisbank` |
| `language` | Brontaal `nl` |
| `complete` | `true`, uitsluitend na succesvolle opbouw van de volledige snapshot |
| `snapshot_id` | `sha256:` gevolgd door 64 hextekens; identiteit van de volledige export |
| `chapter_count` | Aantal elementen in `chapters` |
| `chapters` | Alle actuele goedgekeurde hoofdstukken, in hoofdstukvolgorde |

Elk manifesthoofdstuk bevat `id`, `number`, `title`, `version_id`, `version`, `content_hash`, `metadata_hash`, `section_count` en `attachment_count`. Geen paragraaftekst in de index. IDs worden niet hernummerd of opnieuw gebruikt.

Er staat geen klokafhankelijke `generated_on` in de snapshot. Een nieuwe dag levert zonder bronwijziging geen nieuwe hash op. De ETag verschilt per representatie: een manifest-ETag mag niet worden gebruikt als export-ETag. Authenticatie wordt vóór 304 gecontroleerd. Antwoorden hebben `Cache-Control: private, no-store` en `Vary: Authorization`; de afnemer bewaart zijn eigen ETag/snapshot, geen publieke CDN-cache.

## Exportcontract versie 1

De export heeft dezelfde bovenste velden en dezelfde `snapshot_id`, maar volledige hoofdstukken:

- `id`, `number`, `title`, `description`, `url` (relatieve browserlink).
- `version`: `id`, `number`, `date`, `approved_by`, `approved_at`, `basisversie`.
- `content_hash`, `metadata_hash`, `section_count`, `attachment_count`.
- `sections`: paragrafen in bronvolgorde.
- `attachments`: actieve, goedgekeurde bijlagereferenties.

Een paragraaf bevat `id`, `order`, `kind`, `number` (string of null), `title`, `body`, `format: markdown`, `sources` (label/url), `review` (date/term_months), `url`, `content_hash` en `metadata_hash`. De tekst wordt letterlijk uit de database doorgegeven. Er worden geen samenvattingen of LLM-bewerkingen uitgevoerd.

Een bijlage bevat `id`, `revision_id`, `type`, `title`, `description`, `date`, `approved_by`, `approved_at`, `external`, `access`, `url` en `file`. Voor bestanden bevat `file` de velden `name`, `mime`, `size` en `content_hash`. Voor externe links is `file` null en `access` gelijk aan `external`: dit zegt niets over de toegankelijkheid van de externe site. Die wordt niet opgehaald.

Bij opgeslagen bestanden is `access` gelijk aan `editor_session_required`. Het servicetoken geeft geen downloadrecht op `/api/bestand`, dat ook beoordelingsbestanden kan bedienen. Dit voorkomt dat de agent onbedoeld conceptbestanden kan opvragen. Binaire bestandsinhoud wordt niet geëxporteerd of uitgelezen als kennis. Gebruik de link alleen voor interne herkomstcontrole; presenteer die niet als publieke download aan chatgebruikers. Een afzonderlijke agentdownloadfunctie kan later worden toegevoegd met eigen controle op gepubliceerde revisies.

Datums zijn `YYYY-MM-DD`. Goedkeuringsdatum is geen bewijs dat alle wet- en regelgeving op die datum extern gecontroleerd is. Reviewdatum is een herbeoordelingssignaal, geen automatische inhoudelijke afkeuring.

## Hashes en consistente snapshots

`snapshot_id` is SHA-256 van de canonieke JSON van de volledige export **zonder het veld `snapshot_id` zelf**. Canoniek betekent: objectkeys recursief lexicografisch sorteren, arrayvolgorde behouden, primitieve waarden via `JSON.stringify`, geen witruimte, UTF-8. Zie `canoniek()` en `hash()` in `netlify/lib/agent-export.mjs` voor de uitvoerbare referentie.

Paragraaf-contenthash: ID, volgorde, soort, nummer, titel, letterlijke tekst, formaat en bronnen. Paragraaf-metadatahash: reviewdatum en termijn. Hoofdstuk-contenthash: hoofdstukidentiteit, nummer, titel, omschrijving, geordende paragraaf-contenthashes en volledige bijlagereferenties. Hoofdstuk-metadatahash: versiegegevens en reviewmetadata per paragraaf. Een gewijzigde bijlagegoedkeuring telt conservatief als een inhoudelijke hoofdstukwijziging. Gewijzigde tekst, titels, bronnen, volgorde, reviewdatums en bijlagen verdwijnen dus niet achter de oude body-only checksum.

Alle drie SQL-queries gebruiken één verbinding met `REPEATABLE READ READ ONLY`. Een gelijktijdige goedkeuring kan de export daardoor niet half oud en half nieuw maken. Na deze korte transactie worden bestandsmetadata/hashes gelezen. De app schrijft bestanden onder nieuwe UUID-sleutels; ze worden nooit inhoudelijk overschreven. Alleen actuele goedgekeurde hoofdstukken en actieve bijlagen tellen mee; concepten en voorstelteksten worden niet opgevraagd.

Nieuwe uploads bewaren SHA-256 in Netlify Blob-metadata. Voor oudere uploads zonder hash worden de bytes gecontroleerd, zonder bestaande bestanden of metadata te wijzigen. Een begrensde cache gebruikt bestandssleutel en Blob-ETag; een volgende instance kan deze oude bestanden opnieuw moeten lezen. Nieuwe uploads hoeven voor de index niet volledig te worden gedownload. Bestandsgrootte en MIME-type moeten overeenkomen met de gepubliceerde databasegegevens. De hashcontrole vertrouwt de door de server geschreven metadata; handmatig overschrijven van blobs buiten de app is niet ondersteund.

De index is klein op het netwerk maar wordt nog wel uit de volledige database-snapshot opgebouwd. Er is geen aparte indexcache of nieuwe databasetabel. Dat houdt de eerste versie eenvoudig en correct. Bij aantoonbaar hoge belasting kan een bij goedkeuring bijgewerkte index worden toegevoegd.

De API weigert antwoorden groter dan 5 MiB met 503; zij kapt tekst nooit stil af. Dit laat marge onder Netlify’s gedocumenteerde buffered-response-limiet. Zie [Netlify Functions limits](https://docs.netlify.com/build/functions/configuration/#default-values).

## Foutantwoorden

Alle agentantwoorden zijn JSON, behalve de lege 304. Bij succes hebben manifest en export een ETag.

| HTTP | `error` | Betekenis |
|---|---|---|
| 304 | geen body | Exact deze representatie is ongewijzigd |
| 400 | `invalid_query` | Onbekende/dubbele parameter of ongeldige snapshot-ID |
| 401 | `unauthorized` | Ontbrekend/verkeerd servicetoken |
| 404 | `not_found` | Handler op niet-toegestaan pad aangeroepen |
| 405 | `method_not_allowed` | Geldig token maar geen GET |
| 409 | `snapshot_changed` | Bron gewijzigd sinds manifest; antwoord bevat actuele snapshot-ID |
| 503 | `agent_access_not_configured` | Token niet correct geconfigureerd |
| 503 | `source_unavailable` | Database/blob onbereikbaar, lege bron of ongeldige/incomplete data |
| 503 | `export_too_large` | Geen volledige veilige respons binnen ingestelde limiet |

Een Netlify-platformblokkade kan een ander antwoord opleveren voordat deze code draait. De afnemer moet redirects en HTML-inlogschermen als fouten behandelen.

## Acceptatie op een Netlify preview

1. Controleer database- en Blob-isolatie van de preview voordat iemand proefinhoud aanmaakt. De bestaande README beschrijft dat Blobs gedeeld kunnen zijn.
2. Zet een apart previewtoken in Functions én Edge Functions; deploy de branch. Behoud de bestaande browserbeveiliging.
3. Stel lokaal `KNOWLEDGE_SYNC_URL` (alleen origin, bijvoorbeeld `https://preview.example`) en `KNOWLEDGE_SYNC_TOKEN` veilig in. Voer `npm run check:agent` uit. Het script volgt geen redirects en print geen broninhoud of tokens. Zonder Netlify-configuratie is dit geen geslaagde livecontrole.
4. De check verifieert 401 zonder token, 200 met token, 304 bij dezelfde ETag, overeenkomst van manifest/export, integriteit van de snapshot, 409 bij verkeerde snapshot-ID, 405 bij POST op export en geen toegang tot voorstellen. Hij wijzigt geen kennisbankinhoud.
5. Maak via de website een proefvoorstel. Controleer dat de snapshot nog gelijk is. Laat de andere redacteur het goedkeuren; controleer daarna de nieuwe snapshot en letterlijke tekst.
6. Test een titel-/reviewdatumwijziging, bijlagewijziging en paragraafverwijdering. Test bijlagen van vóór en na deze wijziging. Trek geen productiegegevens in voor deze test.
7. Roteer het previewtoken; het oude token moet na de configuratie-uitrol 401 geven. Browserlogin moet blijven werken.

`npm test` draait zonder productiecredentials. De tests omvatten authenticatie in Edge en Function, conditionele requests, foutpaden, hashing, legacy-bestandshashes, transactievrijgave, alle echte migraties in PGlite/PostgreSQL en een lokale HTTP-keten. PGlite controleert de SQL en gegevensselectie; Netlify-routing, Deno-bundeling, echte platformauthenticatie en productieconcurrentie moeten bij de preview worden bevestigd.

## Uitrolgrens

Deze branch bouwt voort op `feature/agent-index` (PR 2). Review de gezamenlijke wijziging ten opzichte van `main`, of merge eerst de index-PR en review daarna de aanvullende agent-API. Samenvoegen kan volgens de bestaande projectinrichting een Netlify-deploy starten; controleer daarvoor de daadwerkelijke hostinginstellingen. Er zijn geen nieuwe databasekolommen of gewijzigde migraties.

Het inrichten van de wekelijkse taak, Fin-hoofdstukken en classifier in Smooth-chat-scroll volgt in een aparte opdracht.
