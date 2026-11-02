# Implementatieplan: kennisbankbijlagen beschikbaar maken via Fin

Herziene versie, 2 november 2026. Uitgangspunt: **elke goedgekeurde bijlage is via de chatbot beschikbaar.** Er is geen aparte vrijgave per bijlage. De bestaande goedkeuring door de tweede redacteur is de enige poort.

## Doel

Zorg dat Fin templates, checklists en andere bijlagen uit de FinSport-kennisbank betrouwbaar kan vinden en als download kan delen.

De kennisbank blijft de centrale plek waar de klant documenten uploadt, vervangt en beheert.

## Vastgestelde situatie

Er zijn twee projecten:

- Chatbot: `Smooth-chat-scroll`, met een Node.js/Express-backend.
- Kennisbankwebsite: `https://kennisbank.finsport.nl`.
- Geconfigureerde synchronisatiebron: `https://kennisbankfindedigitalepenningmeester.netlify.app`.

De synchronisatie werkt:

- Bij de controle op 2 november 2026 was de actieve snapshot van de productiechatbot gelijk aan de actuele website-export.
- De backend controleert bij opstarten en daarna iedere zes uur, plus maximaal vijf minuten spreiding.
- De live-status meldde een actieve timer en geen synchronisatiefouten.

De bijlagen komen mee in de export, maar hebben momenteel:

    {
      "external": false,
      "access": "editor_session_required",
      "url": "/api/bestand?sleutel=bestanden/…"
    }

Hun downloadadressen vereisen een redactielogin. Zonder sessie geven ze HTTP 401.

Daarnaast heeft de chatbotverwerking twee beperkingen:

1. `formatAttachment()` in `backend/knowledge/kennisbank/compile.js` geeft alleen bij externe HTTPS-links een URL door. Bij uploads blijven alleen titel en bestandsnaam over. De omschrijving wordt niet meegenomen.
2. `topicLine()` neemt geen bijlagetitels of omschrijvingen mee in de classifier. Daardoor kan een vraag naar een specifieke template het verkeerde hoofdstuk selecteren.

### Hoe de kennisbank nu in elkaar zit

| Onderdeel | Plek | Wat je moet weten |
|---|---|---|
| Toegangspoort voor de hele site | `netlify/edge-functions/wachtwoord.js` | Draait op `/*`, vóór elke Function. Zonder sessiecookie krijgt elk `/api/`-pad een 401. Alleen de paden in `AGENT_PATHS` (`netlify/lib/agent-access.mjs`) zijn vrijgesteld. |
| Bijlagetabel | `netlify/database/migrations/20260921090000_bijlagen.sql` | Elke wijziging is een nieuwe rij met hetzelfde `bijlage_id`; de oude rij wordt `vervallen`. Per `bijlage_id` is er hooguit één actieve rij. Alleen goedgekeurde bijlagen staan in deze tabel; concepten en voorstellen staan in `voorstel`. |
| Beveiligde download | `netlify/functions/bestand.mjs` | Zoekt de sleutel op in `bijlage` of `voorstel`, leest het bestand uit Netlify Blobs en stuurt het met `Content-Disposition: attachment` en `Cache-Control: private, no-store`. |
| Opslag | `netlify/lib/bestanden.mjs` | Netlify Blobs, store `bijlagen`. Geen ondertekende of tijdelijke URL's beschikbaar. |
| Agentexport | `netlify/lib/agent-export.mjs` | Bijlagen zitten in de `content_hash` van het hoofdstuk en dus in de `snapshot_id`. Alle URL's zijn relatief. De export eist `https:` bij links en gooit anders een fout. |
| Tests | `tests/*.test.mjs` | Draaien op een echte Postgres (pglite) met alle migraties. |

## Gewenste werking

1. Een redacteur uploadt een document naar de kennisbank als bijlagevoorstel.
2. De andere redacteur keurt het goed. Vanaf dat moment is het document publiek downloadbaar via een vaste link.
3. De website-export bevat voor elke goedgekeurde bestandsbijlage die link.
4. De chatbot synchroniseert deze metadata.
5. Fin herkent vragen naar het document en geeft de link.
6. De gebruiker opent het document zonder login.

Concepten, ingediende maar nog niet goedgekeurde voorstellen, afgewezen voorstellen en vervallen bijlagerevisies blijven beschermd.

## Buiten scope

- Automatisch uitlezen van Word-, Excel- en PDF-inhoud.
- Een nieuwe documentopslag aan chatbotzijde.
- Een aparte vrijgave per bijlage. Goedkeuren is publiceren.
- Een algemene herbouw van synchronisatie of kennisbankrouting.
- Tijdelijke of ondertekende opslaglinks. Netlify Blobs biedt die niet; de kennisbank levert het bestand zelf uit.

Fin krijgt metadata en links. Hij mag niet doen alsof hij de volledige documentinhoud heeft gelezen.

## Ontwerpkeuzes

1. **Goedkeuren is publiceren.** Geen vlag, geen extra voorstel, geen databasemigratie. De tabel `bijlage` bevat per definitie alleen goedgekeurde bijlagen; de publieke route leest uitsluitend uit die tabel.
2. **Vaste link per bijlage-ID.** De route is `/api/publiek/bijlage/H03-B02`. Het bijlage-ID is al openbaar in de export en de index, dus een onvoorspelbaar token voegt niets toe. De route levert altijd de actuele actieve revisie. Na vervanging werkt dezelfde link en levert hij het nieuwe bestand; de oude revisie is nooit meer bereikbaar.
3. **Relatieve URL's in de export.** De chatbot plakt er de geconfigureerde publieke basis-URL (`https://kennisbank.finsport.nl`) voor. Een absolute URL zou de snapshot afhankelijk maken van de host waarop je hem opvraagt.
4. **Geen caching.** De publieke route stuurt `Cache-Control: private, no-store`. Intrekken werkt direct, ook achter het CDN.
5. **Chatbot eerst uitrollen, platform daarna.** Zie stap 6.
6. **Bij de uitrol worden alle bestaande goedgekeurde bijlagen in één keer publiek.** Dat is de bedoeling, maar Ron en Paul moeten het weten voordat PR B wordt gemerged, zodat ze eerst eventuele bijlagen kunnen laten vervallen die niet publiek mogen zijn.

## 1. Workflow en formulier

Er verandert niets aan de goedkeuringsprocedure. Wel twee kleine aanpassingen:

- **Maak duidelijk dat goedkeuren publiceren is.** Zet bij het bijlagevoorstel in de beoordeelweergave (`public/js/voorstellen.js`) en in het bijlageformulier (`public/js/bijlageformulier.js`) een vaste regel: *Na goedkeuring kan iedereen dit bestand downloaden via Fin en via een vaste link, zonder inloggen.*
- **Eis `https:` voor linkbijlagen.** Nu laten formulier en server ook `http:` toe, terwijl de export daar op stukloopt en dan voor álle bijlagen uitvalt. Pas de controle aan in `bijlageInvoer` in `netlify/lib/voorstellen.mjs` en in het formulier.

Werk de README bij: bestandsbijlagen zijn na goedkeuring zonder wachtwoord bereikbaar via de publieke route. De rest van de site blijft achter het wachtwoord.

## 2. Publieke downloadroute

Nieuwe Function, bijvoorbeeld `netlify/functions/publiek-bestand.mjs`:

    GET /api/publiek/bijlage/:id

Voeg het padprefix toe aan een lijst in `netlify/lib/agent-access.mjs` (dat bestand gebruikt alleen Web APIs en wordt al door de Edge Function geïmporteerd) en laat `netlify/edge-functions/wachtwoord.js` verzoeken naar dat prefix door zonder sessie. Alleen `GET`; andere methoden krijgen 405.

Controle bij ieder verzoek, in één query:

- Het ID voldoet aan `^H\d{2}-B\d{2,}$` (na `toUpperCase`).
- Er is een rij in `bijlage` met dit `bijlage_id`, `status = 'actief'`, `soort <> 'link'` en een `bestand_sleutel`.
- Elke andere uitkomst geeft dezelfde 404.

Uitlevering:

- Lees het bestand met `haalBestand` uit `netlify/lib/bestanden.mjs`.
- Controleer dat de bytegrootte gelijk is aan `bestand_grootte`.
- Headers zoals in `bestand.mjs`: `Content-Type` uit de rij, `Content-Disposition: attachment` met veilige bestandsnaam, `X-Content-Type-Options: nosniff`, `Cache-Control: private, no-store`, `X-Robots-Tag: noindex, nofollow`.

Wat de route nooit doet:

- Een opslagsleutel of bestandspad uit het verzoek accepteren.
- Bestanden uit `voorstel` leveren. Daar staan de concepten en nog niet goedgekeurde uploads.
- Linkbijlagen doorsturen; die staan al als externe URL in de export.

De bestaande route `/api/bestand` blijft bestaan voor redacteuren, onder andere om een bestand bij een voorstel vooraf te bekijken.

Controleer vóór de bouw dat het Netlify-project geen Visitor Access of sitewachtwoord op platformniveau heeft. De agentroutes werken nu via token, wat erop wijst dat dit al in orde is.

## 3. Agentexport uitbreiden

In `netlify/lib/agent-export.mjs`, voor elke bestandsbijlage (niet voor links):

    "external": false,
    "access": "public",
    "public_url": "/api/publiek/bijlage/H03-B02"

Laat `url` (de redactieroute) staan voor redacteurstooling. Voor linkbijlagen verandert niets.

Gevolgen:

- Omdat `access` verandert van `editor_session_required` naar `public`, verandert bij de uitrol de hash van elk hoofdstuk met bestandsbijlagen. Dat geeft eenmalig een volledige hersynchronisatie. Dat is acceptabel en gebeurt vanzelf.
- Daarna verandert de snapshot alleen nog bij inhoudelijke wijzigingen, want de link is stabiel en relatief.
- `schema_version` blijft 1. De toevoeging is achterwaarts compatibel zolang de chatbotvalidator onbekende velden toestaat.

Werk `docs/agent-api.md` bij: beschrijf `access: "public"` en `public_url` als relatief pad waar de afnemer zijn publieke basis-URL voor zet.

Werk `tools/check-agent-export.mjs` bij: haal elke `public_url` uit de export zonder token op en verwacht 200 met `Content-Disposition: attachment`; haal `/api/publiek/bijlage/H99-B99` op en verwacht 404.

## 4. Chatbotverwerking aanpassen

### Relevante bestanden

    backend/knowledge/kennisbank/compile.js
    backend/knowledge/kennisbank/validate.js
    backend/knowledge/kennisbank/provider.js
    backend/config/knowledgeSources.json
    backend/ai-config/prompts/fin-ma-001/classifier_template.md
    backend/tests/knowledge/

### Configuratie

Voeg per kennisbankbron een publieke basis-URL toe in `knowledgeSources.json`:

    "publicBaseUrl": "https://kennisbank.finsport.nl"

De synchronisatie-URL (netlify.app) en de publieke basis-URL zijn bewust twee instellingen.

### Validatie (`validate.js`)

- Sta `access: "public"` en `public_url` toe. Dit moet live staan vóórdat het platform ze gaat sturen.
- Een bijlage is deelbaar als `access === "public"` én `public_url` aanwezig is én `external === false`.
- `public_url` moet beginnen met `/api/publiek/bijlage/` en mag geen `..`, query of fragment bevatten. Anders: verwerken als niet-deelbaar en een waarschuwing loggen zonder de synchronisatie te laten mislukken.
- Bouw de link als `publicBaseUrl + public_url`. Neem nooit `url` (de redactieroute) op in de prompt.

### Bijlagen in de antwoordcontext (`compile.js`)

Pas `formatAttachment()` aan zodat Fin ontvangt: titel, omschrijving indien aanwezig, bestandsnaam of -type, en de downloadlink. Externe HTTPS-links blijven zoals nu.

Voorbeeld:

    Bijlagen:
    - Template meerjarenbegroting met eigen accommodatie
      Omschrijving: Sjabloon voor een meerjarenbegroting.
      Bestand: meerjarenbegroting.xlsx
      Download: https://kennisbank.finsport.nl/api/publiek/bijlage/H03-B02

Zolang het platform nog de oude export stuurt (zonder `public_url`), blijft de huidige weergave gelden: titel en bestandsnaam zonder link.

### Vindbaarheid verbeteren (`topicLine()`)

- Neem bijlagetitels en ingekorte omschrijvingen mee in de classifierinformatie.
- Houd het compact, voorkom dubbele trefwoorden, geen URL's.

Pas zo nodig de classifierinstructie aan:

- Vragen naar templates, sjablonen, checklists en downloads kunnen kennisbankvragen zijn.
- Selecteer het hoofdstuk waarin de relevante bijlage staat.
- Bij algemene vragen zoals "Welke templates heb je?" mag Fin om een onderwerp vragen.
- Laat Fin geen volledig overzicht claimen op basis van één geselecteerd hoofdstuk.
- Laat Fin nooit zelf een downloadadres samenstellen of raden.

## 5. Tests

### Kennisbankplatform (`tests/`)

- Een goedgekeurde bestandsbijlage is zonder sessie downloadbaar via de publieke route, met de juiste headers.
- Een bestand dat alleen bij een voorstel hoort (concept, ter validatie, afgewezen) is niet via de publieke route bereikbaar.
- Een vervallen revisie zonder actieve opvolger geeft 404.
- Na vervanging levert hetzelfde ID het nieuwe bestand; de oude bestandsrevisie is niet meer bereikbaar.
- Een linkbijlage-ID, een onbekend ID en een misvormd ID geven 404; POST geeft 405.
- De export bevat `access: "public"` en een relatieve `public_url` bij elke bestandsbijlage en niet bij links.
- De Edge-vrijstelling laat alleen het publieke padprefix door; `/api/bestand` blijft achter de login.
- Een linkbijlage met `http://` wordt door de workflow geweigerd.
- De bestaande twaalf tests blijven slagen (fixtures en verwachte hashes bijwerken).

### Chatbot (`backend/tests/knowledge/`)

- Titel, omschrijving en link worden overgenomen en met `publicBaseUrl` samengesteld.
- Een export zonder de nieuwe velden (huidige productie) wordt ongewijzigd verwerkt.
- Een `public_url` met afwijkende vorm levert geen link op.
- De redactieroute `/api/bestand` verschijnt nooit in de prompt.
- Bijlagen zonder omschrijving blijven correct verwerkt.
- Bijlagetitels en omschrijvingen staan in de classifierinformatie.
- De bestaande 37 kennisbanktests blijven slagen.

### Volledige keten

Gebruik een onschuldig testdocument:

    Upload als bijlagevoorstel
    → goedkeuren door de andere redacteur
    → export (controleer met `npm run check:agent`)
    → synchronisatie
    → juiste hoofdstukselectie
    → antwoord met link
    → download zonder login
    → bijlage laten vervallen → download geeft 404

Voorbeeldvragen:

- "Heb je een template voor een meerjarenbegroting?"
- "Kan ik de checklist voor een nieuwe penningmeester downloaden?"
- "Heb je een sponsorovereenkomst?"

Test downloads in een incognitovenster of met een HTTP-client zonder cookies.

## 6. Uitrol en overdracht aan Ron

Twee PR's. Volgorde: chatbot eerst, platform daarna.

### PR A: chatbot (eerst live)

- Tolerante validatie voor de nieuwe exportvelden.
- Configuratie `publicBaseUrl`.
- Verwerking van publieke downloadlinks en bijlageomschrijvingen.
- Verbeterde classifierinformatie.
- Regressietests en documentatie.

Werkt met de huidige export én met de nieuwe. Pas als dit live staat, mag het platform volgen; andersom breekt de synchronisatie als de validator strikt is.

### PR B: kennisbankplatform

- Edge-vrijstelling en publieke downloadroute.
- Exportaanpassing, `docs/agent-api.md`, `tools/check-agent-export.mjs`.
- https-eis voor links en de toelichting bij goedkeuren.
- Tests en README.

Geen migratie, geen nieuwe environment variables.

Ron moet deze PR mergen. Vermeld duidelijk:

- Dat **alle bestaande goedgekeurde bestandsbijlagen direct publiek worden** bij deze deploy. Vraag Ron en Paul vooraf te controleren of daar iets tussen zit dat eerst moet vervallen.
- Dat goedkeuren van een bijlage vanaf nu publiceren betekent.
- Hoe intrekken werkt: voorstel "laten vervallen", goedkeuren door de ander, link werkt direct niet meer.
- Dat een vervangen bijlage dezelfde link houdt en het nieuwe bestand levert.
- Welke tests zijn uitgevoerd, inclusief de ketentest.

### Controle na deployment

1. Draai `npm run check:agent` tegen productie.
2. Ververs de chatbotkennisbank en controleer de actieve snapshot en synchronisatiefouten. Verwacht eenmalig een volledige hersynchronisatie.
3. Stel een testvraag aan Fin en open de link zonder login.
4. Laat een testbijlage vervallen en controleer dat de download 404 geeft.
5. Werk de lokale reservekopie bij met `kennisbank:vastleggen`.

## Credentials

In `backend/.env` van de chatbot: `KNOWLEDGE_ADMIN_TOKEN` en `KNOWLEDGE_SYNC_TOKEN_FINSPORT`. Aan platformzijde heet het synchronisatietoken `KNOWLEDGE_SYNC_TOKEN` in de Netlify-omgeving. De publieke downloadroute gebruikt geen token.

Nooit loggen, committen of in PR's plaatsen. Het websitewachtwoord is geen vervanging voor deze tokens.

## Acceptatiecriteria

- Fin vindt een goedgekeurde template betrouwbaar en geeft de juiste link.
- Een bezoeker downloadt het bestand zonder login.
- Concepten, niet-goedgekeurde voorstellen en vervallen revisies blijven ontoegankelijk, ook via de publieke route.
- Een vervangen bijlage levert via dezelfde link het nieuwe bestand.
- De klant beheert documenten uitsluitend in de kennisbank; goedkeuren is genoeg.
- Synchronisatie, externe links en andere mascots blijven werken.
- Beide PR's bevatten testresultaten en uitrolinstructies.
