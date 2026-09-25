# Kennisbank Fin

Kennisbank-website van Fin, de digitale penningmeester van FinSport. Deze website vervangt het Word-document als enige leidende bron.

## Stand: bouwstap 3 en 3b – voorstellen, goedkeuren en bijlagen

**Toegang.** Het Netlify-project staat op **Private**: alleen leden van het Netlify-team (Ron en Paul) kunnen de site openen, na inloggen met hun Netlify-account. Rechtsboven kies je "Ik ben Paul Baans" of "Ik ben Ron Stieding"; die naam komt bij elk voorstel en elke beoordeling te staan.

**Wijzigen gaat altijd via een voorstel.** Goedgekeurde tekst wordt nooit direct aangepast.
- Bij elke paragraaf: *Wijziging voorstellen*, *Paragraaf toevoegen hierna* en *Verwijderen voorstellen*.
- Op de startpagina (of de pagina Voorstellen): *Hoofdstuk toevoegen*.
- Bij een voorstel leg je vast: wat, waarom en bron of onderbouwing. De indiener en de datum worden automatisch vastgelegd.
- Statussen: Concept → Ter validatie → Goedgekeurd of Afgewezen (met reden). De indiener kan een voorstel terugzetten naar concept of intrekken zolang het niet is beoordeeld.

**Beoordelen.** De pagina *Openstaande voorstellen* (teller in de kopbalk) toont wat op jouw beoordeling wacht. De andere redacteur ziet de wijziging als vergelijking (verwijderde tekst doorgestreept, nieuwe tekst gemarkeerd), loopt de checklist door (inhoud, bron, peildatum, geen tegenstrijdigheid, B1-niveau) en kiest Goedkeuren of Afwijzen.

**Na goedkeuring** ontstaat een nieuwe versie van het hoofdstuk (1.0 → 1.1 → …). De oude versie blijft in de versiegeschiedenis; met *Vergelijk met …* zie je wat er veranderde. De reviewdatum van de gewijzigde paragraaf wordt opnieuw gezet: de standaardtermijn (12 maanden, per paragraaf aan te passen) of een vaste datum.

**Regels die de server én de database afdwingen**
- Niemand keurt zijn eigen voorstel goed.
- Goedkeuren kan alleen met alle vijf checklistpunten aangevinkt; afwijzen alleen met een reden.
- Een goedgekeurde versie en een afgerond voorstel kunnen niet meer worden gewijzigd of verwijderd.
- Is een paragraaf gewijzigd nadat een voorstel werd gemaakt, dan kan dat voorstel niet meer worden goedgekeurd (het zou de nieuwe tekst overschrijven). Wijs het af als "achterhaald" en maak een nieuw voorstel.
- Paragraaf-ID's worden nooit hergebruikt. Een nieuwe paragraaf krijgt het volgende vrije nummer.
- Alle acties staan in een logboek dat alleen kan worden aangevuld.

**Bijlagen.** Rechts op elke hoofdstukpagina staat het bijlagenblok met vier groepen: downloads, templates, stappenplannen en links. Met *+ Bijlage voorstellen* voeg je er een toe; bij een bestaande bijlage kies je *Wijzigen* of *Laten vervallen*.
- Elke bijlage heeft een titel, omschrijving en datum, en een vast ID (bijvoorbeeld H02-B01).
- Bestanden: alleen Word (.docx, .doc, .dotx), pdf en Excel (.xlsx, .xls, .xltx), maximaal 5 MB. De server controleert ook of het bestand echt is wat de naam zegt.
- Links: een volledig webadres dat begint met https://.
- Bijlagen volgen dezelfde goedkeuring als tekst. Een geüpload bestand is pas zichtbaar in de kennisbank na goedkeuring; de beoordelaar kan het vooraf openen. Na goedkeuring krijgt het hoofdstuk een nieuw versienummer, en in de versiegeschiedenis staat welke bijlage is toegevoegd, gewijzigd of vervallen.
- Een vervallen bijlage wordt niet verwijderd, maar blijft bewaard in de database.

**Bewuste keuze:** het vier-ogenprincipe berust op de gekozen naam. Technisch kan iemand een andere naam kiezen; dat is tussen de twee redacteuren afgesproken.

Wat nog volgt:
| Stap | Onderdeel |
|---|---|
| 4 | Testset |
| 5 | Volledige export (hele kennisbank PDF/Word, Markdown/JSON voor de beheerpartij, back-up) |

## Mappen

```
netlify.toml                      Netlify-instellingen
package.json                      pakketten voor de Functions (@netlify/database, @netlify/blobs)
public/                           de website (bevat GEEN kennisbankinhoud)
  index.html, hoofdstuk.html      startpagina en hoofdstukpagina
  voorstellen.html                openstaande en afgeronde voorstellen, beoordelen
  404.html                        foutpagina
  css/fin.css                     vormgeving (kleuren en lettertypen bovenaan als variabelen)
  js/                             data.js (API en naamkeuze), tekst.js, vergelijk.js, voorstelformulier.js, bijlageformulier.js,
                                  voorstellen.js, start.js, hoofdstuk.js, algemeen.js
  assets/fin/, assets/logo/       beelden (nog aan te leveren, zie LEESMIJ.txt)
netlify/edge-functions/           wachtwoord.js: wachtwoordbeveiliging vóór de hele site
netlify/functions/                API: /api/kennisbank, /api/hoofdstuk, /api/redacteuren, /api/voorstellen, /api/voorstel,
                                  /api/upload, /api/bestand
netlify/lib/                      gedeelde servercode, workflow (voorstellen.mjs), bestanden (bestanden.mjs), databasequeries, lijst redacteuren
netlify/database/migrations/      databaseschema, import basisversie 1.0, voorstellen (bouwstap 3), bijlagen (3b)
import/                           importbestanden basisversie 1.0 (bron voor de migratie, en back-up)
docs/                             CONTROLEREN.md, importformaat.md
tools/                            convert.py (Word → importbestanden), maak_migratie.py (importbestanden → migratie)
```

## Eenmalig instellen in Netlify

**1. Abonnement controleren**
Netlify Database werkt alleen op een abonnement met credits (credit-based plan). Omdat je bij je project de instelling *Project visibility* ziet, zit je al op zo'n abonnement.

**2. Bestanden vervangen in GitHub**
Upload de inhoud van de zip naar de repository en overschrijf de bestaande bestanden. Uploaden verwijdert geen oude bestanden. Verwijder daarom in GitHub deze bestanden en mappen als ze er nog staan:
- `public/data` (hierin stond in bouwstap 1 de inhoud)
- `public/login.html`
- `public/js/login.js`
- `public/js/identiteit.js`
- `netlify/functions/sessie.mjs` (laat je dit staan, dan mislukt de deploy)

Netlify deployt daarna vanzelf.

Bij bouwstap 3 en 3b hoeft niets te worden verwijderd; alle bestanden zijn nieuw of vervangen een bestaand bestand. Nieuw zijn onder meer de migraties `20260920090000_voorstellen.sql` en `20260921090000_bijlagen.sql`, `public/voorstellen.html`, `netlify/functions/upload.mjs` en `bestand.mjs`, en de bestanden in `netlify/lib/` en `public/js/`. Netlify Blobs (de opslag voor bestanden) hoeft niet apart te worden aangezet.

**3. Deploy controleren**
Open *Deploys* en klik op de nieuwste deploy. Controleer in het log dat Netlify Database is ingesteld en dat de migraties zijn geladen uit `netlify/database/migrations`. Bij deze levering worden de migraties `20260920090000_voorstellen` en `20260921090000_bijlagen` uitgevoerd. Mislukt de deploy bij het aanmaken van de database, kopieer dan de foutmelding en het adres van het deploylog en stuur ze door. Probeer niets met de hand in de database te veranderen.

**Wachtwoord van de site**
De hele site (ook `/api/...` en de bestanden) is beveiligd met een wachtwoord, via de Edge Function `netlify/edge-functions/wachtwoord.js`. Het wachtwoord staat niet in de code, maar in Netlify:
1. *Project configuration → Environment variables → Add a variable*.
2. Naam `SITE_PASSWORD`, waarde: een lang wachtwoord (bijvoorbeeld vier losse woorden). Scopes: *All scopes*. Deploy contexts: *Same value for all deploy contexts* (dan geldt het ook voor Deploy Previews).
3. Opnieuw deployen (*Deploys → Trigger deploy*) zodat de variabele wordt gebruikt.

Ontbreekt `SITE_PASSWORD`, dan is de site voor iedereen dicht. Na inloggen blijf je 14 dagen ingelogd in die browser; *Uitloggen* staat in het menu. Wijzig je het wachtwoord, dan wordt iedereen uitgelogd.

**4. Toegang controleren**
1. *Project configuration → General → Visitor access → Project visibility* moet op **Private** staan, voor Production én Deploy Previews. Zet dit nooit op Public: dan kan iedereen de kennisbank lezen.
2. Laat Paul het adres van de site openen en inloggen met zijn eigen Netlify-account. Op een Free- of Personal-abonnement kan alleen de eigenaar een private site bekijken; lukt het Paul niet, dan is een Pro-abonnement nodig.

## Testen

Test bij voorkeur eerst op een **Deploy Preview**: die heeft een eigen kopie van de database, dus proefvoorstellen komen niet in de echte kennisbank. Zet daarvoor de nieuwe bestanden in een aparte branch en open een pull request.

1. Kies rechtsboven "Ik ben Ron Stieding".
2. Open hoofdstuk 7 en klik bij H07-P01 op *Wijziging voorstellen*. Pas een woord aan: onder *Vergelijking met de huidige tekst* zie je de wijziging gemarkeerd.
3. Vul wat, waarom en bron in en klik op *Indienen ter validatie*. Je komt op het voorstel; er is geen knop om zelf goed te keuren.
4. Laat Paul (of jijzelf in een ander browservenster, met "Ik ben Paul Baans") de pagina *Openstaande voorstellen* openen. Het voorstel staat onder "Wacht op jouw beoordeling".
5. *Goedkeuren* is pas te klikken als alle vijf checklistpunten zijn aangevinkt. Keur goed.
6. Hoofdstuk 7 staat nu op versie 1.1, auteur Ron, goedkeurder Paul. Klik in de versiegeschiedenis op *Vergelijk met 1.0*.
7. Probeer *Afwijzen* zonder reden: dat kan niet.
8. Open hoofdstuk 2 en klik rechts op *+ Bijlage voorstellen*. Kies Template, vul titel, omschrijving en datum in en upload een Excel-bestand. Dien in.
9. Laat de andere redacteur het voorstel openen, het bestand bekijken via *Bestand openen* en goedkeuren. De template staat nu onder Templates en is te downloaden.
10. Voeg op dezelfde manier een link toe. Probeer ook een bestand van meer dan 5 MB of een ander soort bestand: dat wordt geweigerd.

Werkt alles, voeg de pull request dan samen. Dan komt bouwstap 3 live, met een schone database (de proefvoorstellen blijven in de preview).

## Goed om te weten

- **Deploy Previews** krijgen een eigen kopie van de database. Wat je daar verandert, komt niet in de live-database. Let op: de bestandsopslag (Netlify Blobs) wordt wél gedeeld. Een testbestand dat je op een preview uploadt, komt in dezelfde opslag, maar is op de live site nergens zichtbaar omdat de live-database het niet kent.
- **Redacteuren toevoegen of wijzigen**: pas de namen aan in `netlify/lib/redacteuren.mjs` en geef de persoon toegang tot het Netlify-team.
- **Geheimen**: de code bevat geen wachtwoorden of sleutels. Netlify regelt de databaseverbinding zelf. Het sitewachtwoord staat alleen in de Netlify-variabele `SITE_PASSWORD` (lokaal in een `.env`-bestand, dat git negeert).
- **Migraties** in `netlify/database/migrations/` nooit aanpassen of verwijderen nadat ze zijn uitgevoerd. Netlify controleert dat en weigert dan de deploy. Veranderingen gaan altijd via een nieuwe migratie.
- **De inhoud** wijzig je vanaf bouwstap 3 alleen via de website (voorstel → validatie → goedkeuring). Niet via GitHub of rechtstreeks in de database.

## Nog in te vullen (huisstijl)

- Exacte HEX-codes van rood, zwart en wit: `public/css/fin.css`, bovenaan. Rood staat nu voorlopig op `#D0011B`.
- Lettertypen voor koppen en tekst: dezelfde plek, `--font-kop` en `--font-tekst`.
- Logo en beelden van Fin: zie `public/assets/*/LEESMIJ.txt`.
