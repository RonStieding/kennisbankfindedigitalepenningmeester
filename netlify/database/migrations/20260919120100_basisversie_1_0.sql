-- Kennisbank Fin – datamigratie basisversie 1.0
-- Gegenereerd door tools/maak_migratie.py uit Vragenlijst Fin – FinSport versie 2 (Word).
-- NIET WIJZIGEN nadat deze migratie is uitgevoerd.
-- Werkwijze per hoofdstuk: versie aanmaken als concept, paragrafen toevoegen,
-- daarna goedkeuren (de database staat niet toe dat een versie direct als goedgekeurd wordt ingevoegd).

-- H01 – De rol van de penningmeester
INSERT INTO hoofdstuk (id, nummer) VALUES ('H01', 1);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H01', '1.0', 'concept', 'De rol van de penningmeester', 'De penningmeester zorgt dat het bestuur zicht houdt op de financiën van de sportvereniging.', 'Hoofdstuk 1 — De rol van de penningmeester', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H01' AND versie = '1.0'), 'H01-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'De penningmeester zorgt dat het bestuur zicht houdt op de financiën van de sportvereniging. Hoeveel geld komt er binnen? Welke betalingen staan nog open? En kan de vereniging haar plannen betalen? De penningmeester houdt deze informatie bij, legt haar begrijpelijk uit en wijst het bestuur op financiële gevolgen van besluiten.

De penningmeester is lid van het bestuur. De uitvoering van veel financiële taken kan bij één persoon liggen, maar het bestuur blijft samen verantwoordelijk voor het besturen van de vereniging. Welke taken en bevoegdheden de penningmeester precies heeft, hangt af van de statuten en de afspraken binnen de club. [NOC*NSF – Rol van de penningmeester](https://www.nocnsf.nl/handboek-wet-en-regelgeving/8-rol-van-de-penningmeester)', '[{"label": "NOC*NSF – Rol van de penningmeester", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/8-rol-van-de-penningmeester"}]', DATE '2027-09-19', 12, '3a03254b5df140a3');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H01' AND versie = '1.0'), 'H01-P01', 1, 'vraag', '1', 'Wat doet een penningmeester van een sportvereniging?', '1. Wat doet een penningmeester van een sportvereniging?', 'De werkzaamheden vallen in vier groepen uiteen:

| **Taak** | **Wat betekent dit in de praktijk?** |
| --- | --- |
| Administreren | Inkomsten, uitgaven, facturen, declaraties en financiële afspraken overzichtelijk vastleggen. |
| Beheren | Betalingen, contributieontvangsten, bankrekeningen en eventuele contante kas volgen. |
| Vooruitkijken | Een begroting voorbereiden en aangeven wat plannen of tegenvallers financieel betekenen. |
| Uitleggen en verantwoorden | Het bestuur informeren, financiële stukken voor de ALV voorbereiden en vragen van de kascommissie beantwoorden. |

De penningmeester hoeft dit niet allemaal alleen te doen. Een ledenadministrateur kan bijvoorbeeld de ledengegevens beheren en een boekhouder kan helpen met de jaarstukken. Spreek steeds af wie het werk uitvoert en wie het resultaat controleert.

De rol vraagt ook initiatief. Als het bestuur een extra team wil inschrijven, trainers wil betalen of een accommodatie wil verbouwen, helpt de penningmeester om vooraf de kosten en de gevolgen voor de beschikbare middelen te beoordelen. [NOC*NSF – Taken van de penningmeester](https://www.nocnsf.nl/handboek-wet-en-regelgeving/8-taken-van-de-penningmeester)', '[{"label": "NOC*NSF – Taken van de penningmeester", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/8-taken-van-de-penningmeester"}]', DATE '2027-09-19', 12, '237b9283e14f994a');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H01' AND versie = '1.0'), 'H01-P02', 2, 'vraag', '2', 'Welke financiële taken zijn mijn verantwoordelijkheid en welke zijn van het hele bestuur?', '2. Welke financiële taken zijn mijn verantwoordelijkheid en welke zijn van het hele bestuur?', 'De penningmeester bereidt financiële informatie en voorstellen voor. Het bestuur gebruikt die informatie om besluiten te nemen en houdt zicht op de financiële situatie. Andere bestuursleden kunnen hun financiële verantwoordelijkheid dus niet volledig aan de penningmeester overlaten. [NOC*NSF – Bestuurstaak](https://www.nocnsf.nl/handboek-wet-en-regelgeving/5-bestuurstaak)

Een mogelijke verdeling is:

| **Penningmeester** | **Bestuur** |
| --- | --- |
| Houdt de administratie bij of coördineert dit werk | Spreekt af hoe de administratie wordt gecontroleerd |
| Maakt een conceptbegroting en financiële rapportages | Bespreekt de cijfers en kiest financiële prioriteiten |
| Signaleert betalingsachterstanden en risico’s | Besluit welke maatregelen nodig zijn |
| Bereidt jaarstukken voor en licht ze toe | Behandelt de stukken en legt verantwoording af aan de leden |

Leg de taakverdeling vast in een bestuursbesluit of werkafspraak. Vermeld wie de penningmeester vervangt bij ziekte of vakantie en hoe die persoon toegang krijgt tot de informatie die dan nodig is.', '[{"label": "NOC*NSF – Bestuurstaak", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/5-bestuurstaak"}]', DATE '2027-09-19', 12, '4c789f0068e2b6a9');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H01' AND versie = '1.0'), 'H01-P03', 3, 'vraag', '3', 'Welke documenten en toegang heb ik nodig als ik begin?', '3. Welke documenten en toegang heb ik nodig als ik begin?', 'Vraag je voorganger en het bestuur om een overdracht van de volgende zaken:

- Verenigingsregels: statuten, huishoudelijk reglement en afspraken over uitgaven, betalingen en rapportages.

- Financiële stukken: de laatste begroting, jaarstukken, tussentijdse overzichten en opmerkingen van de kascommissie.

- Administratie: toegang tot de boekhouding, facturen, bonnetjes en eerdere bankafschriften.

- Actuele verplichtingen: openstaande facturen, contributieachterstanden, contracten, leningen en toegezegde subsidies.

- Bank en kas: een overzicht van rekeningen, passen, betaalrechten, limieten en eventuele contante kassen.

- Planning: terugkerende betaalmomenten, aangiften, subsidievoorwaarden en data van bestuur, kascommissie en ALV.

- Contactpersonen: degene die ledengegevens, kantinegeld, evenementen of team- en commissiebudgetten beheert.

Controleer samen met het bestuur of de bestuursgegevens bij KVK en de gegevens bij de bank moeten worden aangepast. Een bestuurswissel kan ook gevolgen hebben voor de UBO-registratie. [KVK – Bestuurswissel doorgeven](https://www.kvk.nl/wijzigen/bestuurswissel-doorgeven/)

Gebruik waar mogelijk een eigen account. Laat de toegang van een vertrekkende bestuurder aanpassen of beëindigen zodra de overdracht is afgerond. Controleer ook of de vereniging zelf toegang houdt tot de administratie en reservekopieën, zodat die informatie niet alleen op de privécomputer van één vrijwilliger staat.', '[{"label": "KVK – Bestuurswissel doorgeven", "url": "https://www.kvk.nl/wijzigen/bestuurswissel-doorgeven/"}]', DATE '2027-09-19', 12, '8a87f08092a9246d');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H01' AND versie = '1.0'), 'H01-P04', 4, 'vraag', '4', 'Hoe krijg ik snel inzicht in de financiële situatie?', '4. Hoe krijg ik snel inzicht in de financiële situatie?', 'Begin met een overzicht dat je aan het bestuur kunt laten zien. Beantwoord daarin vijf vragen:

- Hoeveel geld staat er nu op de bankrekeningen en in kas?

- Welke bedragen moeten we nog betalen?

- Welke bedragen verwachten we nog te ontvangen?

- Welke grote inkomsten en uitgaven volgen later in het seizoen?

- Welke financiële zorgen of besluiten liggen er al?

Vergelijk daarna de bankstanden met de boekhouding. Kijk ook naar de begroting en de cijfers van het vorige jaar. Een banksaldo vertelt op zichzelf niet hoeveel de vereniging kan uitgeven: een deel van dat geld kan nodig zijn voor huur, vergoedingen of andere verplichtingen.

Kom je cijfers tegen die niet aansluiten? Noteer wat je hebt gecontroleerd, wat nog onduidelijk is en wie kan helpen het verschil te verklaren. Bespreek belangrijke verschillen met het bestuur.', '[]', DATE '2027-09-19', 12, 'c2c3cbc11054ec94');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H01' AND versie = '1.0'), 'H01-P05', 5, 'vraag', '5', 'Hoe verdeel ik financiële taken met andere bestuursleden en commissies?', '5. Hoe verdeel ik financiële taken met andere bestuursleden en commissies?', 'Leg voor elke geldstroom vast:

- wie de gegevens aanlevert of een uitgave aanvraagt;

- wie de aanvraag of factuur goedkeurt;

- wie de betaling uitvoert of de ontvangst verwerkt;

- wie achteraf controleert of alles klopt.

Bijvoorbeeld: de ledenadministrateur verwerkt nieuwe leden en opzeggingen. De penningmeester gebruikt die gegevens om contributie te innen en vergelijkt de verwachte contributie met de werkelijke ontvangsten. Bij een factuur bevestigt iemand met kennis van de aankoop dat de levering klopt; daarna wordt de betaling volgens de bankafspraken uitgevoerd.

Zorg ook dat een tweede bestuurslid de bankmutaties regelmatig kan bekijken. Laat niet alle stappen van aanvragen, goedkeuren, betalen en controleren ongezien bij één persoon liggen. Welke verdeling werkbaar is, hangt af van de grootte van de club en het aantal beschikbare vrijwilligers.', '[]', DATE '2027-09-19', 12, 'fcb65e00a2975fc7');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H01' AND versie = '1.0'), 'H01-P06', 6, 'vraag', '6', 'Welke financiële besluiten mag ik zelf nemen?', '6. Welke financiële besluiten mag ik zelf nemen?', 'Dat hangt af van de statuten, reglementen en bestuursafspraken. Er bestaat geen algemeen bedrag waaronder iedere penningmeester zelfstandig mag beslissen. Controleer ook of een besluit van de ALV of voorafgaande goedkeuring van het bestuur nodig is. [NOC*NSF – Bestuurstaak](https://www.nocnsf.nl/handboek-wet-en-regelgeving/5-bestuurstaak)

Maak onderscheid tussen:

- een uitgave goedkeuren: besluiten dat de vereniging iets aanschaft;

- een contract tekenen: namens de vereniging een verplichting aangaan;

- een betaling uitvoeren: geld overmaken via de bank.

Dit kunnen bevoegdheden van verschillende personen zijn. Banktoegang betekent niet automatisch dat iemand iedere uitgave mag goedkeuren. Leg daarom vast welke bedragen en soorten uitgaven vooraf akkoord vereisen, wie dat akkoord geeft en hoe het wordt vastgelegd. De bevoegdheid om de vereniging naar buiten toe te vertegenwoordigen hangt onder meer af van de statuten en de registratie bij KVK. [KVK – Bestuurder van een vereniging](https://www.kvk.nl/wetten-en-regels/bestuurder-van-een-vereniging-dit-zijn-de-regels-en-taken/)', '[{"label": "NOC*NSF – Bestuurstaak", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/5-bestuurstaak"}, {"label": "KVK – Bestuurder van een vereniging", "url": "https://www.kvk.nl/wetten-en-regels/bestuurder-van-een-vereniging-dit-zijn-de-regels-en-taken/"}]', DATE '2027-09-19', 12, 'd33e678644c5e3ea');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H01' AND versie = '1.0'), 'H01-P07', 7, 'vraag', '7', 'Wanneer moet ik het bestuur informeren of om een besluit vragen?', '7. Wanneer moet ik het bestuur informeren of om een besluit vragen?', 'Geef het bestuur regelmatig een kort financieel overzicht. Meld het daarnaast direct wanneer:

- de vereniging mogelijk niet op tijd kan betalen;

- inkomsten achterblijven of kosten duidelijk hoger worden dan begroot;

- een grote uitgave of een langdurig contract wordt voorgesteld;

- een subsidievoorwaarde mogelijk niet wordt gehaald;

- een betaling, kasverschil of boeking niet te verklaren is;

- een keuze gevolgen heeft voor contributie, reserves of toekomstige jaren.

Beschrijf bij zo’n melding wat er is gebeurd, wat het financiële gevolg kan zijn, welke opties er zijn en welk besluit nodig is. Zo kan het bestuur tijdig handelen.

Denk ook vooruit naar de kascommissie. Maak met haar en het bestuur op tijd afspraken over wanneer de financiële stukken beschikbaar zijn, wie vragen beantwoordt en waar de commissie de benodigde informatie kan inzien. De kascommissie controleert namens de leden; een goed voorbereide administratie maakt die controle eenvoudiger.', '[]', DATE '2027-09-19', 12, '54943903214261e6');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H01' AND versie = '1.0'), 'H01-P08', 8, 'vraag', '8', 'Welke kennis en hulpmiddelen heb ik nodig?', '8. Welke kennis en hulpmiddelen heb ik nodig?', 'Je hoeft geen professionele boekhouder te zijn. Je moet wel de financiële situatie kunnen volgen, afwijkingen herkennen en vragen kunnen stellen als iets niet duidelijk is. De belangrijkste basisvaardigheden zijn:

- inkomsten, uitgaven, bezittingen en verplichtingen uit elkaar houden;

- een begroting lezen en vergelijken met de werkelijke cijfers;

- bankmutaties met de administratie vergelijken;

- bewijsstukken en besluiten terugvinden;

- cijfers in gewone taal uitleggen aan bestuur en leden.

Gebruik hulpmiddelen die ook je opvolger kan begrijpen: een overzichtelijke boekhouding, een gedeelde financiële kalender, een geordend digitaal archief en een vast format voor de bestuursrapportage. Zorg voor een vervanger en maak regelmatig een reservekopie van de administratie.

Vraag hulp aan een boekhouder of andere deskundige als de vereniging bijvoorbeeld personeel heeft, een grote accommodatie beheert of ingewikkelde fiscale vragen tegenkomt. Het bestuur blijft ook dan verantwoordelijk voor het gebruik van de financiële informatie.', '[]', DATE '2027-09-19', 12, 'f65540b0df5d5534');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H01' AND versie = '1.0'), 'H01-P09', 9, 'checklist', NULL, 'Startchecklist voor de nieuwe penningmeester', 'Startchecklist voor de nieuwe penningmeester', '- Ik heb de statuten en financiële werkafspraken gelezen.

- Ik weet wie uitgaven mag goedkeuren, contracten mag tekenen en betalingen mag uitvoeren.

- Ik heb de laatste begroting, jaarstukken en bevindingen van de kascommissie ontvangen.

- Ik heb toegang tot de boekhouding, bankinformatie en bewijsstukken.

- Ik ken de openstaande bedragen en komende grote betalingen.

- Ik weet wie ledengegevens, kantinegeld en commissiebudgetten beheert.

- Een tweede bestuurslid kan de bankmutaties controleren.

- Er is een regeling voor mijn afwezigheid en voor reservekopieën van de administratie.

- De bestuursregistratie en banktoegang worden waar nodig bijgewerkt.

- Ik heb met het bestuur en de kascommissie afspraken gemaakt over rapportage en planning.', '[]', DATE '2027-09-19', 12, '0a3f54bd646dc6df');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H01' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H01', 'Basisversie 1.0 geïmporteerd, 10 paragrafen, goedgekeurd door Paul Baans');

-- H02 – Financiële administratie en bankzaken
INSERT INTO hoofdstuk (id, nummer) VALUES ('H02', 2);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H02', '1.0', 'concept', 'Financiële administratie en bankzaken', 'Een goede administratie laat zien welk geld de sportvereniging heeft, waar het vandaan komt en welke bedragen zij nog moet ontvangen of betalen.', 'Hoofdstuk 2 — Financiële administratie en bankzaken', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'Een goede administratie laat zien welk geld de sportvereniging heeft, waar het vandaan komt en welke bedragen zij nog moet ontvangen of betalen. Ze helpt de penningmeester bij het dagelijkse werk, het bestuur bij besluiten en de kascommissie bij haar controle.

De administratie hoeft niet ingewikkelder te zijn dan de vereniging nodig heeft. Ze moet wel actueel, begrijpelijk en controleerbaar blijven — ook voor iemand die haar later overneemt.', '[]', DATE '2027-09-19', 12, '6a7dfddbe612ac8f');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P01', 1, 'vraag', '1', 'Hoe richt ik de boekhouding van een sportvereniging in?', '1. Hoe richt ik de boekhouding van een sportvereniging in?', 'Begin met een rekenschema: een lijst van de posten waaronder je inkomsten, kosten, bezittingen en schulden vastlegt. Een duidelijke indeling zorgt dat vergelijkbare bedragen steeds op dezelfde plek terechtkomen. Daardoor kun je de boekhouding gebruiken voor de begroting, tussentijdse rapportages en jaarstukken.

De bijgevoegde Rekenschema sportvereniging template gebruikt het aangeleverde benchmarkbestand als startpunt. De template heeft drie onderdelen:

| **Onderdeel** | **Voorbeelden van rubrieken** |
| --- | --- |
| Baten | Bijdragen van leden, kantine, sponsoring, subsidies, evenementen en verhuur |
| Lasten | Sportactiviteiten, huisvesting, personeel, vrijwilligers, kantine en verenigingskosten |
| Balans | Bezittingen, geldmiddelen, eigen vermogen en schulden |

Loop de template met een tweede bestuurslid door. Geef bij iedere post aan of de vereniging deze gebruikt. Vul daarna de eigen rekeningcode in als jullie boekhoudprogramma met rekeningnummers werkt. Noteer in de toelichtingskolom waar een post voor bedoeld is of hoe een bestaande boekhoudrekening op de benchmarkindeling aansluit.

Voorbeeld: de vereniging boekt zaalhuur op rekening 4100. In de template kan bij Lasten → Huisvestingslasten → Huur zaal de eigen rekeningcode 4100 worden ingevuld. Zo blijft de bestaande boekhouding herkenbaar en wordt duidelijk waar die kosten in de rapportage thuishoren.

De kolom Relevantie volgens bron helpt bij het kiezen van posten. Een vermelding zoals teamsporten of eigen accommodatie is een aanwijzing uit de benchmark, geen regel die bepaalt hoe jouw vereniging moet boeken. Voeg ontbrekende posten toe aan de eigen boekhouding en leg vast hoe ze op de gekozen indeling aansluiten.

Let op bij de balans en reserveringen: de template neemt de benamingen uit het aangeleverde schema als uitgangspunt. De juiste verwerking van bijvoorbeeld afschrijvingen, voorzieningen en reserves vraagt soms een aparte beoordeling bij de jaarafsluiting. Een bedrag opzij willen zetten maakt het niet automatisch tot een kostenpost.

Leg vervolgens per boeking minimaal vast:

- de datum en het bedrag;

- van wie het geld komt of aan wie het is betaald;

- waarvoor het bedrag bedoeld is;

- bij welke post en eventueel welk team of evenement het hoort;

- waar het bijbehorende bewijsstuk te vinden is.

Gebruik de gekozen posten consequent. Als je een vergoeding voor trainers de ene maand onder vrijwilligers en de volgende maand onder personeel boekt, worden vergelijkingen lastig. Bespreek een wijziging in de indeling daarom vooraf en zorg dat eerdere en nieuwe cijfers vergelijkbaar blijven.

Kies ten slotte een werkwijze die bij de vereniging past: een overzichtelijk spreadsheet kan voldoende zijn voor een kleine club; bij meer transacties of meerdere gebruikers kan boekhoudsoftware handiger zijn. Het rekenschema is in beide gevallen de indeling van de administratie. De template zelf is geen transactieregistratie.', '[]', DATE '2027-09-19', 12, '926a8b619fa28a1b');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P02', 2, 'vraag', '2', 'Welke inkomsten en uitgaven moet ik vastleggen?', '2. Welke inkomsten en uitgaven moet ik vastleggen?', 'Leg alle inkomsten en uitgaven van de vereniging vast, ook kleine contante bedragen. Verwerk daarnaast bedragen die nog ontvangen of betaald moeten worden. Anders lijkt het financiële beeld gunstiger of ongunstiger dan het werkelijk is.

Een betaling en een kostenpost zijn niet altijd hetzelfde. Betaalt de vereniging in december alvast de huur voor januari, dan gaat het geld in december van de bank, terwijl de huur betrekking heeft op januari. Dit onderscheid wordt vooral belangrijk bij de jaarafsluiting; hoofdstuk 3 werkt het verder uit.

Vergeet geldstromen buiten de gebruikelijke bankrekening niet, zoals contante ontvangsten bij een evenement, betalingen via een betaalprovider of geld dat een commissie beheert. Spreek af wie de gegevens daarvan aanlevert en hoe vaak dat gebeurt.', '[]', DATE '2027-09-19', 12, '882da6a5dd37710b');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P03', 3, 'vraag', '3', 'Welke bewijsstukken moet ik bewaren en hoe organiseer ik die?', '3. Welke bewijsstukken moet ik bewaren en hoe organiseer ik die?', 'Bij iedere boeking moet terug te vinden zijn waarom het bedrag is ontvangen of betaald. Bewaar bijvoorbeeld facturen, bonnetjes, declaraties, subsidiebrieven, sponsorafspraken, kasoverzichten en bankafschriften. Bewaar bij een uitgave ook het akkoord als dat volgens de verenigingsregels nodig is.

Een praktische werkwijze is om ieder bewijsstuk een herkenbaar nummer of een duidelijke bestandsnaam te geven. Verwijs in de boekhouding naar dat stuk. Bijvoorbeeld: bij de boeking voor nieuwe wedstrijdballen staat een verwijzing naar de leveranciersfactuur en het akkoord voor de aankoop.

Bewaar digitale documenten op een plek waar bevoegde bestuursleden bij kunnen en maak reservekopieën. Controleer bij een wisseling van boekhoudprogramma of oude gegevens leesbaar blijven. De administratie van een vereniging moet in beginsel zeven jaar worden bewaard; voor bepaalde gegevens, waaronder gegevens over onroerende zaken, kan een langere termijn gelden. [KVK – Bestuurder van een vereniging](https://www.kvk.nl/wetten-en-regels/bestuurder-van-een-vereniging-dit-zijn-de-regels-en-taken/), [Belastingdienst – Administratie bewaren](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/administratie_bijhouden/administratie_bewaren/)', '[{"label": "KVK – Bestuurder van een vereniging", "url": "https://www.kvk.nl/wetten-en-regels/bestuurder-van-een-vereniging-dit-zijn-de-regels-en-taken/"}, {"label": "Belastingdienst – Administratie bewaren", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/administratie_bijhouden/administratie_bewaren/"}]', DATE '2027-09-19', 12, '4c45d0acdca8018d');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P04', 4, 'vraag', '4', 'Hoe verwerk ik facturen, bonnetjes en declaraties?', '4. Hoe verwerk ik facturen, bonnetjes en declaraties?', 'Gebruik voor inkomende facturen een vaste volgorde:

- Ontvang: zorg dat de factuur op een afgesproken adres of in een gedeelde omgeving binnenkomt.

- Controleer: kloppen leverancier, bedrag, geleverde goederen of diensten en betaalgegevens?

- Vraag akkoord: laat de aangewezen persoon bevestigen dat de uitgave is toegestaan.

- Leg vast: registreer de factuur en de vervaldatum in de administratie.

- Betaal: voer de betaling uit volgens de bankafspraken.

- Controleer achteraf: koppel de betaling aan de factuur en markeer haar als betaald.

Vraag bij declaraties om de naam van de indiener, de reden van de uitgave, de datum, het bedrag en de bon of factuur. Spreek vooraf af welke uitgaven vrijwilligers mogen doen en wie hun declaraties goedkeurt.

Ontbreekt een bewijsstuk? Vraag eerst om een kopie of andere onderbouwing. Leg vast hoe het bedrag uiteindelijk is beoordeeld.', '[]', DATE '2027-09-19', 12, '2b4455533f6dd207');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P05', 5, 'vraag', '5', 'Hoe controleer ik of de boekhouding aansluit op de bankrekening?', '5. Hoe controleer ik of de boekhouding aansluit op de bankrekening?', 'Vergelijk periodiek alle af- en bijschrijvingen op het bankafschrift met de boekhouding. Dit heet een bankafstemming. Controleer in beide richtingen:

- Staat iedere bankmutatie in de boekhouding?

- Is iedere als betaald geboekte factuur werkelijk van de bank afgeschreven?

- Zijn ontvangen bedragen aan de juiste contributie, factuur of andere inkomstenbron gekoppeld?

- Komt het banksaldo in de boekhouding overeen met het werkelijke banksaldo?

Werk verschillen uit totdat duidelijk is waar ze vandaan komen. Een verschil kan ontstaan door een dubbele boeking, vergeten bankkosten, een verkeerd bedrag of een betaling die nog onderweg is. Corrigeer een fout zó dat later te zien blijft wat is aangepast en waarom.

Laat daarnaast een ander bestuurslid de bankmutaties regelmatig bekijken. Die controle vult de afstemming door de penningmeester aan.', '[]', DATE '2027-09-19', 12, '0805f46f03152b71');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P06', 6, 'vraag', '6', 'Hoe regel ik betalingen en wie mag ze goedkeuren?', '6. Hoe regel ik betalingen en wie mag ze goedkeuren?', 'Leg vast wie een uitgave mag aanvragen, wie haar goedkeurt, wie de betaling klaarzet en wie deze bij de bank autoriseert. Kijk daarbij naar de statuten, bestuursafspraken en de mogelijkheden van de bank. Banktoegang en toestemming voor een uitgave zijn verschillende zaken.

Stel passende betaallimieten in. Een tweede bestuurslid moet bankmutaties kunnen controleren; bij grotere bedragen kan de vereniging afspreken dat een tweede persoon de betaling autoriseert. Controleer of zulke afspraken ook in de bankinstellingen zijn verwerkt.

Gebruik voor ieder persoon een eigen banktoegang en deel geen inloggegevens. Werk bevoegdheden bij wanneer een bestuurder vertrekt. [KVK – Zakelijke rekening voor een vereniging](https://www.kvk.nl/geldzaken/zakelijke-rekening-openen-deze-documenten-heb-je-nodig/)

Praktische controlevraag: wie merkt het op als vandaag een betaling wordt gedaan die niet voor de vereniging bedoeld is, en wanneer merkt die persoon dat op?', '[{"label": "KVK – Zakelijke rekening voor een vereniging", "url": "https://www.kvk.nl/geldzaken/zakelijke-rekening-openen-deze-documenten-heb-je-nodig/"}]', DATE '2027-09-19', 12, '5e3b0353762c6ddb');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P07', 7, 'vraag', '7', 'Hoe beheer ik contant geld, bijvoorbeeld uit de kantine of bij evenementen?', '7. Hoe beheer ik contant geld, bijvoorbeeld uit de kantine of bij evenementen?', 'Houd contant geld zo overzichtelijk mogelijk. Spreek af wie de kas beheert, hoeveel wisselgeld erin zit, wanneer er wordt geteld en wanneer geld op de bank wordt gestort.

Noteer iedere ontvangst en uitgave, bewaar de bewijsstukken en vergelijk het berekende kassaldo met het geld dat werkelijk aanwezig is. Laat bij grotere bedragen twee personen samen tellen en de telling vastleggen. Noteer ook een kasverschil; verander de registratie niet om de kas achteraf passend te maken.

Bij kantineverkoop of een evenement is alleen het afgestorte bedrag vaak onvoldoende informatie. Leg ook vast wat er volgens de kassa, betaalterminal of verkoopregistratie is ontvangen en hoe dat aansluit op contant geld en pinbetalingen.', '[]', DATE '2027-09-19', 12, 'a261d4d28460f512');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P08', 8, 'vraag', '8', 'Hoe houd ik de financiën van teams en commissies overzichtelijk?', '8. Hoe houd ik de financiën van teams en commissies overzichtelijk?', 'Geef teams en commissies vooraf duidelijkheid over hun budget en bevoegdheden. Spreek af welke aankopen eerst akkoord vereisen en wanneer zij bewijsstukken aanleveren.

Gebruik in de boekhouding een herkenbare aanduiding per team, commissie of activiteit als het bestuur die cijfers afzonderlijk wil zien. Laat geld dat een commissie beheert regelmatig verantwoorden: beginbedrag, ontvangsten, uitgaven en eindbedrag moeten op elkaar aansluiten.

Een team- of commissiebudget is onderdeel van de financiën van de vereniging. Zorg dat de penningmeester deze bedragen kan opnemen in de totale administratie en rapportage.', '[]', DATE '2027-09-19', 12, 'a588ed74f6e6576d');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P09', 9, 'vraag', '9', 'Welke boekhoudsoftware of andere hulpmiddelen passen bij onze vereniging?', '9. Welke boekhoudsoftware of andere hulpmiddelen passen bij onze vereniging?', 'Kies op basis van het werk dat de club daadwerkelijk heeft. Stel bij een spreadsheet of programma ten minste deze vragen:

- Kunnen we de posten uit ons rekenschema goed vastleggen?

- Kunnen we bankmutaties eenvoudig verwerken en controleren?

- Zijn bewijsstukken aan boekingen te koppelen of duidelijk terug te vinden?

- Kunnen bevoegde personen informatie inzien zonder alles te kunnen wijzigen?

- Zijn gegevens te exporteren voor de kascommissie en een opvolger?

- Zijn toegang, reservekopieën en ondersteuning goed geregeld?

Een hulpmiddel vervangt geen werkafspraken. Ook met automatische bankkoppelingen moet iemand controleren of bedragen bij de juiste posten zijn geboekt.', '[]', DATE '2027-09-19', 12, '96130100209e86e6');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P10', 10, 'vraag', '10', 'Wat doe ik als er een betaling of boeking niet klopt?', '10. Wat doe ik als er een betaling of boeking niet klopt?', 'Onderzoek eerst wat er feitelijk is gebeurd. Vergelijk de boeking met het bankafschrift, het bewijsstuk en de eventuele goedkeuring. Vraag de betrokken persoon om uitleg als die ontbreekt.

Maak vervolgens onderscheid tussen:

- Een administratieve fout: bijvoorbeeld een verkeerd bedrag, een dubbele boeking of een verkeerde post uit het rekenschema. Corrigeer die met een duidelijke toelichting.

- Een onduidelijke betaling: verzamel aanvullende informatie en laat het bedrag niet zonder verklaring staan.

- Een betaling zonder toestemming of een vermoeden van misbruik: informeer direct de voorzitter of een ander aangewezen bestuurslid en bewaar de relevante stukken.

Documenteer wat is vastgesteld, welke correctie of maatregel is genomen en wie daarover heeft besloten.', '[]', DATE '2027-09-19', 12, 'bcba3e1d192a632e');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P11', 11, 'overzicht', NULL, 'Werkritme voor de administratie', 'Werkritme voor de administratie', '| **Wanneer** | **Werkzaamheden** |
| --- | --- |
| Bij ontvangst van een stuk | Factuur, bon, declaratie of afspraak opslaan en doorzetten voor controle of akkoord |
| Regelmatig gedurende de maand | Betalingen voorbereiden, ontvangsten verwerken en bankmutaties bekijken |
| Na afloop van de maand | Bank en eventuele kas afstemmen; openstaande bedragen nalopen |
| Voor iedere bestuursvergadering | Een kort overzicht maken van resultaten, beschikbare middelen en aandachtspunten |
| Rond het einde van het boekjaar | Ontbrekende stukken opvragen en de administratie voorbereiden voor jaarstukken en kascontrole |', '[]', DATE '2027-09-19', 12, 'a31e595219e9e6b1');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H02' AND versie = '1.0'), 'H02-P12', 12, 'checklist', NULL, 'Checklist: staat onze administratie goed?', 'Checklist: staat onze administratie goed?', '- We hebben vastgelegd welke posten uit het rekenschema we gebruiken.

- Onze eigen rekeningcodes zijn aan die posten gekoppeld.

- Iedere boeking heeft een duidelijke omschrijving en een bewijsstuk.

- Facturen en declaraties worden vóór betaling gecontroleerd en goedgekeurd.

- Banktoegang, betaallimieten en bevoegdheden zijn vastgelegd.

- Een tweede bestuurslid bekijkt regelmatig de bankmutaties.

- Bank en eventuele kas worden periodiek met de administratie vergeleken.

- Teams en commissies leveren hun financiële gegevens op afgesproken momenten aan.

- De administratie is veilig bewaard, leesbaar en overdraagbaar.

- Verschillen en correcties worden uitgezocht en gedocumenteerd.', '[]', DATE '2027-09-19', 12, 'e4504fbbf3069d62');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H02' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H02', 'Basisversie 1.0 geïmporteerd, 13 paragrafen, goedgekeurd door Paul Baans');

-- H03 – Begroting, liquiditeit en jaarrekening
INSERT INTO hoofdstuk (id, nummer) VALUES ('H03', 3);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H03', '1.0', 'concept', 'Begroting, liquiditeit en jaarrekening', 'De begroting kijkt vooruit: wat verwacht de vereniging te ontvangen en uit te geven?', 'Hoofdstuk 3 — Begroting, liquiditeit en jaarrekening', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'De begroting kijkt vooruit: wat verwacht de vereniging te ontvangen en uit te geven? Een liquiditeitsplanning laat zien wanneer geld daadwerkelijk op de bankrekening binnenkomt en eraf gaat. De jaarrekening kijkt terug en laat zien wat het afgelopen boekjaar financieel heeft opgeleverd en hoe de vereniging er aan het einde van dat jaar voor staat.

Deze drie overzichten beantwoorden verschillende vragen. Gebruik daarom dezelfde herkenbare posten uit het rekenschema van hoofdstuk 2, maar houd het doel van ieder overzicht duidelijk.', '[]', DATE '2027-09-19', 12, '50164316af1e7220');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P01', 1, 'vraag', '1', 'Hoe maak ik een begroting voor het komende verenigingsjaar?', '1. Hoe maak ik een begroting voor het komende verenigingsjaar?', 'Begin met de plannen van de vereniging. Welke teams, trainingen, wedstrijden en activiteiten zijn voorzien? Zijn er veranderingen in ledenaantal, accommodatie, trainers of materiaal? Vertaal die plannen vervolgens naar bedragen.

Een werkbare volgorde is:

- Neem de werkelijke inkomsten en kosten van het afgelopen jaar als vertrekpunt.

- Vraag bestuursleden en commissies welke activiteiten of veranderingen zij plannen.

- Schat de inkomsten per bron, zoals contributie, sponsoring, subsidie en kantine.

- Schat de kosten per post uit het rekenschema.

- Neem bekende prijsveranderingen en nieuwe verplichtingen mee.

- Bespreek wat de vereniging doet als een verwachte inkomstenbron uitvalt.

- Leg het voorstel ter besluitvorming voor volgens de statuten en werkafspraken.

Maak bij belangrijke aannames zichtbaar hoe je tot een bedrag komt. Bijvoorbeeld: verwacht aantal leden × contributie per categorie. Zo kan het bestuur de begroting beoordelen en later verklaren waarom de werkelijkheid afwijkt.

Gebruik in de begroting bij voorkeur dezelfde posten als in de jaarrekening. Dan zijn de bedragen gedurende het jaar goed te vergelijken.', '[]', DATE '2027-09-19', 12, '8d4a62931938181d');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P02', 2, 'vraag', '2', 'Welke informatie heb ik nodig om realistisch te begroten?', '2. Welke informatie heb ik nodig om realistisch te begroten?', 'Verzamel ten minste:

- de werkelijke cijfers van één of meer voorgaande jaren;

- het huidige en verwachte ledenaantal;

- vastgestelde contributietarieven en bondsafdrachten;

- contracten voor huur, energie, verzekeringen, software en trainers;

- plannen van teams en commissies;

- afspraken met sponsors en subsidieverstrekkers;

- gepland onderhoud en vervanging van materiaal;

- bekende prijsstijgingen of wijzigingen in activiteiten.

Maak onderscheid tussen zeker, waarschijnlijk en onzeker. Een getekend sponsorcontract geeft meer houvast dan een gesprek met een mogelijke sponsor. Neem onzekere inkomsten niet zonder toelichting op alsof ze al vaststaan.

Kijk ook naar het verloop door het jaar. De contributie kan bijvoorbeeld vroeg in het seizoen binnenkomen, terwijl accommodatiekosten maandelijks doorlopen.', '[]', DATE '2027-09-19', 12, '3b177e2c06da2c99');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P03', 3, 'vraag', '3', 'Wat is het verschil tussen een begroting, een jaarrekening en een liquiditeitsplanning?', '3. Wat is het verschil tussen een begroting, een jaarrekening en een liquiditeitsplanning?', '| **Overzicht** | **Hoofdvraag** | **Periode** |
| --- | --- | --- |
| Begroting | Welke inkomsten en kosten verwachten we? | Komend boekjaar |
| Liquiditeitsplanning | Hebben we op ieder moment genoeg geld om te betalen? | Meestal per maand of kwartaal |
| Jaarrekening | Wat waren de werkelijke baten en lasten, en wat bezat of verschuldigde de vereniging aan het einde van het jaar? | Afgelopen boekjaar |

Het verschil is belangrijk omdat geld ontvangen niet altijd hetzelfde is als een bate hebben, en geld betalen niet altijd hetzelfde is als een last hebben.

Ontvangt de vereniging bijvoorbeeld een lening, dan stijgt het banksaldo. Tegelijk ontstaat een schuld; de lening is geen opbrengst. Koopt de club een duurzaam gebruikt apparaat, dan daalt het banksaldo. Afhankelijk van de verwerking komt de aanschaf als bezitting op de balans en worden de kosten over meerdere jaren verdeeld.', '[]', DATE '2027-09-19', 12, 'a6a88c1489ae4899');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P04', 4, 'vraag', '4', 'Hoe voorkom ik dat de vereniging tijdelijk te weinig geld heeft?', '4. Hoe voorkom ik dat de vereniging tijdelijk te weinig geld heeft?', 'Maak een eenvoudig overzicht per maand:

| **Maand** | **Beginsaldo bank en kas** | **Verwachte ontvangsten** | **Verwachte betalingen** | **Verwacht eindsaldo** |
| --- | --- | --- | --- | --- |
| Januari | € … | € … | € … | € … |
| Februari | € … | € … | € … | € … |
| Maart | € … | € … | € … | € … |

Reken steeds: beginsaldo + ontvangsten − betalingen = eindsaldo. Het eindsaldo van de ene maand wordt het beginsaldo van de volgende.

Neem grote betaalmomenten afzonderlijk op, zoals huur, bondsafdrachten, belastingen en investeringen. Houd ook rekening met contributie die later binnenkomt dan verwacht.

Wordt het verwachte saldo te laag? Bespreek tijdig maatregelen met het bestuur. Denk aan het verschuiven van een niet dringende aankoop, het sneller innen van openstaande bedragen of het maken van afspraken over betalingstermijnen. Kijk daarbij ook naar geld dat de vereniging voor een afgesproken doel moet gebruiken.', '[]', DATE '2027-09-19', 12, 'c4c49aa25b64698d');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P05', 5, 'vraag', '5', 'Hoe vergelijk ik tijdens het jaar de werkelijke cijfers met de begroting?', '5. Hoe vergelijk ik tijdens het jaar de werkelijke cijfers met de begroting?', 'Maak op vaste momenten een overzicht per post:

| **Post** | **Begroting tot nu toe** | **Werkelijk tot nu toe** | **Verschil** | **Verwachting voor het hele jaar** |
| --- | --- | --- | --- | --- |
| Contributie | € … | € … | € … | € … |
| Accommodatie | € … | € … | € … | € … |

Vergelijk bedragen met de begroting voor dezelfde periode. Het hele jaarbedrag delen door twaalf werkt niet altijd: contributie en seizoenskosten vallen vaak in specifieke maanden.

Licht vooral verschillen toe die groot zijn of een besluit vragen. Een verschil kan komen door een andere prijs, meer of minder activiteiten, een veranderd ledenaantal of alleen door het moment waarop een factuur is verwerkt. Vermeld ook of het verschil naar verwachting aan het einde van het jaar blijft bestaan.', '[]', DATE '2027-09-19', 12, '218801b086a54158');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P06', 6, 'vraag', '6', 'Wat doe ik als inkomsten tegenvallen of kosten hoger zijn dan gepland?', '6. Wat doe ik als inkomsten tegenvallen of kosten hoger zijn dan gepland?', 'Onderzoek eerst de oorzaak en de omvang. Gaat het om een tijdelijke verschuiving, zoals een subsidie die later wordt uitbetaald? Of ontstaat er een tekort over het hele jaar?

Maak daarna een nieuwe verwachting voor de rest van het jaar. Laat het bestuur zien:

- hoeveel het verwachte jaarresultaat verandert;

- wat het gevolg is voor het banksaldo;

- welke uitgaven of activiteiten nog beïnvloedbaar zijn;

- welke besluiten volgens de verenigingsregels nodig zijn.

Leg het besluit en de aangepaste verwachting vast. Zo blijft zichtbaar waarom de club anders handelt dan bij de oorspronkelijke begroting was voorzien. Controleer bij ingrijpende wijzigingen ook of de statuten of eerdere ALV-besluiten om goedkeuring van de leden vragen.', '[]', DATE '2027-09-19', 12, 'ce898158d440fa49');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P07', 7, 'vraag', '7', 'Hoe stel ik een balans en een overzicht van baten en lasten op?', '7. Hoe stel ik een balans en een overzicht van baten en lasten op?', 'Begin met een bijgewerkte administratie. Controleer of bank en kas aansluiten, of facturen en contributies goed zijn verwerkt en of er nog bedragen openstaan. Verwerk vervolgens posten die bij het boekjaar horen maar pas later worden betaald of ontvangen, en beoordeel afschrijvingen en andere jaarafsluitingsposten.

De financiële jaarstukken bevatten in ieder geval:

- Een balans: bezittingen, vorderingen, geld, eigen vermogen en schulden op de laatste dag van het boekjaar.

- Een staat van baten en lasten: de opbrengsten en kosten die bij het boekjaar horen.

- Een toelichting: uitleg bij belangrijke posten, keuzes en verschillen.

Een overzicht van alleen bankontvangsten en bankbetalingen is nuttig als hulpmiddel, maar vervangt deze stukken niet. Voor verenigingen beschrijft artikel 2:48 BW welke financiële stukken het bestuur ter goedkeuring aan de algemene vergadering voorlegt. [Burgerlijk Wetboek, artikel 2:48](https://wetten.overheid.nl/BWBR0003045/2024-03-13/), [NOC*NSF – Jaarverslag en jaarrekening](https://www.nocnsf.nl/handboek-wet-en-regelgeving/1-jaarverslag-en-jaarrekening)

Plan de jaarafsluiting ruim vóór de ALV. Het bestuur moet de stukken kunnen bespreken en de kascommissie moet voldoende tijd krijgen om haar onderzoek te doen. De regels voor termijnen en besluitvorming staan in de wet en kunnen verder zijn uitgewerkt in de statuten.', '[{"label": "Burgerlijk Wetboek, artikel 2:48", "url": "https://wetten.overheid.nl/BWBR0003045/2024-03-13/"}, {"label": "NOC*NSF – Jaarverslag en jaarrekening", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/1-jaarverslag-en-jaarrekening"}]', DATE '2027-09-19', 12, 'c5e1255f6256b86f');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P08', 8, 'vraag', '8', 'Hoe licht ik grote verschillen tussen begroting en werkelijkheid toe?', '8. Hoe licht ik grote verschillen tussen begroting en werkelijkheid toe?', 'Schrijf per belangrijk verschil op:

- Wat is het verschil? Noem de post en het bedrag.

- Waardoor is het ontstaan? Gebruik een concrete verklaring.

- Is het eenmalig of terugkerend?

- Wat betekent het voor volgend jaar?

Bijvoorbeeld: De accommodatiekosten waren € 3.000 hoger dan begroot doordat de zaalhuur halverwege het seizoen steeg. De hogere huur geldt ook volgend jaar en is daarom meegenomen in de nieuwe begroting.

Een toelichting hoeft niet ieder klein verschil te bespreken. Ze moet leden en bestuur helpen begrijpen wat er financieel is gebeurd en welke gevolgen dat heeft.', '[]', DATE '2027-09-19', 12, '0d50d060f6d75d38');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P09', 9, 'vraag', '9', 'Wanneer is een meerjarenbegroting nuttig?', '9. Wanneer is een meerjarenbegroting nuttig?', 'Een begroting voor meerdere jaren is vooral nuttig wanneer besluiten van vandaag later grote financiële gevolgen hebben. Denk aan:

- een langdurig huurcontract;

- het aannemen van personeel;

- een verbouwing of nieuwe accommodatie;

- het vervangen van velden of kostbaar materiaal;

- een lening met rente en aflossing;

- een subsidie die na enkele jaren stopt.

Laat per jaar de verwachte inkomsten, kosten, investeringen, financiering en beschikbare middelen zien. Werk met duidelijke aannames, bijvoorbeeld over ledenaantal en huurontwikkeling. Een meerjarenbegroting is geen voorspelling die exact moet uitkomen; ze helpt het bestuur om de gevolgen van keuzes op tijd te zien.', '[]', DATE '2027-09-19', 12, '40a0ee3efd7bc4f2');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P10', 10, 'vraag', '10', 'Hoe bepaal ik of de vereniging financieel gezond is?', '10. Hoe bepaal ik of de vereniging financieel gezond is?', 'Kijk naar meerdere signalen tegelijk:

- Resultaat: zijn de inkomsten over langere tijd voldoende om de kosten te dragen?

- Liquiditeit: kan de vereniging haar rekeningen op tijd betalen?

- Buffer: is er ruimte om een tegenvaller op te vangen?

- Verplichtingen: welke schulden, contracten en toekomstige uitgaven liggen vast?

- Afhankelijkheid: wat gebeurt er als een belangrijke sponsor of subsidie wegvalt?

- Onderhoud en vervanging: kan de vereniging noodzakelijke toekomstige uitgaven betalen?

Een overschot in één jaar betekent dus niet automatisch dat de club financieel sterk is. Omgekeerd kan een gepland tekort verantwoord zijn als het bestuur bewust beschikbare middelen inzet voor een afgesproken doel. Leg steeds uit waarom het resultaat ontstaat en wat het betekent voor de volgende jaren.', '[]', DATE '2027-09-19', 12, '2d9ede78298b25b8');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H03' AND versie = '1.0'), 'H03-P11', 11, 'checklist', NULL, 'Checklist: begroting en jaarafsluiting', 'Checklist: begroting en jaarafsluiting', '- De begroting sluit aan op de activiteiten en plannen van de vereniging.

- Belangrijke aannames, zoals ledenaantal en sponsorinkomsten, zijn vastgelegd.

- Begroting en jaarstukken gebruiken herkenbare posten uit hetzelfde rekenschema.

- Er is zicht op de verwachte bankstanden gedurende het jaar.

- Het bestuur ontvangt tussentijds een vergelijking van begroting en werkelijkheid.

- Grote verschillen en hun gevolgen worden toegelicht.

- Bank, kas en openstaande bedragen zijn gecontroleerd vóór de jaarafsluiting.

- De balans, staat van baten en lasten en toelichting zijn voorbereid.

- Het bestuur en de kascommissie krijgen de stukken tijdig.

- Grote toekomstige verplichtingen zijn ook in een meerjarenbeeld bekeken.', '[]', DATE '2027-09-19', 12, 'd520686fcd16d0d6');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H03' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H03', 'Basisversie 1.0 geïmporteerd, 12 paragrafen, goedgekeurd door Paul Baans');

-- H04 – Contributie en ledenbetalingen
INSERT INTO hoofdstuk (id, nummer) VALUES ('H04', 4);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H04', '1.0', 'concept', 'Contributie en ledenbetalingen', 'Contributie is voor veel sportverenigingen een belangrijke, terugkerende inkomstenbron.', 'Hoofdstuk 4 — Contributie en ledenbetalingen', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'Contributie is voor veel sportverenigingen een belangrijke, terugkerende inkomstenbron. Een goed contributieproces begint daarom vóór het versturen van betaalverzoeken: de tarieven moeten duidelijk zijn, de ledengegevens moeten kloppen en iedereen moet weten wanneer en hoe er betaald wordt.

Dit hoofdstuk behandelt de financiële kant van contributie. De rechten en plichten van leden volgen daarnaast uit de wet, de statuten en de reglementen van de eigen vereniging.', '[]', DATE '2027-09-19', 12, 'ea600a16e054bc70');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P01', 1, 'vraag', '1', 'Hoe bepalen we een passend contributiebedrag?', '1. Hoe bepalen we een passend contributiebedrag?', 'Begin bij de begroting uit hoofdstuk 3. Bepaal welke kosten de vereniging moet dekken en welke andere inkomsten redelijkerwijs te verwachten zijn. Het bedrag dat daarna overblijft, moet onder meer uit contributie worden betaald.

Een eenvoudige eerste berekening is:

Benodigde contributieopbrengst = verwachte kosten − overige verwachte inkomsten

Verdeel dat bedrag vervolgens over de leden. Doe dit niet door automatisch één bedrag door het totale ledenaantal te delen. Niet ieder lid betaalt noodzakelijk hetzelfde tarief, en niet ieder lid is het hele jaar aangesloten.

Kijk bij het voorstel naar:

- de verwachte aantallen leden per categorie;

- bondsafdrachten per lid of team;

- verschillen in trainingsuren en accommodatiegebruik;

- kosten die voor alle leden gezamenlijk worden gemaakt;

- bestaande kortingen of vrijstellingen;

- de financiële toegankelijkheid van de vereniging;

- de vraag of de tarieven ook de komende jaren houdbaar zijn.

Voorbeeld: als de club € 60.000 aan kosten verwacht en € 24.000 aan andere inkomsten, is € 36.000 aan contributie nodig om de begroting sluitend te maken. Vervolgens rekent de penningmeester uit wat de voorgestelde tarieven voor jeugd-, senioren- en andere leden samen naar verwachting opleveren. Blijft de uitkomst onder € 36.000, dan moet het bestuur de tarieven, kosten of andere inkomsten opnieuw bekijken.

Laat bij een contributievoorstel zien wat er voor een lid verandert én wat de verandering voor de totale begroting betekent.', '[]', DATE '2027-09-19', 12, 'b06f68fd6ab9ae68');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P02', 2, 'vraag', '2', 'Wie beslist over de hoogte en wijziging van de contributie?', '2. Wie beslist over de hoogte en wijziging van de contributie?', 'Controleer eerst de statuten en het huishoudelijk reglement. Daarin kan staan wie tarieven vaststelt, op welk moment dat gebeurt en of het bestuur binnen bepaalde grenzen tarieven mag aanpassen. Bij veel verenigingen beslist de algemene ledenvergadering over de contributie. [KVK – Bestuurder van een vereniging](https://www.kvk.nl/wetten-en-regels/bestuurder-van-een-vereniging-dit-zijn-de-regels-en-taken/)

De penningmeester bereidt het voorstel meestal voor. Een bruikbaar voorstel bevat:

- de huidige en voorgestelde tarieven;

- de reden voor de wijziging;

- de verwachte opbrengst per ledencategorie;

- de gevolgen voor de begroting;

- de ingangsdatum;

- eventuele overgangsafspraken.

Leg het besluit vast in de notulen en werk daarna de tarieflijst en ledencommunicatie bij. Maak duidelijk vanaf welk verenigingsjaar of seizoen het nieuwe tarief geldt. Een wijziging van financiële verplichtingen kan gevolgen hebben voor de mogelijkheden van leden om hun lidmaatschap te beëindigen; beoordeel dit aan de hand van de wet en de eigen statuten. [NOC*NSF – Opzegtermijn bij een sportvereniging](https://www.nocnsf.nl/handboek-wet-en-regelgeving/4-opzegtermijn)', '[{"label": "KVK – Bestuurder van een vereniging", "url": "https://www.kvk.nl/wetten-en-regels/bestuurder-van-een-vereniging-dit-zijn-de-regels-en-taken/"}, {"label": "NOC*NSF – Opzegtermijn bij een sportvereniging", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/4-opzegtermijn"}]', DATE '2027-09-19', 12, '6c7f028cb70f30be');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P03', 3, 'vraag', '3', 'Welke contributievormen zijn mogelijk?', '3. Welke contributievormen zijn mogelijk?', 'Een vereniging kan tarieven laten verschillen als dat past bij haar activiteiten en regels. Veelvoorkomende vormen zijn:

| **Vorm** | **Wanneer kan dit passen?** |
| --- | --- |
| Leeftijdstarief | Jeugdleden en volwassen leden gebruiken deels andere faciliteiten of de club wil jeugdsport toegankelijk houden. |
| Tarief per activiteit | Leden volgen verschillende aantallen trainingen of nemen deel aan verschillende competities. |
| Gezinstarief | Meerdere leden uit één huishouden sporten bij dezelfde vereniging. |
| Deeltijd- of recreantentarief | Een ledencategorie heeft een duidelijk andere deelnamevorm. |
| Vrijstelling of korting | Bijvoorbeeld voor ereleden of op basis van vastgelegd verenigingsbeleid. |
| Aanvullende bijdrage | Specifieke kosten, zoals kleding, een trainingskamp of competitie, worden apart in rekening gebracht. |

Houd de tariefstructuur begrijpelijk. Bij veel uitzonderingen wordt de ledenadministratie foutgevoeliger en is het voor leden lastig om te controleren wat zij moeten betalen.

Maak bij ieder tarief duidelijk wat inbegrepen is en wat apart wordt berekend. Vermeld ook hoe de contributie wordt bepaald bij instroom gedurende het seizoen. Leg kortingen en uitzonderingen schriftelijk vast, zodat vergelijkbare gevallen gelijk worden behandeld.', '[]', DATE '2027-09-19', 12, 'a07d471f35abc770');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P04', 4, 'vraag', '4', 'Hoe organiseer ik het versturen en innen van contributie?', '4. Hoe organiseer ik het versturen en innen van contributie?', 'Maak vóór de start van het seizoen een betaalplanning. Die bevat de tarieven, betaalmomenten, betaalmethoden en de persoon die de ledengegevens aanlevert.

Een praktisch proces verloopt zo:

- Controleer de ledenlijst. Zijn aanmeldingen, opzeggingen, leeftijden en ledencategorieën bijgewerkt?

- Bereken de verschuldigde bedragen. Gebruik de vastgestelde tarieven en leg uitzonderingen vast.

- Stuur een duidelijk betaalverzoek. Vermeld naam, periode, bedrag, vervaldatum, betaalwijze en contactpunt voor vragen.

- Verwerk betalingen. Koppel ontvangen bedragen aan het juiste lid en de juiste periode.

- Controleer openstaande posten. Zoek onduidelijke of ontbrekende betalingen uit voordat herinneringen worden verzonden.

- Rapporteer aan het bestuur. Meld hoeveel is gefactureerd, ontvangen en nog openstaat.

Stuur betaalverzoeken niet alleen op basis van de ledenlijst van vorig jaar. Een actuele ledenadministratie is de basis. Laat bij voorkeur een andere persoon de aanmeldingen en opzeggingen beheren, terwijl de penningmeester de contributiebedragen en ontvangsten controleert.

Controle op volledigheid: bereken hoeveel contributie je op basis van het aantal leden per categorie zou moeten ontvangen. Vergelijk dit met wat daadwerkelijk in rekening is gebracht. Daarmee kun je ontbrekende leden, verkeerde tarieven en onterechte vrijstellingen ontdekken.', '[]', DATE '2027-09-19', 12, '4facd6e095e28f74');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P05', 5, 'vraag', '5', 'Hoe werkt automatische incasso en waar moet ik op letten?', '5. Hoe werkt automatische incasso en waar moet ik op letten?', 'Bij automatische incasso geeft de betaler de vereniging toestemming om bedragen van een rekening af te schrijven. Daarvoor heeft de club een geldige machtiging en afspraken met de bank of betaaldienstverlener nodig. Een machtiging kan eenmalig of doorlopend zijn. [Betaalvereniging Nederland – Europese incasso](https://www.betaalvereniging.nl/kennisbank/ontvangen-van-betalingen/europese-incasso/)

Regel in ieder geval:

- een duidelijke machtiging op naam van de partij die incasseert;

- correcte rekeninggegevens en een herkenbare omschrijving;

- informatie aan leden over bedrag en incassomoment;

- veilige opslag van machtigingen en bankgegevens;

- controle op geweigerde of teruggeboekte incasso’s;

- een werkwijze voor het stoppen of aanpassen van de incasso na een wijziging in het lidmaatschap.

Een geslaagde incassorun betekent niet dat al het geld definitief binnen is. Bij een standaard Europese incasso kan een consument een afschrijving binnen acht weken terugboeken. Zonder geldige machtiging kan een afschrijving onder voorwaarden nog langer worden betwist. Controleer terugboekingen daarom ook ná de incassodatum. [Betaalvereniging Nederland – Europese incasso](https://www.betaalvereniging.nl/kennisbank/overboeken/europese-incasso/)

Een terugboeking betekent niet automatisch dat de contributieverplichting vervalt. Onderzoek eerst waarom is teruggeboekt: een verkeerd bedrag, een onduidelijke afschrijving, onvoldoende saldo of een discussie over het lidmaatschap vragen ieder om een andere reactie.', '[{"label": "Betaalvereniging Nederland – Europese incasso", "url": "https://www.betaalvereniging.nl/kennisbank/ontvangen-van-betalingen/europese-incasso/"}, {"label": "Betaalvereniging Nederland – Europese incasso", "url": "https://www.betaalvereniging.nl/kennisbank/overboeken/europese-incasso/"}]', DATE '2027-09-19', 12, '573e36a9d5503d4f');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P06', 6, 'vraag', '6', 'Wat doe ik bij een mislukte betaling of contributieachterstand?', '6. Wat doe ik bij een mislukte betaling of contributieachterstand?', 'Controleer eerst of er echt een achterstand is. Een betaling kan op een andere naam zijn gedaan, bij het verkeerde lid zijn geboekt of nog niet zijn verwerkt. Kijk ook of er een betalingsregeling of tegemoetkoming is afgesproken.

Als het bedrag inderdaad openstaat, werk dan in stappen:

- Stuur een vriendelijke herinnering met het bedrag en de betaalgegevens.

- Neem contact op als betaling uitblijft en vraag of er een vergissing of probleem is.

- Bevestig een eventuele betalingsafspraak schriftelijk.

- Volg de afgesproken termijnen en leg betalingen vast.

- Bespreek langdurige of grote achterstanden volgens het beleid van de vereniging.

Houd het contact feitelijk en vertrouwelijk. Coaches of teamgenoten hebben doorgaans geen overzicht van iemands financiële situatie nodig om hun taak te doen.

Neem maatregelen zoals het beperken van deelname of beëindigen van het lidmaatschap nooit automatisch op basis van een openstaand bedrag. Controleer welke mogelijkheden en procedure de statuten en reglementen bieden en laat het bevoegde orgaan beslissen. NOC*NSF beschrijft de regels rond beëindiging van het lidmaatschap afzonderlijk. [NOC*NSF – Einde van het lidmaatschap](https://www.nocnsf.nl/handboek-wet-en-regelgeving/4-einde-van-het-lidmaatschap)', '[{"label": "NOC*NSF – Einde van het lidmaatschap", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/4-einde-van-het-lidmaatschap"}]', DATE '2027-09-19', 12, '3019dd9b0ffa435b');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P07', 7, 'vraag', '7', 'Hoe ga ik om met leden die de contributie niet kunnen betalen?', '7. Hoe ga ik om met leden die de contributie niet kunnen betalen?', 'Maak het voor leden eenvoudig om vertrouwelijk contact op te nemen vóórdat een achterstand groot wordt. Bespreek welke oplossing past bij de situatie. Mogelijkheden zijn bijvoorbeeld:

- betalen in termijnen;

- tijdelijk uitstel;

- een korting of kwijtschelding volgens verenigingsbeleid;

- hulp via een gemeentelijke regeling of een fonds.

Leg vast wie over een uitzondering beslist, voor welke periode zij geldt en hoe zij in de administratie wordt verwerkt. Beperk de toegang tot persoonlijke informatie tot de mensen die deze nodig hebben.

Voor kinderen en jongeren kan het [Jeugdfonds Sport & Cultuur](https://jeugdfondssportencultuur.nl/voor-wie/voor-ouders/) in sommige situaties contributie of lesgeld rechtstreeks aan de club betalen. De voorwaarden en aanvraagroute kunnen per plaats verschillen. Controleer daarom de regeling die voor het betreffende lid beschikbaar is. Behandel toegankelijkheid ook als begrotingsonderwerp. Als de vereniging structureel ruimte wil bieden voor vermindering van contributie, neem dan een realistische raming daarvoor op in de begroting.', '[{"label": "Jeugdfonds Sport & Cultuur", "url": "https://jeugdfondssportencultuur.nl/voor-wie/voor-ouders/"}]', DATE '2027-09-19', 12, '9758eab556aae8af');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P08', 8, 'vraag', '8', 'Wanneer krijgt een lid contributie terug bij opzegging, blessure of seizoensonderbreking?', '8. Wanneer krijgt een lid contributie terug bij opzegging, blessure of seizoensonderbreking?', 'Ga niet alleen af op het moment waarop iemand stopt met sporten. Kijk eerst naar:

- De statuten: wanneer eindigt het lidmaatschap en welke contributie blijft verschuldigd?

- Het contributiebeleid: bestaat er een regeling voor tussentijdse instroom, blessure of bijzondere omstandigheden?

- Het concrete geval: welke periode is al betaald en welke kosten heeft de vereniging al gemaakt?

- Het bevoegde besluit: wie mag een uitzondering of restitutie goedkeuren?

Als uitgangspunt eindigt een verenigingslidmaatschap doorgaans aan het einde van het boekjaar, tenzij de statuten anders bepalen. Ook bij tussentijdse beëindiging kan contributie voor het hele jaar verschuldigd blijven, tenzij de statuten anders regelen. De regels voor een sportvereniging verschillen hierin van die voor een gewoon sportschoolabonnement. [NOC*NSF – Opzegtermijn bij een sportvereniging](https://www.nocnsf.nl/handboek-wet-en-regelgeving/4-opzegtermijn)

Een blessure leidt dus niet vanzelf tot terugbetaling. De vereniging kan daar wel een eigen regeling voor hebben. Leg zo’n regeling vooraf duidelijk uit aan leden en pas haar consequent toe.

Als er restitutie wordt toegekend, controleer dan of de oorspronkelijke contributie volledig is betaald. Verwerk de terugbetaling bij het juiste lid en boekjaar, en bewaar het besluit waarop zij berust.', '[{"label": "NOC*NSF – Opzegtermijn bij een sportvereniging", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/4-opzegtermijn"}]', DATE '2027-09-19', 12, '08bea09728d0ea03');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P09', 9, 'vraag', '9', 'Hoe stem ik ledenadministratie en financiële administratie op elkaar af?', '9. Hoe stem ik ledenadministratie en financiële administratie op elkaar af?', 'De ledenadministratie vertelt wie lid is en in welke categorie. De financiële administratie vertelt wat in rekening is gebracht, betaald of nog openstaat. Deze twee administraties moeten regelmatig op elkaar worden aangesloten.

Vergelijk bijvoorbeeld maandelijks of rond ieder contributiemoment:

- nieuwe leden en vertrokken leden;

- wijzigingen van leeftijds- of tariefcategorie;

- leden met korting of vrijstelling;

- verwachte contributie per categorie;

- verstuurde betaalverzoeken;

- ontvangen betalingen en openstaande bedragen.

Gebruik een uniek lidnummer of andere vaste verwijzing, zodat betalingen aan het juiste lid worden gekoppeld. Spreek af wie wijzigingen invoert en wanneer de penningmeester daarvan bericht krijgt.

Maak aan het einde van het jaar een aansluiting tussen de ledenlijst, de vastgestelde tarieven en de totale contributieopbrengst. Verklaar verschillen, zoals instroom tijdens het seizoen, kortingen, vooruitbetaalde contributie en nog openstaande bedragen. Dit helpt het bestuur bij de nieuwe begroting en maakt de jaarcontrole beter uitvoerbaar.', '[]', DATE '2027-09-19', 12, '88231e4d4a1c1182');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H04' AND versie = '1.0'), 'H04-P10', 10, 'checklist', NULL, 'Checklist: is het contributieproces op orde?', 'Checklist: is het contributieproces op orde?', '- De actuele contributietarieven en ingangsdatum zijn vastgelegd.

- Leden kunnen eenvoudig vinden wat zij moeten betalen en hoe zij kunnen opzeggen.

- De ledenadministratie is bijgewerkt vóór het versturen van betaalverzoeken.

- Kortingen en uitzonderingen hebben een vastgelegde grondslag en goedkeuring.

- Betalingen worden aan het juiste lid en de juiste periode gekoppeld.

- Machtigingen voor automatische incasso worden veilig bewaard.

- Mislukte en teruggeboekte incasso’s worden opgevolgd.

- Er is een vertrouwelijke route voor leden met betalingsproblemen.

- Restituties worden volgens de verenigingsregels beoordeeld en vastgelegd.

- De verwachte contributieopbrengst wordt vergeleken met de geboekte opbrengst.', '[]', DATE '2027-09-19', 12, 'ec9f919beea98888');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H04' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H04', 'Basisversie 1.0 geïmporteerd, 11 paragrafen, goedgekeurd door Paul Baans');

-- H05 – Overige inkomsten
INSERT INTO hoofdstuk (id, nummer) VALUES ('H05', 5);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H05', '1.0', 'concept', 'Overige inkomsten', 'Naast contributie kan een sportvereniging geld ontvangen uit sponsoring, subsidies, donaties, acties, evenementen, kantineverkoop en verhuur.', 'Hoofdstuk 5 — Overige inkomsten', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'Naast contributie kan een sportvereniging geld ontvangen uit sponsoring, subsidies, donaties, acties, evenementen, kantineverkoop en verhuur. Die inkomsten verschillen sterk van elkaar. Een subsidie kan aan een specifiek doel zijn verbonden, terwijl een sponsor juist een tegenprestatie verwacht. Kantineomzet brengt weer inkoopkosten met zich mee.

Houd daarom per inkomstenbron bij wat is afgesproken, wat al is ontvangen, welke kosten ertegenover staan en of het geld vrij te besteden is. Gebruik daarvoor de passende posten uit het rekenschema van hoofdstuk 2.', '[]', DATE '2027-09-19', 12, '99671ebb1ce97972');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P01', 1, 'vraag', '1', 'Welke inkomstenbronnen kan een sportvereniging naast contributie hebben?', '1. Welke inkomstenbronnen kan een sportvereniging naast contributie hebben?', 'Mogelijke inkomstenbronnen zijn:

| **Inkomstenbron** | **Voorbeelden** | **Belangrijkste aandachtspunt** |
| --- | --- | --- |
| Subsidies en fondsen | Bijdrage voor sportmateriaal, toegankelijkheid of accommodatie | Voorwaarden, termijnen en verantwoording |
| Sponsoring | Geld voor shirtreclame of een reclamebord | Afgesproken tegenprestatie |
| Donaties | Een gift van een lid, bedrijf of supporter | Is het werkelijk een gift zonder tegenprestatie? |
| Acties | Crowdfunding of verkoopactie | Opbrengst na aftrek van kosten |
| Evenementen | Toernooi, kamp of clubfeest | Begroting per activiteit en financiële afrekening |
| Kantine en verkoop | Eten, drinken en clubartikelen | Inkoop, voorraad, kas en btw |
| Verhuur of gebruik door derden | Veld, zaal of clubhuis | Toestemming, contract, kosten en btw |

Niet iedere bron past bij iedere vereniging. Een club zonder eigen accommodatie heeft bijvoorbeeld minder mogelijkheden voor verhuur. Kies inkomstenactiviteiten die passen bij de mensen en middelen die de vereniging beschikbaar heeft.

Maak in de begroting onderscheid tussen vaste of redelijk voorspelbare inkomsten en onzekere inkomsten. Reken een plan niet sluitend met een sponsorbijdrage waarover nog geen afspraak is gemaakt.', '[]', DATE '2027-09-19', 12, '33d684542b6aade9');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P02', 2, 'vraag', '2', 'Hoe vind en beoordeel ik subsidies die bij onze vereniging passen?', '2. Hoe vind en beoordeel ik subsidies die bij onze vereniging passen?', 'Begin bij het doel van de uitgave. Wil de club bijvoorbeeld sportmateriaal aanschaffen, de accommodatie verbeteren of meer mensen laten sporten? Zoek vervolgens naar regelingen van de gemeente, provincie, sportbond, fondsen of het Rijk die bij dat doel passen.

Beoordeel een regeling vóórdat je tijd in de aanvraag steekt. Controleer:

- of de vereniging en de activiteit in aanmerking komen;

- welke kosten worden vergoed en welke niet;

- of de aanvraag vóór of na de uitgave moet plaatsvinden;

- hoeveel eigen geld de club moet bijdragen;

- welke documenten en offertes nodig zijn;

- wanneer het besluit en de betaling worden verwacht;

- welke verplichtingen na toekenning blijven gelden.

Een voorbeeld van een landelijke regeling voor bepaalde kosten van sportaccommodaties en sportmaterialen is BOSA. Openstelling, budget en voorwaarden kunnen wijzigen. Controleer daarom altijd de actuele informatie bij [DUS-I – BOSA](https://www.dus-i.nl/subsidies/sport/stimulering-bouw-en-onderhoud-sportaccommodaties) voordat het bestuur een investering op de subsidie baseert.

Beslisregel voor de begroting: vermeld een aangevraagde subsidie als onzeker zolang er geen toekenningsbesluit is. Laat zien hoe de club de uitgave betaalt als de aanvraag wordt afgewezen of later wordt uitbetaald.', '[{"label": "DUS-I – BOSA", "url": "https://www.dus-i.nl/subsidies/sport/stimulering-bouw-en-onderhoud-sportaccommodaties"}]', DATE '2027-09-19', 12, 'a2b8ef5678eaf8a7');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P03', 3, 'vraag', '3', 'Hoe vraag ik subsidie aan en hoe verantwoord ik de besteding?', '3. Hoe vraag ik subsidie aan en hoe verantwoord ik de besteding?', 'Wijs één persoon aan die de aanvraag coördineert. De penningmeester levert de financiële informatie aan en bewaakt samen met de projectverantwoordelijke de voorwaarden.

Gebruik per subsidie een dossier met:

| **Vast te leggen** | **Waarom?** |
| --- | --- |
| Regeling en contactpersoon | Zodat duidelijk is welke voorwaarden gelden |
| Aanvraag en ingediende begroting | Om later te vergelijken met de uitvoering |
| Toekenningsbrief of beschikking | Hierin staan bedrag, periode en verplichtingen |
| Facturen en betaalbewijzen | Om de gemaakte kosten te onderbouwen |
| Activiteiten- of projectverslag | Om te laten zien wat is uitgevoerd |
| Deadlines voor meldingen en eindverantwoording | Om terugvordering door gemiste voorwaarden te voorkomen |

Boek de subsidie op een herkenbare post en houd de bijbehorende kosten afzonderlijk bij als de regeling dat vraagt. Een toekenning en een bankontvangst zijn niet hetzelfde: het geld kan later of in delen binnenkomen. Neem dat verschil ook mee in de liquiditeitsplanning.

Verandert het project, kost het minder dan gepland of wordt een voorwaarde mogelijk niet gehaald? Controleer de beschikking en neem tijdig contact op met de subsidieverstrekker. Wacht niet tot de eindverantwoording.

Voor de btw maakt het uit waarvoor een subsidie wordt verstrekt. Een algemene bijdrage voor een voorziening wordt anders behandeld dan een vergoeding voor een concrete levering of dienst. [Belastingdienst – Subsidies en giften](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/omzet-en-btw/subsidies-en-giften)', '[{"label": "Belastingdienst – Subsidies en giften", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/omzet-en-btw/subsidies-en-giften"}]', DATE '2027-09-19', 12, '7600ec05c1462439');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P04', 4, 'vraag', '4', 'Hoe leg ik afspraken met sponsors goed vast?', '4. Hoe leg ik afspraken met sponsors goed vast?', 'Sponsoring betekent meestal dat de club een bijdrage ontvangt en daar iets voor terugdoet, zoals een logo op kleding, een reclamebord of zichtbaarheid op de website. Leg afspraken schriftelijk vast, ook als de sponsor een bekende van de vereniging is. [NOC*NSF – Wat is sponsoring?](https://www.nocnsf.nl/handboek-wet-en-regelgeving/18-wat-is-sponsoring-precies)

Een sponsorovereenkomst vermeldt bij voorkeur:

- naam van de sponsor en van de vereniging;

- de bijdrage in geld of goederen;

- de precieze tegenprestatie van de club;

- begin- en einddatum;

- betaalmomenten;

- wie kleding, borden of andere materialen betaalt;

- wie zorgt voor plaatsing en verwijdering van reclame;

- wat gebeurt als een team, evenement of seizoen verandert;

- hoe en wanneer de overeenkomst eindigt.

Houd een sponsoroverzicht bij met de contractwaarde, gefactureerde bedragen, ontvangen betalingen en nog uit te voeren tegenprestaties. Zo voorkom je dat een verlenging of betaling wordt vergeten.

Bekijk ook of de sponsor past bij de uitstraling en afspraken van de club. Bij reclame kunnen aanvullende regels gelden, afhankelijk van het product, de doelgroep en de plek waar reclame zichtbaar is.', '[{"label": "NOC*NSF – Wat is sponsoring?", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/18-wat-is-sponsoring-precies"}]', DATE '2027-09-19', 12, 'a8395f297bde0c5a');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P05', 5, 'vraag', '5', 'Hoe verwerk ik sponsorbijdragen in geld of in natura?', '5. Hoe verwerk ik sponsorbijdragen in geld of in natura?', 'Bij een bijdrage in geld leg je het contract vast, stuur je zo nodig een factuur en controleer je de betaling. Bij een bijdrage in natura ontvangt de club bijvoorbeeld kleding, materialen of producten. Leg dan vast wat is geleverd, voor welk doel en welke reclame of andere prestatie de vereniging daarvoor levert.

Voorbeeld: een bedrijf levert trainingspakken in ruil voor zijn logo op de pakken. Dat is niet hetzelfde als een vrijblijvende gift. De club ontvangt goederen en levert een tegenprestatie. Laat bij twijfel beoordelen welke waarde en btw-behandeling voor beide prestaties moeten worden gebruikt.

Maak het onderscheid helder:

- Gift: er staat geen rechtstreekse tegenprestatie tegenover.

- Sponsoring: de vereniging levert wel een tegenprestatie, vaak reclame.

Dit onderscheid is ook voor de btw belangrijk. De Belastingdienst behandelt giften en sponsoring verschillend; voor fondsenwervende activiteiten kan onder voorwaarden een vrijstelling gelden. [Belastingdienst – Subsidies en giften](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/omzet-en-btw/subsidies-en-giften), [Belastingdienst – Fondsenwervende activiteiten](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/fondsenwervende_activiteiten/)', '[{"label": "Belastingdienst – Subsidies en giften", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/omzet-en-btw/subsidies-en-giften"}, {"label": "Belastingdienst – Fondsenwervende activiteiten", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/fondsenwervende_activiteiten/"}]', DATE '2027-09-19', 12, '6d7c61caa3feb23d');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P06', 6, 'vraag', '6', 'Hoe organiseer en registreer ik donaties en acties?', '6. Hoe organiseer en registreer ik donaties en acties?', 'Spreek vooraf af hoe donaties kunnen worden gedaan, wie ze registreert en wie de ontvangst bevestigt. Een bankbetaling met een duidelijke omschrijving is eenvoudiger te volgen dan contant geld. Leg vast of de gever een bestemming heeft genoemd, bijvoorbeeld voor de jeugdafdeling of voor nieuwe doelen. Rapporteer daarna hoe dat geld is gebruikt.

Maak voor een actie vooraf een kleine begroting:

Verwachte netto-opbrengst = verwachte ontvangsten − kosten van de actie

Neem ook betaal- en platformkosten, inkoop en eventuele prijzen mee. Tel na afloop de ontvangsten en uitgaven apart op en vergelijk ze met de verwachting.

Bij een loterij of bingo kunnen vergunningen of meldingen nodig zijn. Controleer dit vóór de aankondiging bij de gemeente en de [Kansspelautoriteit](https://kansspelautoriteit.nl/gemeenten-en-kansspelen). Veronderstel niet dat een actie zonder regels kan worden gehouden omdat de opbrengst naar de vereniging gaat.

Zeg tegen donateurs alleen dat hun gift fiscaal aftrekbaar is als dat voor de betreffende gift en vereniging is gecontroleerd. De voorwaarden daarvoor verschillen per situatie. [Belastingdienst – Giften aan een vereniging](https://www.belastingdienst.nl/wps/wcm/connect/nl/aftrek-en-kortingen/content/gift-aftrekken)', '[{"label": "Kansspelautoriteit", "url": "https://kansspelautoriteit.nl/gemeenten-en-kansspelen"}, {"label": "Belastingdienst – Giften aan een vereniging", "url": "https://www.belastingdienst.nl/wps/wcm/connect/nl/aftrek-en-kortingen/content/gift-aftrekken"}]', DATE '2027-09-19', 12, '5f742ffd61a5f5e5');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P07', 7, 'vraag', '7', 'Hoe bepaal ik of een evenement financieel iets oplevert?', '7. Hoe bepaal ik of een evenement financieel iets oplevert?', 'Maak voor ieder groter evenement een eigen begroting en afrekening. Neem alle inkomsten en kosten op, ook als verschillende commissies ze regelen.

| **Inkomsten** | **Kosten** |
| --- | --- |
| Deelnamegelden en kaartverkoop | Huur van locatie of materiaal |
| Evenementsponsoring | Inkoop van eten en drinken |
| Verkoopopbrengst | Prijzen, beveiliging en promotie |
| Eventuele subsidie | Betaalkosten, vergunningen en overige kosten |

Bereken na afloop het verschil tussen de werkelijke inkomsten en kosten. Controleer daarnaast of alle verkopen zijn ontvangen en alle facturen zijn verwerkt. Een evenement met veel bezoekers kan toch weinig opleveren als de kosten hoog zijn.

Maak vooraf ook een tegenvallerscenario. Hoeveel deelnemers zijn minimaal nodig om de kosten te dekken? Wie mag besluiten om het evenement door te laten gaan als de voorverkoop achterblijft?

Houd contant geld, pinbetalingen en eventuele online ticketverkoop afzonderlijk bij en sluit ze aan op de totale verkoopregistratie.', '[]', DATE '2027-09-19', 12, '8e3ca8a4f4080096');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P08', 8, 'vraag', '8', 'Hoe beheer ik de inkomsten uit kantine, verkoop of verhuur?', '8. Hoe beheer ik de inkomsten uit kantine, verkoop of verhuur?', 'Kantine en verkoop. Registreer niet alleen wat op de bank binnenkomt, maar ook de verkoop volgens de kassa of betaalterminal, contante ontvangsten, inkopen en voorraad. Spreek af wie telt, afstort en verschillen onderzoekt. Zo kun je naast de omzet ook beoordelen wat de verkoop daadwerkelijk oplevert.

Verhuur. Leg vast wie welke ruimte of faciliteit gebruikt, op welke data, tegen welke vergoeding en wie bijkomende kosten draagt. Controleer of de vereniging de ruimte mag verhuren of aan derden beschikbaar mag stellen. Maak ook afspraken over schade, schoonmaak, verzekering en annulering.

Btw. De fiscale behandeling kan per activiteit verschillen. Sportdiensten van een vereniging zonder winstoogmerk kunnen zijn vrijgesteld, terwijl bijvoorbeeld verkoop, reclame en bepaalde verhuuractiviteiten anders worden behandeld. Voor kantine en andere fondsenwervende activiteiten gelden eigen voorwaarden. Beoordeel de geldstromen daarom afzonderlijk in plaats van alle verenigingsinkomsten dezelfde btw-code te geven. [Belastingdienst – Sportorganisaties en sportclubs](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/sportorganisaties/vrijstelling_voor_sportorganisaties_en_sportclubs), [Belastingdienst – Fondsenwervende activiteiten](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/fondsenwervende_activiteiten/)', '[{"label": "Belastingdienst – Sportorganisaties en sportclubs", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/sportorganisaties/vrijstelling_voor_sportorganisaties_en_sportclubs"}, {"label": "Belastingdienst – Fondsenwervende activiteiten", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/fondsenwervende_activiteiten/"}]', DATE '2027-09-19', 12, '11ba9fbb1ff18981');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P09', 9, 'vraag', '9', 'Hoe voorkom ik dat de vereniging te afhankelijk wordt van één inkomstenbron?', '9. Hoe voorkom ik dat de vereniging te afhankelijk wordt van één inkomstenbron?', 'Maak jaarlijks een overzicht van de inkomsten per bron en vergelijk dat met eerdere jaren. Stel vervolgens de vraag: wat gebeurt er als een belangrijke bron volgend jaar wegvalt?

Een grote sponsorbijdrage kan een activiteit mogelijk maken, maar geeft ook een risico als de overeenkomst afloopt. Een subsidie voor een tijdelijk project is geen veilige basis voor kosten die ieder jaar terugkomen. En kantineopbrengsten kunnen veranderen door minder bezoekers of hogere inkoopkosten.

Bespreek daarom met het bestuur:

- welke inkomsten zeker zijn en welke tijdelijk of onzeker;

- welke vaste kosten afhankelijk zijn geworden van tijdelijke inkomsten;

- wanneer sponsor- en subsidieafspraken aflopen;

- of de vereniging voldoende buffer heeft om bij te sturen;

- welke activiteiten kunnen worden aangepast als inkomsten tegenvallen.

Het doel is niet om zoveel mogelijk verschillende inkomstenbronnen te hebben. Het doel is dat de vereniging begrijpt welke inkomsten nodig zijn voor haar vaste verplichtingen en welke ruimte er is voor extra plannen.', '[]', DATE '2027-09-19', 12, 'cc6be33e1c4d4105');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H05' AND versie = '1.0'), 'H05-P10', 10, 'checklist', NULL, 'Checklist: overige inkomsten', 'Checklist: overige inkomsten', '- Iedere inkomstenbron heeft een herkenbare post in de administratie.

- Toegezegde, gefactureerde en ontvangen bedragen worden onderscheiden.

- Subsidiebeschikkingen, voorwaarden en deadlines worden centraal bewaard.

- Sponsorafspraken en tegenprestaties zijn schriftelijk vastgelegd.

- Bij bijdragen in natura is duidelijk wat de club ontvangt en terugdoet.

- Donaties met een bestemming zijn afzonderlijk te volgen.

- Grotere acties en evenementen hebben een begroting én een afrekening.

- Kantineverkopen sluiten aan op kas, pin en voorraad.

- Verhuurafspraken zijn vastgelegd en toegestaan.

- De btw-behandeling is per soort activiteit beoordeeld.

- Het bestuur ziet welke inkomsten tijdelijk of onzeker zijn.', '[]', DATE '2027-09-19', 12, 'd71b529e8e93d631');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H05' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H05', 'Basisversie 1.0 geïmporteerd, 11 paragrafen, goedgekeurd door Paul Baans');

-- H06 – Uitgaven, inkopen en contracten
INSERT INTO hoofdstuk (id, nummer) VALUES ('H06', 6);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H06', '1.0', 'concept', 'Uitgaven, inkopen en contracten', 'Een uitgave begint vaak al voordat er een factuur binnenkomt.', 'Hoofdstuk 6 — Uitgaven, inkopen en contracten', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'Een uitgave begint vaak al voordat er een factuur binnenkomt. Iemand vraagt een offerte aan, bestelt materiaal of spreekt met een leverancier af dat een dienst volgend seizoen doorloopt. Op dat moment kan de vereniging al een financiële verplichting aangaan.

Goed kostenbeheer betekent daarom meer dan rekeningen op tijd betalen. Het bestuur moet weten welke kosten eraan komen, wie ze mag goedkeuren en wat de vereniging voor het geld krijgt. De penningmeester helpt dit overzicht te bewaren.', '[]', DATE '2027-09-19', 12, 'df935a4931a9d16b');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P01', 1, 'vraag', '1', 'Hoe krijg ik inzicht in alle vaste en variabele kosten?', '1. Hoe krijg ik inzicht in alle vaste en variabele kosten?', 'Gebruik de lastenposten uit het rekenschema van hoofdstuk 2 en vergelijk de kosten van de afgelopen jaren. Maak daarnaast een overzicht van lopende contracten en verplichtingen die nog niet volledig in de boekhouding zichtbaar zijn.

Verdeel de kosten voor de planning in drie groepen:

| **Groep** | **Voorbeelden** | **Waarop letten?** |
| --- | --- | --- |
| Terugkerende kosten | Huur, verzekeringen, software, bondsafdracht | Verlenging, prijswijziging en betaaldatum |
| Kosten die meebewegen | Wedstrijdballen, scheidsrechters, kantine-inkoop | Aantal leden, teams, wedstrijden en verkopen |
| Incidentele kosten | Verbouwing, nieuw materiaal, jubileum | Apart besluit en gevolgen voor toekomstige jaren |

Kijk niet alleen naar wat vorig jaar is betaald. Een factuur kan laat binnenkomen, een verzekering kan jaarlijks worden betaald en een contract kan een nieuwe prijs krijgen. Vergelijk daarom de boekhouding met contracten, begroting en plannen van commissies.

Maak voor het bestuur een kostenoverzicht waarin per belangrijke post de begroting, werkelijke kosten, nog verwachte kosten en verklaring van verschillen staan. Zo wordt zichtbaar of een overschrijding een eenmalige tegenvaller is of volgend jaar terugkomt.', '[]', DATE '2027-09-19', 12, '9555bb5abbc87cfc');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P02', 2, 'vraag', '2', 'Wie mag namens de vereniging iets bestellen of een contract afsluiten?', '2. Wie mag namens de vereniging iets bestellen of een contract afsluiten?', 'Controleer de statuten, het huishoudelijk reglement en de bestuursbesluiten. Maak vervolgens een praktische bevoegdhedenlijst: wie mag een aankoop aanvragen, wie mag de uitgave goedkeuren, wie mag namens de vereniging een contract tekenen en wie mag betalen?

Deze handelingen zijn verschillend. Een trainer kan materialen nodig hebben en de bestelling voorbereiden, zonder bevoegd te zijn om namens de vereniging een duur contract te sluiten. Ook banktoegang geeft niet vanzelf toestemming om een uitgave te besluiten.

Een werkafspraak kan bijvoorbeeld onderscheid maken tussen gewone uitgaven binnen een vastgesteld teambudget en grotere of nieuwe verplichtingen. De genoemde bedragen in zo’n afspraak zijn keuzes van de vereniging; er bestaat geen algemene bestedingsgrens die voor iedere penningmeester geldt.

Laat vóór ondertekening van een belangrijk contract controleren wie de vereniging mag vertegenwoordigen en of vooraf toestemming van bestuur of ALV nodig is. De statuten kunnen bevoegdheden en financiële grenzen bevatten. Voor bepaalde bijzondere overeenkomsten, bijvoorbeeld rond onroerend goed, gelden aanvullende regels. [KVK – De vereniging](https://www.kvk.nl/starten/de-vereniging/), [NOC*NSF – Bestuurstaak](https://www.nocnsf.nl/handboek-wet-en-regelgeving/5-bestuurstaak)

Leg een akkoord vast vóórdat de bestelling wordt geplaatst. Achteraf goedkeuren laat weinig ruimte over om nog een andere keuze te maken.', '[{"label": "KVK – De vereniging", "url": "https://www.kvk.nl/starten/de-vereniging/"}, {"label": "NOC*NSF – Bestuurstaak", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/5-bestuurstaak"}]', DATE '2027-09-19', 12, '57d7903123591bc0');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P03', 3, 'vraag', '3', 'Wanneer vragen we meerdere offertes aan?', '3. Wanneer vragen we meerdere offertes aan?', 'Meerdere offertes helpen bij uitgaven waarvan prijs, kwaliteit of voorwaarden moeilijk te beoordelen zijn. Denk aan onderhoud, kleding voor meerdere teams, een nieuw kassasysteem of een meerjarig dienstverleningscontract.

Spreek als bestuur af vanaf welke bedragen of bij welke soorten opdrachten je meerdere offertes vraagt. Er is voor een gewone sportvereniging geen universele grens die altijd past. Een bestaande leverancier kan voor een kleine, dringende reparatie logisch zijn; bij een grote verbouwing is een bredere vergelijking verstandig.

Zorg dat leveranciers dezelfde opdrachtomschrijving ontvangen. Vergelijk vervolgens niet alleen de prijs, maar ook:

- wat precies wordt geleverd;

- kwaliteit en verwachte levensduur;

- leverdatum;

- onderhoud en garantie;

- bijkomende kosten;

- betaalvoorwaarden;

- looptijd en beëindiging van de overeenkomst.

Reken waar nodig de totale kosten over meerdere jaren uit. Een goedkoop apparaat met een duur onderhoudscontract kan uiteindelijk meer kosten dan een duurder alternatief.

Leg de keuze kort vast, ook als niet de laagste offerte wint. Bijvoorbeeld: leverancier B is gekozen omdat de prijs onderhoud en vervangende apparatuur omvat. Heeft een bestuurder of vrijwilliger een persoonlijk belang bij een leverancier, bespreek dat dan vóór het besluit en volg de regels voor belangenconflicten. [KVK – Belangen die botsen bij bestuursbesluiten](https://www.kvk.nl/wetten-en-regels/stemmen-in-bestuur-van-vereniging-en-belangen-die-botsen/)', '[{"label": "KVK – Belangen die botsen bij bestuursbesluiten", "url": "https://www.kvk.nl/wetten-en-regels/stemmen-in-bestuur-van-vereniging-en-belangen-die-botsen/"}]', DATE '2027-09-19', 12, 'ea95df09c38cad57');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P04', 4, 'vraag', '4', 'Hoe beoordeel ik of een grote uitgave betaalbaar en verstandig is?', '4. Hoe beoordeel ik of een grote uitgave betaalbaar en verstandig is?', 'Beantwoord met het bestuur vier vragen:

- Waarom is de uitgave nodig? Welk probleem wordt opgelost of welk doel bereikt?

- Wat kost de keuze in totaal? Neem aanschaf, installatie, onderhoud, verzekering en vervanging mee.

- Wanneer moet worden betaald? Controleer de liquiditeitsplanning, niet alleen het jaarresultaat.

- Welke alternatieven zijn er? Denk aan repareren, huren, gefaseerd aanschaffen of uitstellen.

Een begrote uitgave is niet automatisch betaalbaar op het moment van bestellen. Subsidie of sponsoring kan later binnenkomen dan de factuur moet worden betaald. Maak bij een grote aankoop daarom ook een overzicht van de betaalmomenten.

Let op de btw in offertes. Voor activiteiten die van btw zijn vrijgesteld, kan de vereniging de btw op bijbehorende kosten doorgaans niet terugvragen. Vergelijk offertes daarom op de kosten die de vereniging werkelijk draagt, vaak inclusief btw. Bij gemengde activiteiten kan de behandeling ingewikkelder zijn. [Belastingdienst – Btw-vrijstellingen voor verenigingen](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/omzet-en-btw/btw-vrijstellingen)

Een grote aanschaf kan bovendien een investering zijn die in de jaarstukken over meerdere jaren wordt verwerkt. Dat verandert niets aan het feit dat de leverancier op de afgesproken datum betaald moet worden. Hoofdstuk 8 behandelt investeringen uitgebreider.', '[{"label": "Belastingdienst – Btw-vrijstellingen voor verenigingen", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/omzet-en-btw/btw-vrijstellingen"}]', DATE '2027-09-19', 12, '42ae3b32c5e124ac');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P05', 5, 'vraag', '5', 'Hoe controleer en betaal ik inkomende facturen?', '5. Hoe controleer en betaal ik inkomende facturen?', 'Gebruik een vaste route van ontvangst tot betaling:

| **Stap** | **Controlevraag** |
| --- | --- |
| Ontvangst | Is de factuur aan de vereniging gericht en is zij centraal terug te vinden? |
| Inhoud | Zijn goederen of diensten daadwerkelijk geleverd? |
| Afspraak | Kloppen prijs, aantallen en voorwaarden met offerte of contract? |
| Goedkeuring | Heeft de juiste persoon de uitgave goedgekeurd? |
| Dubbele betaling | Is dezelfde factuur al eerder ontvangen of betaald? |
| Betaalgegevens | Klopt het rekeningnummer met de bekende gegevens van de leverancier? |
| Boeking | Staat de factuur op de juiste post en in het juiste boekjaar? |
| Betaling | Is de overboeking uitgevoerd en aan de factuur gekoppeld? |

Bewaar de factuur met de bijbehorende goedkeuring. Voor verenigingen met btw-verplichtingen is een goed herleidbare registratie van ontvangen facturen ook van belang voor de btw-administratie. [Belastingdienst – Ontvangen facturen administreren](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/administratie_bijhouden/wat_administreert_u_voor_de_btw/ontvangen_facturen_administreren)

Bij een onjuiste factuur: neem contact op met de leverancier en vraag om correctie. Pas het bedrag op de ontvangen factuur niet zelf aan.', '[{"label": "Belastingdienst – Ontvangen facturen administreren", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/administratie_bijhouden/wat_administreert_u_voor_de_btw/ontvangen_facturen_administreren"}]', DATE '2027-09-19', 12, '15d747759bf071f6');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P06', 6, 'vraag', '6', 'Hoe leg ik afspraken met leveranciers, trainers en verhuurders vast?', '6. Hoe leg ik afspraken met leveranciers, trainers en verhuurders vast?', 'Bewaar per leverancier de ondertekende overeenkomst, offerte, opdrachtbevestiging en eventuele algemene voorwaarden op één vindbare plek. Leg daarnaast de belangrijkste gegevens vast in een contractenoverzicht:

| **Gegeven** | **Voorbeeld** |
| --- | --- |
| Leverancier en contactpersoon | Verhuurder sporthal |
| Wat levert de leverancier? | Gebruik zaal op dinsdagavond |
| Begin- en einddatum | Per sportseizoen |
| Prijs en prijsaanpassing | Bedrag per uur en jaarlijkse wijziging |
| Betaalmoment | Maandelijkse factuur |
| Opzegtermijn | Volgens contract |
| Verantwoordelijke binnen de club | Accommodatiebeheerder |
| Datum om contract te beoordelen | Ruim vóór de opzegdeadline |

Lees ook de voorwaarden buiten de prijsafspraak. Wie betaalt schade of extra schoonmaak? Wat gebeurt er als de activiteit uitvalt? Mag de prijs tussentijds wijzigen? Wordt het contract automatisch verlengd?

Bij afspraken met trainers is bovendien van belang welke werkrelatie de vereniging met hen heeft. De financiële en fiscale gevolgen daarvan horen bij hoofdstuk 7. Gebruik niet zonder beoordeling een gewone leveranciersovereenkomst voor iemand die feitelijk als werknemer werkt.

De mogelijkheden om een contract te beëindigen hangen onder meer af van de overeenkomst en toepasselijke voorwaarden. [KVK – Hoe je van een overeenkomst afkomt](https://www.kvk.nl/wetten-en-regels/hoe-je-van-een-overeenkomst-afkomt/)', '[{"label": "KVK – Hoe je van een overeenkomst afkomt", "url": "https://www.kvk.nl/wetten-en-regels/hoe-je-van-een-overeenkomst-afkomt/"}]', DATE '2027-09-19', 12, '52913fe850d40205');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P07', 7, 'vraag', '7', 'Hoe houd ik overzicht over lopende contracten en opzegtermijnen?', '7. Hoe houd ik overzicht over lopende contracten en opzegtermijnen?', 'Werk het contractenoverzicht bij zodra een overeenkomst wordt gesloten of gewijzigd. Zet een herinnering ruim vóór de datum waarop de vereniging moet besluiten over voortzetten of opzeggen. Als de opzegtermijn bijvoorbeeld drie maanden is, moet de beoordeling eerder plaatsvinden dan drie maanden voor het einde.

Controleer minstens één keer per jaar:

- gebruikt de vereniging de dienst nog?

- klopt de gefactureerde prijs met de overeenkomst?

- verandert de behoefte volgend seizoen?

- zijn er dubbele abonnementen of diensten?

- loopt er een tijdelijke korting af?

- is er een goedkoper of beter passend alternatief?

Stuur een opzegging of wijziging via de afgesproken route en bewaar een bevestiging. Een mondeling gesprek of een opmerking tijdens een bestuursvergadering beëindigt niet vanzelf een contract.', '[]', DATE '2027-09-19', 12, '73aba5e6485a9fbc');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P08', 8, 'vraag', '8', 'Hoe gaan we om met onverwachte uitgaven die niet in de begroting staan?', '8. Hoe gaan we om met onverwachte uitgaven die niet in de begroting staan?', 'Breng eerst de urgentie, totale kosten en beschikbare ruimte in beeld. Een kapotte verwarmingsinstallatie vraagt een ander besluit dan een wens voor extra trainingsmateriaal.

Volg daarna de bevoegdheden van de vereniging:

- Laat iemand vaststellen wat er nodig is en welke alternatieven bestaan.

- Controleer of er een reserve, verzekering, garantie of subsidie van toepassing kan zijn.

- Bereken het gevolg voor begroting en banksaldo.

- Vraag het vereiste akkoord van bestuur of ALV.

- Leg het besluit en de reden vast.

- Pas de verwachting voor de rest van het jaar aan.

Spreek vooraf af hoe het bestuur in een spoedsituatie bereikbaar is en wie dan mag handelen. Controleer ook in spoedgevallen achteraf de factuur en de uitvoering.

Meld een onverwachte uitgave bij de eerstvolgende financiële rapportage. Zo ziet het bestuur of andere plannen moeten worden aangepast.', '[]', DATE '2027-09-19', 12, '0e227e3703b3b2d0');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P09', 9, 'vraag', '9', 'Hoe kunnen we kosten besparen zonder de activiteiten van de club te schaden?', '9. Hoe kunnen we kosten besparen zonder de activiteiten van de club te schaden?', 'Begin bij kosten waar de club weinig voor terugkrijgt, zoals ongebruikte abonnementen, dubbele diensten, dure betaalmethoden of contracten die niet meer passen. Vergelijk daarnaast terugkerende tarieven en onderzoek of gezamenlijk inkopen met andere clubs zinvol is.
Beoordeel iedere besparing op het totale effect. Een goedkopere leverancier kan extra werk voor vrijwilligers veroorzaken of materiaal leveren dat sneller vervangen moet worden. Een korting op onderhoud kan later tot een veel grotere reparatie leiden.

Besparen is een bestuurskeuze. De penningmeester laat zien wat financieel mogelijk is; betrokken vrijwilligers en commissies beoordelen wat de keuze voor de sportactiviteiten betekent.', '[]', DATE '2027-09-19', 12, '88eaf420a758b70c');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P10', 10, 'voorbeeld', NULL, 'Praktisch voorbeeld: van aanvraag tot betaling', 'Praktisch voorbeeld: van aanvraag tot betaling', 'Een team wil voor € 1.200 aan trainingsmateriaal kopen.

- De teamverantwoordelijke beschrijft wat nodig is en vraagt offertes volgens de clubafspraken.

- De penningmeester controleert het beschikbare budget en de gevolgen voor het banksaldo.

- Het bevoegde bestuurslid of het bestuur kiest een aanbod en legt het akkoord vast.

- Een aangewezen persoon bevestigt na levering dat het materiaal compleet is.

- De penningmeester vergelijkt factuur, offerte en akkoord, boekt de factuur en bereidt de betaling voor.

- De betaling wordt volgens de bankafspraken goedgekeurd.

- Na betaling worden factuur en bankmutatie aan elkaar gekoppeld.

Zo is later duidelijk waarom de aankoop is gedaan, wie haar heeft goedgekeurd, wat is geleverd en wat is betaald.', '[]', DATE '2027-09-19', 12, '1719847021460efb');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H06' AND versie = '1.0'), 'H06-P11', 11, 'checklist', NULL, 'Checklist: uitgaven en contracten', 'Checklist: uitgaven en contracten', '- We hebben inzicht in terugkerende, meebewegende en incidentele kosten.

- Aankoop-, goedkeurings-, teken- en betaalbevoegdheden zijn vastgelegd.

- Voor grotere opdrachten vergelijken we offertes op totale kosten en kwaliteit.

- Bij grote uitgaven controleren we zowel begroting als liquiditeit.

- Facturen worden vergeleken met bestelling, levering en akkoord.

- Nieuwe of gewijzigde betaalgegevens van leveranciers worden extra gecontroleerd.

- Lopende contracten staan in een overzicht met een tijdige beoordelingsdatum.

- Onverwachte uitgaven worden volgens de juiste procedure besloten en gemeld.

- Het bestuur bekijkt jaarlijks waar kosten zonder verlies aan kwaliteit kunnen dalen.', '[]', DATE '2027-09-19', 12, '13853666a60cb6c2');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H06' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H06', 'Basisversie 1.0 geïmporteerd, 12 paragrafen, goedgekeurd door Paul Baans');

-- H07 – Vrijwilligers, trainers en personeel
INSERT INTO hoofdstuk (id, nummer) VALUES ('H07', 7);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H07', '1.0', 'concept', 'Vrijwilligers, trainers en personeel', 'Sportverenigingen werken met mensen die vrijwillig helpen, kosten voor de club voorschieten, tegen betaling trainingen geven of in dienst zijn.', 'Hoofdstuk 7 — Vrijwilligers, trainers en personeel', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'Sportverenigingen werken met mensen die vrijwillig helpen, kosten voor de club voorschieten, tegen betaling trainingen geven of in dienst zijn. Voor de penningmeester kunnen al deze betalingen op elkaar lijken. Toch maken het doel van de betaling en de manier waarop iemand werkt veel verschil.

Beoordeel daarom vóór de eerste betaling welke afspraak de vereniging met iemand heeft. Leg die afspraak vast en controleer gedurende het jaar of de betalingen ermee overeenkomen.', '[]', DATE '2027-09-19', 12, '84bc4f6815b96d1e');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P01', 1, 'vraag', '1', 'Wanneer kan iemand een vrijwilligersvergoeding ontvangen?', '1. Wanneer kan iemand een vrijwilligersvergoeding ontvangen?', 'Een vrijwilligersvergoeding is bedoeld voor iemand die het werk niet als beroep voor de vereniging doet en daarvoor geen marktconforme beloning ontvangt. Sportorganisaties kunnen onder voorwaarden de vrijwilligersregeling toepassen. De vereniging hoeft voor iemand die onder deze regeling valt geen loonaangifte te doen. [Belastingdienst – Vrijwilligersregeling](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling)

Voor 2026 noemt de Belastingdienst een grens van € 220 per maand én € 2.200 per kalenderjaar. Bij een vergoeding per uur of activiteit gebruikt de Belastingdienst ook bedragen om te beoordelen of de vergoeding niet marktconform is: € 5,75 per uur voor iemand van 21 jaar of ouder en € 3,40 per uur voor iemand jonger dan 21 jaar. Een hoger uurbedrag sluit de regeling niet in alle gevallen uit, maar vraagt een onderbouwing dat de vergoeding nog steeds niet marktconform is. [Belastingdienst – Vrijwilligersregeling](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling)

Let op het verschil tussen een kalenderjaar en een sportseizoen. Loopt een seizoen van augustus tot juni, dan controleer je de vergoedingen afzonderlijk voor de twee kalenderjaren. Betaalt de club één bedrag ineens, beoordeel dan ook op welke maanden het vrijwilligerswerk betrekking heeft.

Stel voor iedere vrijwilliger vast welke werkzaamheden worden gedaan, welke vergoeding is afgesproken en wie die afspraak heeft goedgekeurd. Kijk naar het totaal van alle vergoedingen van de vereniging aan dezelfde persoon.', '[{"label": "Belastingdienst – Vrijwilligersregeling", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling"}]', DATE '2027-09-19', 12, '9565ae92adedb630');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P02', 2, 'vraag', '2', 'Wat is het verschil tussen een vrijwilligersvergoeding en een vergoeding van gemaakte kosten?', '2. Wat is het verschil tussen een vrijwilligersvergoeding en een vergoeding van gemaakte kosten?', 'Een vrijwilligersvergoeding is een afgesproken tegemoetkoming voor iemands inzet. Een vergoeding van werkelijke kosten betaalt uitgaven terug die iemand voor het vrijwilligerswerk heeft gemaakt. Denk aan aantoonbare reiskosten. Daarnaast kan iemand iets voor de vereniging kopen, zoals sportmateriaal, en dat bedrag terugkrijgen.

Die situaties moet je uit elkaar houden:

| **Betaling** | **Voorbeeld** | **Wat leg je vast?** |
| --- | --- | --- |
| Vrijwilligersvergoeding | Een afgesproken bedrag per maand voor bardiensten | Afspraak, periode en betaald bedrag |
| Werkelijke onkosten | Aantoonbare reiskosten voor een taak | Doel, berekening en onderbouwing |
| Aankoop voor de club | Een vrijwilliger schiet wedstrijdballen voor | Bon of factuur, akkoord en terugbetaling |

De combinatie van een vrijwilligersvergoeding met onkostenvergoedingen of verstrekkingen in natura kan invloed hebben op de grensbedragen. Als iemand alleen werkelijke kosten vergoed krijgt, gelden de grensbedragen voor de vrijwilligersvergoeding volgens de Belastingdienst niet op dezelfde manier. Aankopen die een vrijwilliger namens de vereniging voorschiet en die de club terugbetaalt, tellen niet mee als vrijwilligersvergoeding. Controleer de voorwaarden zorgvuldig voordat je verschillende betalingen combineert. [Belastingdienst – Soorten vergoedingen en grensbedragen](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling)

Boek een aankoop voor de club op de passende kostenpost uit hoofdstuk 2, bijvoorbeeld materialen. Boek haar niet automatisch als vrijwilligersvergoeding omdat het geld toevallig aan een vrijwilliger is overgemaakt.', '[{"label": "Belastingdienst – Soorten vergoedingen en grensbedragen", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling"}]', DATE '2027-09-19', 12, '4f921b92b740f7a1');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P03', 3, 'vraag', '3', 'Hoe leg ik vergoedingen en declaraties goed vast?', '3. Hoe leg ik vergoedingen en declaraties goed vast?', 'Maak voor vergoedingen een overzicht per persoon en per kalenderjaar. Registreer daarin de betaalde bedragen, betaaldata, eventuele verstrekkingen in natura en afspraken over kosten. Zo kun je vóór een nieuwe betaling zien of een grens of afspraak in zicht komt.

Een declaratie bevat minimaal:

- naam van de persoon;

- datum en reden van de uitgave;

- bedrag en berekening;

- bon, factuur of andere passende onderbouwing;

- akkoord van de daarvoor aangewezen persoon;

- datum van terugbetaling.

Laat niemand zijn eigen vergoeding of declaratie als enige goedkeuren. Leg bij bestuursleden vast wie een betaling aan hen beoordeelt.

Verstrekkingen in natura kunnen ook meetellen. Een cadeau, maaltijd of vrijwilligersfeest is dus niet altijd administratief ‘gratis’ voor de ontvanger. De Belastingdienst beschrijft welke verstrekkingen voor de vrijwilligersregeling meetellen en hoe de waarde wordt bepaald. [Belastingdienst – Vrijwilligersregeling](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling)', '[{"label": "Belastingdienst – Vrijwilligersregeling", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling"}]', DATE '2027-09-19', 12, '83f54b59b5148aab');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P04', 4, 'vraag', '4', 'Wanneer is iemand vrijwilliger, zelfstandige of werknemer?', '4. Wanneer is iemand vrijwilliger, zelfstandige of werknemer?', 'De naam boven een contract of factuur beslist dit niet alleen. Kijk vooral naar wat is afgesproken en hoe het werk in de praktijk gebeurt.

| **Situatie** | **Kenmerkende vraag** |
| --- | --- |
| Vrijwilliger | Doet iemand het werk buiten zijn beroep en zonder marktconforme beloning? |
| Zelfstandige opdrachtnemer | Voert iemand een opdracht werkelijk zelfstandig uit en draagt die persoon ondernemersrisico? |
| Werknemer | Betaalt de club voor persoonlijke arbeid en kan zij bepalen hoe, waar of wanneer het werk gebeurt? |

Bij een arbeidsrelatie zijn alle feiten en omstandigheden van belang. De Belastingdienst noemt als kenmerken van loondienst onder meer beloning, persoonlijke arbeid en de mogelijkheid om instructies te geven. Vooral bij een betaalde trainer kan een dienstverband aan de orde zijn. [Belastingdienst – Vrijwilligers, personeel en loonheffingen](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/), [Belastingdienst – Wanneer is sprake van loondienst?](https://www.belastingdienst.nl/wps/wcm/connect/nl/arbeidsrelaties/content/wanneer-is-sprake-van-loondienst)

Een factuur van een zzp’er geeft dus niet vanzelf zekerheid dat de club geen werkgever is. Beoordeel de werkrelatie samen met de betrokken persoon vóór de opdracht begint en opnieuw als de werkzaamheden veranderen. De Belastingdienst biedt hiervoor uitleg en hulpmiddelen. [Belastingdienst – Arbeidsrelaties](https://www.belastingdienst.nl/wps/wcm/connect/nl/arbeidsrelaties/)', '[{"label": "Belastingdienst – Vrijwilligers, personeel en loonheffingen", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/"}, {"label": "Belastingdienst – Wanneer is sprake van loondienst?", "url": "https://www.belastingdienst.nl/wps/wcm/connect/nl/arbeidsrelaties/content/wanneer-is-sprake-van-loondienst"}, {"label": "Belastingdienst – Arbeidsrelaties", "url": "https://www.belastingdienst.nl/wps/wcm/connect/nl/arbeidsrelaties/"}]', DATE '2027-09-19', 12, '8df2c7797e4809af');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P05', 5, 'vraag', '5', 'Wat moet de vereniging regelen als zij personeel in dienst neemt?', '5. Wat moet de vereniging regelen als zij personeel in dienst neemt?', 'Als de vereniging werknemer van iemand wordt, moet zij meer regelen dan een maandelijkse betaling. Maak duidelijke afspraken over functie, uren, loon, looptijd en overige arbeidsvoorwaarden. Controleer ook of een cao van toepassing is.

Meld de vereniging tijdig aan als werkgever bij de Belastingdienst. Houd een loonadministratie bij en doe aangifte loonheffingen. De Belastingdienst geeft aan dat een vereniging zich bij de eerste werknemer uiterlijk moet aanmelden op de dag waarop die werknemer begint. [Belastingdienst – Aanmelden als werkgever](https://www.belastingdienst.nl/wps/wcm/connect/nl/personeel-en-loon/content/aanmelden-als-werkgever), [Belastingdienst – Loonaangifte doen](https://www.belastingdienst.nl/wps/wcm/connect/nl/personeel-en-loon/content/loonaangifte-aangifte-loonheffingen)

Neem in de planning ook verplichtingen mee die tijdens het dienstverband kunnen ontstaan, zoals vakantie, ziekte, pensioen of kosten bij beëindiging van het contract. Welke regels precies gelden, hangt af van de arbeidsrelatie en de toepasselijke afspraken. NOC*NSF geeft een overzicht van de onderwerpen waarmee een sportvereniging als werkgever te maken krijgt. [NOC*NSF – De sportvereniging als werkgever](https://www.nocnsf.nl/handboek-wet-en-regelgeving/10-de-sportvereniging-als-werkgever)

Laat de loonadministratie bij voorkeur uitvoeren of controleren door iemand met ervaring. Het bestuur blijft verantwoordelijk voor juiste en tijdige betalingen en aangiften.', '[{"label": "Belastingdienst – Aanmelden als werkgever", "url": "https://www.belastingdienst.nl/wps/wcm/connect/nl/personeel-en-loon/content/aanmelden-als-werkgever"}, {"label": "Belastingdienst – Loonaangifte doen", "url": "https://www.belastingdienst.nl/wps/wcm/connect/nl/personeel-en-loon/content/loonaangifte-aangifte-loonheffingen"}, {"label": "NOC*NSF – De sportvereniging als werkgever", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/10-de-sportvereniging-als-werkgever"}]', DATE '2027-09-19', 12, 'ec30944d2516a2d5');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P06', 6, 'vraag', '6', 'Hoe verwerk ik betalingen aan trainers, coaches en scheidsrechters?', '6. Hoe verwerk ik betalingen aan trainers, coaches en scheidsrechters?', 'Beoordeel iedere functie en afspraak afzonderlijk. Een trainer die wekelijks volgens een rooster werkt en instructies van de club volgt, kan in een andere situatie zitten dan een deskundige die zelfstandig één clinic verzorgt. Een scheidsrechter die incidenteel als vrijwilliger helpt, kan weer anders worden betaald.

Gebruik vóór de eerste betaling deze vragen:

- Wie geeft de opdracht en aan wie is de betaling verschuldigd?

- Welke werkzaamheden worden verricht en gedurende welke periode?

- Moet deze persoon het werk zelf doen?

- Wie bepaalt rooster, werkwijze en vervanging?

- Is de betaling een kostenvergoeding, een vrijwilligersvergoeding, loon of een vergoeding voor een zelfstandige opdracht?

- Welke gegevens, bewijsstukken en aangiften zijn nodig?

Leg het antwoord en de gekozen behandeling vast. Betaal een zelfstandige op basis van de afgesproken opdracht en factuur; betaal een werknemer via de loonadministratie. Volg bij een vrijwilliger de afspraken en controleer de vrijwilligersregeling.

Controleer bij officials of trainers die via een sportbond worden ingezet ook wie de opdrachtgever en betaler is. De club moet haar eigen betalingen juist verwerken, maar niet zonder aanleiding betalingen van een andere organisatie als eigen personeelskosten behandelen.', '[]', DATE '2027-09-19', 12, 'fa59fca109988f2e');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P07', 7, 'vraag', '7', 'Welke kosten horen bij personeel, naast het afgesproken loon?', '7. Welke kosten horen bij personeel, naast het afgesproken loon?', 'Het afgesproken brutoloon is niet hetzelfde als de totale kosten voor de vereniging. Maak bij een nieuwe functie een berekening waarin, voor zover van toepassing, ook staan:

- werkgeverslasten en loonheffingen;

- vakantiegeld en doorbetaalde vrije dagen;

- pensioenbijdragen;

- kosten bij ziekte en vervanging;

- opleidingen, materialen en werkkleding;

- administratie en ondersteuning bij salarisverwerking;

- verplichtingen uit een toepasselijke cao.

Controleer bij werknemers ook het actuele minimumloon. Dat bedrag kan gedurende het jaar veranderen en verschilt voor jongere werknemers naar leeftijd. [Rijksoverheid – Bedragen minimumloon 2026](https://www.rijksoverheid.nl/themas/werk/minimumloon/bedragen-minimumloon/bedragen-minimumloon-2026)

Begroot het hele jaar en de hele afspraak. Een trainer die alleen tijdens het sportseizoen aanwezig is, kan toch kosten of verplichtingen veroorzaken buiten de maanden waarin trainingen plaatsvinden. Laat het bestuur daarom de totale kosten en de gevolgen voor latere jaren zien voordat het een functie toezegt.', '[{"label": "Rijksoverheid – Bedragen minimumloon 2026", "url": "https://www.rijksoverheid.nl/themas/werk/minimumloon/bedragen-minimumloon/bedragen-minimumloon-2026"}]', DATE '2027-09-19', 12, '2ef601f90b16cae9');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P08', 8, 'vraag', '8', 'Welke afspraken maken we vooraf over vergoedingen en betaalmomenten?', '8. Welke afspraken maken we vooraf over vergoedingen en betaalmomenten?', 'Leg bij iedere betaalde of vergoede rol ten minste vast:

- welke werkzaamheden de persoon doet;

- op welke periode de afspraak betrekking heeft;

- welk bedrag of welke berekening geldt;

- welke kosten apart mogen worden gedeclareerd;

- welk bewijs daarvoor nodig is;

- wanneer betaling plaatsvindt;

- wie de werkzaamheden en de betaling goedkeurt;

- wat gebeurt bij afwezigheid, wijziging of beëindiging.

Gebruik afspraken die passen bij de werkelijke relatie. Een vrijwilligersafspraak is iets anders dan een arbeidsovereenkomst of een opdracht aan een zelfstandige.

Spreek bij vergoedingen per wedstrijd of activiteit af wie de daadwerkelijk verrichte activiteiten bevestigt. Bij maandelijkse betalingen controleer je of de afspraak nog geldt. Zo ontstaan er geen betalingen die blijven doorlopen nadat iemand is gestopt.', '[]', DATE '2027-09-19', 12, 'aebe60e44b135083');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P09', 9, 'vraag', '9', 'Wat doe ik als een betaling of vergoeding achteraf onjuist blijkt?', '9. Wat doe ik als een betaling of vergoeding achteraf onjuist blijkt?', 'Onderzoek eerst welke fout is gemaakt:

- Is het verkeerde bedrag betaald?

- Is er aan de verkeerde persoon betaald?

- Is een declaratie dubbel verwerkt?

- Is een grens van de vrijwilligersregeling overschreden?

- Is een betaalde kracht mogelijk als zelfstandige behandeld terwijl de werkrelatie op loondienst lijkt?

Bewaar de oorspronkelijke afspraak, betalingen en onderbouwing. Bereken daarna het juiste bedrag en leg vast welke correctie nodig is. Bespreek een mogelijke fiscale of arbeidsrechtelijke fout tijdig met een loonadministrateur of adviseur; alleen een boeking in de financiële administratie aanpassen lost zo’n fout niet altijd op.

Komt een vrijwilligersvergoeding boven de voorwaarden van de regeling uit, ga dan niet uit van de gedachte dat alleen het bedrag boven de grens aandacht nodig heeft. De gevolgen kunnen betrekking hebben op de gehele vergoeding en op eventuele aangifte- of informatieverplichtingen. Controleer de actuele uitleg van de Belastingdienst. [Belastingdienst – Vrijwilligersregeling](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling)

Informeer het bestuur over de fout, de financiële gevolgen en de gekozen oplossing. Pas ook het werkproces aan als dezelfde fout anders opnieuw kan ontstaan.', '[{"label": "Belastingdienst – Vrijwilligersregeling", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling"}]', DATE '2027-09-19', 12, 'dc7e2f8315271e5a');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H07' AND versie = '1.0'), 'H07-P10', 10, 'checklist', NULL, 'Checklist: betalingen aan mensen', 'Checklist: betalingen aan mensen', '- Voor iedere rol is vooraf beoordeeld of het gaat om vrijwilligerswerk, een zelfstandige opdracht of loondienst.

- Werkzaamheden, bedragen, declaraties en betaalmomenten zijn schriftelijk afgesproken.

- Vrijwilligersvergoedingen worden per persoon en per kalenderjaar gevolgd.

- Vergoedingen voor werkelijke kosten en aankopen voor de club zijn afzonderlijk herkenbaar.

- Niemand keurt uitsluitend zijn eigen betaling goed.

- De werkelijke werkwijze van ingehuurde zelfstandigen past bij de gemaakte afspraken.

- Voor werknemers zijn werkgeversregistratie, loonadministratie en aangiften geregeld.

- De begroting bevat de totale kosten van betaalde functies.

- Fouten en wijzigingen worden tijdig onderzocht en vastgelegd.

- Tijdgebonden grensbedragen worden ieder jaar opnieuw gecontroleerd.', '[]', DATE '2027-09-19', 12, 'a51a5c8df2acee1a');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H07' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H07', 'Basisversie 1.0 geïmporteerd, 11 paragrafen, goedgekeurd door Paul Baans');

-- H08 – Accommodatie, materiaal en investeringen
INSERT INTO hoofdstuk (id, nummer) VALUES ('H08', 8);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H08', '1.0', 'concept', 'Accommodatie, materiaal en investeringen', 'Een sportvereniging kan sporten in een gehuurde zaal, op gemeentelijke velden of in een eigen accommodatie.', 'Hoofdstuk 8 — Accommodatie, materiaal en investeringen', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'Een sportvereniging kan sporten in een gehuurde zaal, op gemeentelijke velden of in een eigen accommodatie. In alle gevallen krijgt de penningmeester te maken met gebruikskosten, onderhoud en de vervanging van materiaal. Dit hoofdstuk helpt om die uitgaven tijdig te plannen en grote besluiten financieel te onderbouwen.', '[]', DATE '2027-09-19', 12, 'd981a2e6bde680c3');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P01', 1, 'vraag', '8.1', 'Welke kosten horen bij het gebruik van een sportaccommodatie?', '8.1 Welke kosten horen bij het gebruik van een sportaccommodatie?', 'Begin met alle kosten die nodig zijn om de accommodatie te kunnen gebruiken. Denk aan huur of erfpacht, energie, water, schoonmaak, afval, beveiliging, verzekeringen en belastingen. Heeft de vereniging een eigen gebouw of terrein, neem dan ook onderhoud, keuringen en de toekomstige vervanging van onderdelen mee.

Maak in de begroting onderscheid tussen:

- Vaste kosten: bijvoorbeeld huur, verzekeringen en periodieke keuringen.

- Variabele kosten: bijvoorbeeld energie of schoonmaak die toenemen bij intensiever gebruik.

- Incidentele kosten: bijvoorbeeld een reparatie na schade.

- Geplande grote uitgaven: bijvoorbeeld vervanging van een dak, veld, vloer of verwarmingsinstallatie.

Een lage huurprijs zegt weinig over de totale kosten als de vereniging zelf het onderhoud, de energie of de inrichting betaalt. Lees daarom altijd het volledige contract en maak een overzicht van de kosten per seizoen én per jaar.', '[]', DATE '2027-09-19', 12, '047464dc48786015');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P02', 2, 'vraag', '8.2', 'Wat is financieel belangrijk bij huren, beheren of bezitten?', '8.2 Wat is financieel belangrijk bij huren, beheren of bezitten?', 'De eerste vraag is: wie is eigenaar van wat, en wie betaalt waarvoor? Een vereniging kan bijvoorbeeld een clubhuis bezitten terwijl de grond van de gemeente is. Ook kunnen inventaris, lichtmasten en velden verschillende eigenaren hebben.

Leg bij huur of gebruik in ieder geval vast:

| **Onderwerp** | **Vraag voor de penningmeester** |
| --- | --- |
| Looptijd en opzegging | Hoe lang geldt de overeenkomst en wanneer kan de prijs veranderen? |
| Onderhoud | Wie betaalt dagelijks onderhoud en wie betaalt grote reparaties? |
| Energie en heffingen | Wat zit in de huur en wat wordt apart afgerekend? |
| Investeringen | Mag de vereniging verbouwen en wat gebeurt er met die investering bij vertrek? |
| Schade en verzekering | Wie draagt welk risico? |
| Gebruik door anderen | Mag de vereniging ruimtes onderverhuren of delen? |

Bij eigendom komen daar de financiering, verzekerde waarde, technische staat en toekomstige vervanging bij. Controleer vóór aankoop of verbouwing ook de statuten en de bevoegdheid om namens de vereniging verplichtingen aan te gaan. Voor besluiten over onroerend goed kunnen specifieke regels gelden. [KVK](https://www.kvk.nl/starten/de-vereniging/) en [NOC*NSF](https://www.nocnsf.nl/handboek-wet-en-regelgeving/5-bestuurstaak) lichten de bestuurlijke bevoegdheden toe.', '[{"label": "KVK", "url": "https://www.kvk.nl/starten/de-vereniging/"}, {"label": "NOC*NSF", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/5-bestuurstaak"}]', DATE '2027-09-19', 12, 'cb0cbc90f89bbe51');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P03', 3, 'vraag', '8.3', 'Hoe begroten we onderhoud en vervanging van materiaal?', '8.3 Hoe begroten we onderhoud en vervanging van materiaal?', 'Werk met een meerjarenoverzicht. Noteer per belangrijk onderdeel de huidige staat, de verwachte onderhoudsdatum, de vervangingsdatum en een geschatte prijs. Denk aan sportvloeren, doelen, boten, toestellen, lichtinstallaties, computers en kantineapparatuur.

Een eenvoudig overzicht kan er zo uitzien:

| **Onderdeel** | **Verwachte uitgave** | **Jaar** | **Geschatte kosten** | **Wie is verantwoordelijk?** |
| --- | --- | --- | --- | --- |
| Sportvloer | Groot onderhoud | 2028 | € 8.000 | Vereniging |
| Trainingsmateriaal | Vervanging | 2029 | € 4.500 | Vereniging |
| Dak clubhuis | Vervanging | 2032 | € 35.000 | Volgens eigendomsafspraken |

Werk dit overzicht jaarlijks bij met nieuwe offertes en de bevindingen van de accommodatiebeheerder. Verdeel de verwachte uitgaven vervolgens over de jaren in de begroting. Zo wordt zichtbaar hoeveel ruimte de vereniging jaarlijks moet vrijhouden.

Let op: een bedrag binnen het eigen vermogen bestemmen voor toekomstig onderhoud betekent nog niet dat dit geld op de bank beschikbaar is. Controleer daarom ook de liquiditeitsplanning. De verwerking van een reserve of voorziening vraagt bovendien om een consistente keuze in de jaarrekening.', '[]', DATE '2027-09-19', 12, '213f54f3073e9e91');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P04', 4, 'vraag', '8.4', 'Hoe houden we bij welke bezittingen de vereniging heeft?', '8.4 Hoe houden we bij welke bezittingen de vereniging heeft?', 'Gebruik een inventaris- en activaregister naast de boekhouding. Daarmee weet het bestuur wat de vereniging bezit, waar het staat en wanneer het vermoedelijk vervangen moet worden.

Leg voor waardevolle bezittingen vast:

- omschrijving en eventuele serienummers;

- aanschafdatum, leverancier en aanschafprijs;

- locatie en verantwoordelijke beheerder;

- eigenaar, als het materiaal in bruikleen of huur is;

- verwachte gebruiksduur en vervangingsjaar;

- boekwaarde, als het bezit op de balans staat;

- verzekerde waarde en eventuele subsidievoorwaarden.

Controleer het register minimaal jaarlijks met de feitelijke inventaris. Werk het bij na aankoop, verkoop, schade of afvoer. Een apparaat dat volledig is afgeschreven, kan nog steeds aanwezig en bruikbaar zijn; laat het daarom niet automatisch uit de inventarislijst verdwijnen.', '[]', DATE '2027-09-19', 12, '218873497131c105');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P05', 5, 'vraag', '8.5', 'Wanneer is een aankoop een investering en hoe verwerken we die?', '8.5 Wanneer is een aankoop een investering en hoe verwerken we die?', 'Een aankoop is financieel een investering wanneer de vereniging er meerdere jaren gebruik van verwacht en het bedrag volgens haar gekozen administratieve uitgangspunten groot genoeg is om op de balans te zetten. De aankoop wordt dan niet volledig als kosten van één jaar verwerkt. De waarde komt eerst op de balans; via afschrijvingen worden de kosten over de gebruiksjaren verdeeld.

Voorbeeld: de vereniging koopt toestellen voor € 12.000. Zij verwacht deze zes jaar te gebruiken en rekent niet op een restwaarde. Bij lineair afschrijven bedraagt de jaarlijkse afschrijving € 2.000. De betaling van € 12.000 verlaat wel direct de bankrekening. Dat verschil tussen uitgave en jaarlijkse kosten is belangrijk voor zowel de begroting als de liquiditeitsplanning.

Leg vast vanaf welk bedrag de vereniging aankopen als investering behandelt, welke gebruiksduur zij per soort bezit hanteert en hoe zij afschrijft. Pas die uitgangspunten consequent toe en licht ze toe in de jaarrekening. Gewoon onderhoud is doorgaans een kostenpost van het betreffende jaar; een grote verbetering of uitbreiding kan een investering zijn. Laat de verwerking van omvangrijke gebouwenprojecten beoordelen door iemand met passende financiële deskundigheid.', '[]', DATE '2027-09-19', 12, 'd424d8fb63009983');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P06', 6, 'vraag', '8.6', 'Hoe beoordelen we of een investering financieel haalbaar is?', '8.6 Hoe beoordelen we of een investering financieel haalbaar is?', 'Maak vóór een besluit een korte investeringsbegroting. Kijk verder dan de aanschafprijs.

- Bepaal de volledige projectkosten. Neem ontwerp, vergunningen, installatie, inrichting, btw die de vereniging niet kan terugvragen en een bedrag voor tegenvallers mee.

- Bereken de toekomstige kosten. Denk aan onderhoud, energie, verzekering, rente en eventuele extra personeels- of vrijwilligerskosten.

- Maak een betaalplanning. Wanneer zijn aanbetalingen en eindfacturen verschuldigd? Wanneer komen subsidies of bijdragen binnen?

- Toets de gevolgen voor de vereniging. Kan zij na de investering haar gewone rekeningen blijven betalen? Wat gebeurt er als inkomsten lager uitvallen of kosten stijgen?

- Vergelijk alternatieven. Repareren, huren, delen of later aanschaffen kan financieel anders uitpakken dan direct kopen.

Een investering kan op papier betaalbaar lijken doordat de kosten over jaren worden afgeschreven, terwijl de vereniging vandaag onvoldoende geld heeft om de factuur te betalen. Leg daarom naast de begroting altijd een liquiditeitsprognose voor aan het bestuur.', '[]', DATE '2027-09-19', 12, '8732fdb2b02c9bde');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P07', 7, 'vraag', '8.7', 'Hoe financieren we een verbouwing of grote aanschaf?', '8.7 Hoe financieren we een verbouwing of grote aanschaf?', 'Mogelijke bronnen zijn eigen beschikbare middelen, een bijdrage van leden, sponsoring, een gemeentelijke regeling, een subsidie of een lening. Zorg dat de financiering past bij de gebruiksduur en het risico van het project.

Bij een lening gelden twee verschillende geldstromen: rente is een kostenpost en aflossing verlaagt de schuld. Beide kosten geld op de bankrekening. Neem dus de volledige jaarlijkse betaling op in de liquiditeitsprognose. Controleer daarnaast de looptijd, zekerheden, voorwaarden bij vervroegd aflossen en de bevoegdheid om de lening aan te gaan.

Voor bouw, onderhoud en sportmateriaal kan de [BOSA-regeling](https://www.dus-i.nl/subsidies/sport/stimulering-bouw-en-onderhoud-sportaccommodaties) relevant zijn. De voorwaarden en openstelling veranderen; het aanvraagportaal voor 2026 is volgens de uitvoerder gesloten. Neem een verwachte subsidie pas als zekere financiering mee wanneer de toekenning voldoende vaststaat. Bewaar offertes, facturen, betaalbewijzen en besluiten zorgvuldig.

Let ook op de btw. Diensten van sportverenigingen kunnen onder een btw-vrijstelling vallen; voor kosten die samenhangen met vrijgestelde activiteiten kan de vereniging de betaalde btw doorgaans niet aftrekken. Bij gemengd gebruik kan de beoordeling ingewikkelder zijn. Dit beïnvloedt de werkelijke investeringskosten en soms ook de subsidiemogelijkheden. Controleer dit vooraf aan de hand van de [uitleg van de Belastingdienst](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/sportorganisaties/vrijstelling_voor_sportorganisaties_en_sportclubs).

NOG MEER UITWERKEN', '[{"label": "BOSA-regeling", "url": "https://www.dus-i.nl/subsidies/sport/stimulering-bouw-en-onderhoud-sportaccommodaties"}, {"label": "uitleg van de Belastingdienst", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/sportorganisaties/vrijstelling_voor_sportorganisaties_en_sportclubs"}]', DATE '2027-09-19', 12, '9e04b289d62658cc');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P08', 8, 'vraag', '8.8', 'Welke afspraken zijn nodig bij gedeeld gebruik van een accommodatie?', '8.8 Welke afspraken zijn nodig bij gedeeld gebruik van een accommodatie?', 'Gebruiken meerdere verenigingen of andere partijen dezelfde locatie, leg de afspraken schriftelijk vast. Spreek af wie de planning beheert, wie toegang heeft en hoe huur, energie, schoonmaak en onderhoud worden verdeeld. Beschrijf ook wie betaalt bij schade en wie investeringen mag doen.

Laat de financiële afspraken aansluiten op de praktijk. Een verdeling van energiekosten op basis van gebruiksuren werkt bijvoorbeeld alleen als die uren betrouwbaar worden bijgehouden. Spreek af hoe vaak partijen afrekenen, welke gegevens zij delen en hoe zij de verdeelsleutel aanpassen wanneer het gebruik verandert. Controleer bij verhuur of exploitatie ook de btw-gevolgen.', '[]', DATE '2027-09-19', 12, 'f5be15d11e9b502f');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P09', 9, 'checklist', NULL, 'Praktische jaarcontrole voor de penningmeester', 'Praktische jaarcontrole voor de penningmeester', 'Loop jaarlijks samen met de accommodatiebeheerder of materiaalcommissie deze punten na:

- Kloppen huur- en gebruiksovereenkomsten nog?

- Zijn alle terugkerende kosten en prijsverhogingen in de begroting verwerkt?

- Is het onderhouds- en vervangingsoverzicht bijgewerkt?

- Komen het activaregister, de verzekering en de balans overeen?

- Zijn grote uitgaven en hun financiering tijdig aan het bestuur voorgelegd?

- Is er voldoende geld beschikbaar op de momenten waarop facturen betaald moeten worden?', '[]', DATE '2027-09-19', 12, '8335b8d706d05723');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H08' AND versie = '1.0'), 'H08-P10', 10, 'kern', NULL, 'Kern van dit hoofdstuk', NULL, 'Kern van dit hoofdstuk: breng bezit, contracten en toekomstige vervanging in één overzicht samen. Dan kan de vereniging op tijd reserveren, onderbouwde investeringsbesluiten nemen en onverwachte druk op de kas voorkomen.', '[]', DATE '2027-09-19', 12, 'af00324429490b70');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H08' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H08', 'Basisversie 1.0 geïmporteerd, 11 paragrafen, goedgekeurd door Paul Baans');

-- H09 – Belastingen en fiscale regelingen
INSERT INTO hoofdstuk (id, nummer) VALUES ('H09', 9);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H09', '1.0', 'concept', 'Belastingen en fiscale regelingen', 'Een sportvereniging heeft niet automatisch dezelfde belastingverplichtingen als een bedrijf.', 'Hoofdstuk 9 — Belastingen en fiscale regelingen', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'Een sportvereniging heeft niet automatisch dezelfde belastingverplichtingen als een bedrijf. De fiscale behandeling hangt af van wat de vereniging doet: sport aanbieden, eten en drinken verkopen, sponsors reclame bieden, mensen betalen of een accommodatie exploiteren. Beoordeel daarom iedere activiteit afzonderlijk en leg vast waarom een vrijstelling of belastingplicht van toepassing is.

Dit hoofdstuk beschrijft de Nederlandse regels. Controleer bedragen en voorwaarden ieder jaar opnieuw voordat je ze toepast.', '[]', DATE '2027-09-19', 12, '2a5f50bf2fdcf831');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P01', 1, 'vraag', '9.1', 'Met welke belastingen kan een sportvereniging te maken krijgen?', '9.1 Met welke belastingen kan een sportvereniging te maken krijgen?', 'Voor de meeste penningmeesters zijn drie belastingsoorten het belangrijkst:

| **Belasting** | **Wanneer kan deze spelen?** |
| --- | --- |
| Btw (omzetbelasting) | Bij verkoop, sponsoring, evenementen, verhuur en soms andere activiteiten. |
| Loonheffingen | Als de vereniging mensen in dienst heeft, bijvoorbeeld een trainer of beheerder. |
| Vennootschapsbelasting | Als de vereniging met bepaalde activiteiten een onderneming drijft of met ondernemers concurreert en geen vrijstelling geldt. |

Daarnaast kunnen bij een accommodatie lokale heffingen of belastingen in rekening worden gebracht. Controleer daarvoor de aanslagen en de afspraken met de eigenaar of verhuurder. Een vereniging kan voor de ene activiteit btw-vrijgesteld zijn en voor een andere activiteit btw moeten berekenen. Ook btw-plicht en vennootschapsbelastingplicht zijn afzonderlijke beoordelingen. [Belastingdienst – stichtingen en verenigingen](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen)

Praktische eerste stap: maak een lijst van alle inkomstenbronnen en alle soorten betalingen aan mensen. Noteer per onderdeel welke fiscale vraag nog moet worden beantwoord.', '[{"label": "Belastingdienst – stichtingen en verenigingen", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen"}]', DATE '2027-09-19', 12, 'b52251f923c834e9');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P02', 2, 'vraag', '9.2', 'Wanneer moet de vereniging btw berekenen of aangifte doen?', '9.2 Wanneer moet de vereniging btw berekenen of aangifte doen?', 'Veel diensten van een sportvereniging zonder winstoogmerk die nauw samenhangen met actieve sportbeoefening zijn vrijgesteld van btw. Denk aan trainingen en het gelegenheid geven om te sporten. De sportvrijstelling kan ook gelden voor diensten aan niet-leden. Over vrijgestelde prestaties brengt de vereniging geen btw in rekening. [Belastingdienst – sportvrijstelling](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/sportorganisaties/vrijstelling_voor_sportorganisaties_en_sportclubs)

Andere activiteiten kunnen wel belast zijn. Dat de vereniging geen winst wil maken, is op zichzelf geen reden om op een sponsorfactuur of kantineverkoop geen btw toe te passen. Voor bepaalde nevenactiviteiten bestaat een vrijstelling voor fondsenwerving, zolang aan de voorwaarden en omzetgrenzen wordt voldaan. De grenzen voor goederenleveringen en diensten worden afzonderlijk beoordeeld. Bij overschrijding kan de btw over de volledige omzet van de betreffende categorie in dat jaar verschuldigd worden. Volg die omzet dus gedurende het jaar, ook als de vereniging aanvankelijk onder de grens blijft. [Belastingdienst – fondsenwerving](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/fondsenwervende_activiteiten/maximum_omzet_fondsenwervende_activiteiten)

Heeft de vereniging uitsluitend vrijgestelde activiteiten, dan hoeft zij doorgaans geen reguliere btw-aangifte te doen. Er kunnen uitzonderingen zijn, bijvoorbeeld bij bepaalde aankopen uit het buitenland. Ontvangt de vereniging een uitnodiging tot aangifte, dien de aangifte dan altijd in, ook als er volgens de administratie niets te betalen is. [Belastingdienst – vrijgestelde prestaties](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/wat_moet_u_doen_als_u_vrijgestelde_goederen_of_diensten_levert)', '[{"label": "Belastingdienst – sportvrijstelling", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/sportorganisaties/vrijstelling_voor_sportorganisaties_en_sportclubs"}, {"label": "Belastingdienst – fondsenwerving", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/fondsenwervende_activiteiten/maximum_omzet_fondsenwervende_activiteiten"}, {"label": "Belastingdienst – vrijgestelde prestaties", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/tarieven_en_vrijstellingen/vrijstellingen/wat_moet_u_doen_als_u_vrijgestelde_goederen_of_diensten_levert"}]', DATE '2027-09-19', 12, '0a8243fd2ea8271e');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P03', 3, 'vraag', '9.3', 'Hoe beoordelen we de btw per activiteit?', '9.3 Hoe beoordelen we de btw per activiteit?', 'Gebruik bij iedere inkomstenbron dezelfde vragen: wat levert de vereniging, aan wie, en wat ontvangt zij daarvoor? De naam die op een factuur staat, is niet beslissend; de feitelijke afspraak telt.

| **Activiteit** | **Eerste aandachtspunt** |
| --- | --- |
| Contributie voor sportbeoefening | Beoordeel of de geleverde sportdienst onder de sportvrijstelling valt. |
| Sponsoring | Reclame of een andere tegenprestatie is een dienst. Controleer of de vrijstelling voor fondsenwerving geldt. |
| Kantine en clubartikelen | Dit zijn in beginsel goederenleveringen. Volg de toepasselijke voorwaarden en omzetgrens voor fondsenwerving. |
| Entree voor wedstrijden of evenementen | Beoordeel dit apart van deelname aan sport. Ook hier kan de fondsenwervende vrijstelling relevant zijn. |
| Gift of donatie | Als er geen rechtstreekse tegenprestatie is, is de gift in beginsel niet met btw belast. |
| Subsidie | Beoordeel of de vereniging in ruil voor het bedrag een concrete dienst of goederen levert. |
| Verhuur of gebruik van accommodatie | De btw-behandeling hangt af van de precieze prestatie en afspraken. |

Een sponsor die betaalt voor zijn logo op shirts ontvangt een tegenprestatie. Een bedrijf dat zonder tegenprestatie een bedrag schenkt, doet een gift. Een gemeentelijke bijdrage voor het onderhoud van velden is voor de btw iets anders dan een betaling per deelnemer aan een evenement. [Belastingdienst – subsidies en giften](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/omzet-en-btw/subsidies-en-giften)

Maak bij twijfel een korte beschrijving van de overeenkomst voordat je de fiscale behandeling bepaalt. Dat is vooral belangrijk bij sponsorbijdragen in natura, gezamenlijke evenementen en gedeeld accommodatiegebruik.', '[{"label": "Belastingdienst – subsidies en giften", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/omzet-en-btw/subsidies-en-giften"}]', DATE '2027-09-19', 12, '296cb19ce5e704b1');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P04', 4, 'vraag', '9.4', 'Wanneer mag de vereniging betaalde btw terugvragen?', '9.4 Wanneer mag de vereniging betaalde btw terugvragen?', 'De hoofdregel is: btw op kosten is alleen aftrekbaar voor zover die kosten worden gebruikt voor btw-belaste activiteiten. Voor kosten van vrijgestelde sportdiensten of vrijgestelde fondsenwerving is de btw niet aftrekbaar. Die niet-aftrekbare btw behoort dan tot de kosten van de vereniging. [Belastingdienst – btw-aftrek bij belaste en vrijgestelde omzet](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/btw_aftrekken/belaste_en_vrijgestelde_omzet/)

Een vereniging met zowel belaste als vrijgestelde activiteiten deelt haar inkopen daarom in drie groepen in:

- Alleen voor belaste activiteiten: de btw kan onder de gewone voorwaarden aftrekbaar zijn.

- Alleen voor vrijgestelde activiteiten: de btw is niet aftrekbaar.

- Voor beide soorten activiteiten: de btw moet volgens een onderbouwde methode worden verdeeld.

Voorbeeld: een vereniging verkoopt eten en drinken met btw, maar haar sportactiviteiten zijn vrijgesteld. De btw op inkopen voor de belaste kantineverkopen kan aftrekbaar zijn. De btw op trainingsmateriaal voor de vrijgestelde sportactiviteiten is dat niet. Bij gedeelde kosten, zoals energie voor het hele clubgebouw, moet de vereniging bepalen welk deel samenhangt met belaste activiteiten.

Vraag bij een grote verbouwing of aanschaf vóór het tekenen van de opdracht advies over de btw. Het gebruik van een gebouw kan veranderen en dat kan gevolgen hebben voor eerder toegepaste btw-aftrek.', '[{"label": "Belastingdienst – btw-aftrek bij belaste en vrijgestelde omzet", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/btw_aftrekken/belaste_en_vrijgestelde_omzet/"}]', DATE '2027-09-19', 12, '3555354b7f5ef5b7');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P05', 5, 'vraag', '9.5', 'Wat is de kleineondernemersregeling en wanneer is die relevant?', '9.5 Wat is de kleineondernemersregeling en wanneer is die relevant?', 'De kleineondernemersregeling (KOR) is een mogelijke btw-vrijstelling voor een vereniging die activiteiten verricht die anders met btw belast zouden zijn en die aan de voorwaarden voldoet. Deelname is een keuze. De KOR is iets anders dan de sportvrijstelling en de vrijstelling voor fondsenwerving. Bij deelname brengt de vereniging geen btw in rekening over de activiteiten waarop de KOR van toepassing is, maar kan zij ook de btw op bijbehorende kosten niet terugvragen. [Belastingdienst – KOR voor stichtingen en verenigingen](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/omzet-en-btw/de-kleineondernemersregeling)

Vergelijk vóór aanmelding ten minste de verwachte omzet, de btw die anders verschuldigd zou zijn en de btw op geplande uitgaven. Vooral bij een grote investering kan het verlies van aftrek financieel zwaar wegen. Controleer ook welke omzet meetelt voor de KOR-grens en vanaf wanneer deelname ingaat.', '[{"label": "Belastingdienst – KOR voor stichtingen en verenigingen", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/omzet-en-btw/de-kleineondernemersregeling"}]', DATE '2027-09-19', 12, 'ea1a47b66fb6f23d');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P06', 6, 'vraag', '9.6', 'Wanneer krijgt de vereniging te maken met loonheffingen?', '9.6 Wanneer krijgt de vereniging te maken met loonheffingen?', 'Neemt de vereniging iemand in dienst, dan moet zij zich als werkgever aanmelden en aangifte loonheffingen doen. Dit kan ook spelen bij een trainer die volgens het contract ‘zelfstandige’ heet: de feitelijke manier van werken is bepalend. De Belastingdienst kijkt onder meer naar betaling voor het werk, de mogelijkheid om aanwijzingen te geven en de verplichting om het werk persoonlijk te verrichten. [Belastingdienst – vrijwilligers, personeel en loonheffingen](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/)

Voor vrijwilligers kan onder voorwaarden de vrijwilligersregeling gelden. Dan is geen loonaangifte voor die vergoeding nodig. Controleer de voorwaarden en de geldende maand- en jaargrenzen per kalenderjaar. Houd vergoedingen en declaraties per persoon bij; alleen naar de afzonderlijke betaling kijken geeft onvoldoende overzicht. [Belastingdienst – vrijwilligersregeling](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling)

De praktische beoordeling van vrijwilligers, zelfstandigen en werknemers staat uitgebreider in hoofdstuk 7.', '[{"label": "Belastingdienst – vrijwilligers, personeel en loonheffingen", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/"}, {"label": "Belastingdienst – vrijwilligersregeling", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/bijzondere_regelingen/stichtingen_en_verenigingen/vrijwilligers-personeel-en-loonheffingen/vrijwilligersregeling"}]', DATE '2027-09-19', 12, 'cb2906034da42cc8');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P07', 7, 'vraag', '9.7', 'Wanneer kan vennootschapsbelasting relevant zijn?', '9.7 Wanneer kan vennootschapsbelasting relevant zijn?', 'Een vereniging kan vennootschapsbelastingplichtig zijn als zij met een activiteit een onderneming drijft of met ondernemers concurreert. De beoordeling kan per activiteit verschillen. Een overschot in de verenigingsjaarrekening betekent daarom niet automatisch dat vennootschapsbelasting verschuldigd is; omgekeerd sluit de verenigingsvorm belastingplicht niet uit. [Belastingdienst – belastingplicht van verenigingen](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/winst/vennootschapsbelasting/belastingplicht_en_aangifte/wanneer_moet_een_stichting_vereniging_of_vergelijkbare_organisatie_aangifte_doen/)

Voor verenigingen die een onderneming drijven, bestaat onder voorwaarden een vrijstelling bij beperkte fiscale winst. De fiscale winst is niet altijd gelijk aan het resultaat in de jaarrekening. Laat bij structurele commerciële activiteiten, sterk groeiende kantine- of evenementeninkomsten of twijfel over de vrijstelling de situatie beoordelen. Ontvangt de vereniging een uitnodiging voor aangifte vennootschapsbelasting, dan moet zij aangifte doen, ook als zij meent vrijgesteld te zijn. [Belastingdienst – vrijstelling vennootschapsbelasting](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/winst/vennootschapsbelasting/belastingplicht_en_aangifte/wanneer_moet_een_stichting_vereniging_of_vergelijkbare_organisatie_aangifte_doen/vrijstelling)', '[{"label": "Belastingdienst – belastingplicht van verenigingen", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/winst/vennootschapsbelasting/belastingplicht_en_aangifte/wanneer_moet_een_stichting_vereniging_of_vergelijkbare_organisatie_aangifte_doen/"}, {"label": "Belastingdienst – vrijstelling vennootschapsbelasting", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/winst/vennootschapsbelasting/belastingplicht_en_aangifte/wanneer_moet_een_stichting_vereniging_of_vergelijkbare_organisatie_aangifte_doen/vrijstelling"}]', DATE '2027-09-19', 12, '21047fa38309947d');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P08', 8, 'vraag', '9.8', 'Welke gegevens hebben we nodig voor aangiften en controles?', '9.8 Welke gegevens hebben we nodig voor aangiften en controles?', 'Richt de administratie zo in dat per activiteit is terug te vinden wat is ontvangen, welke kosten daarbij horen en welke fiscale behandeling is toegepast. Bewaar in ieder geval:

- verkoopfacturen, kassaregistraties en bankontvangsten;

- inkoopfacturen en betaalbewijzen;

- sponsorcontracten, subsidiebrieven en afspraken over giften;

- overzichten van kantineverkoop, evenementen en andere fondsenwervende activiteiten;

- contracten en betalingen aan trainers, werknemers en vrijwilligers;

- de onderbouwing van een verdeling van kosten en btw tussen belaste en vrijgestelde activiteiten;

- ingediende aangiften, aanslagen en correspondentie met de Belastingdienst.

Voor de fiscale administratie geldt in het algemeen een bewaartermijn van zeven jaar; voor gegevens over onroerende zaken en rechten daarop geldt tien jaar. De termijn begint niet altijd op de datum waarop een document is gemaakt: een lopend contract blijft eerst actueel. [Belastingdienst – administratie bewaren](https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/administratie_bijhouden/administratie_bewaren/)

Gebruik in de boekhouding afzonderlijke rubrieken voor bijvoorbeeld sportcontributie, sponsoring, kantine en giften. Dat maakt het volgen van de fondsenwervende omzetgrenzen en het voorbereiden van aangiften eenvoudiger.', '[{"label": "Belastingdienst – administratie bewaren", "url": "https://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/belastingdienst/zakelijk/btw/administratie_bijhouden/administratie_bewaren/"}]', DATE '2027-09-19', 12, 'e20719b645cc1aa8');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P09', 9, 'vraag', '9.9', 'Hoe houden we wijzigingen bij en wanneer vragen we hulp?', '9.9 Hoe houden we wijzigingen bij en wanneer vragen we hulp?', 'Maak een fiscale kalender met de aangiftetijdvakken, betaaldatums en een jaarlijks controlemoment. Loop bij het opstellen van de nieuwe begroting langs de officiële pagina’s van de Belastingdienst voor actuele grensbedragen en voorwaarden. Herbeoordeel de fiscale positie ook wanneer de vereniging een nieuwe inkomstenbron start, personeel aantrekt of in een accommodatie investeert.

Schakel een boekhouder of fiscalist in wanneer:

- de vereniging belaste én vrijgestelde activiteiten heeft en de btw op gedeelde kosten moet verdelen;

- een fondsenwervende omzetgrens in zicht komt of wordt overschreden;

- een grote verbouwing, vastgoedtransactie of subsidie fiscale gevolgen kan hebben;

- onduidelijk is of een betaalde trainer werknemer of zelfstandige is;

- commerciële activiteiten mogelijk tot vennootschapsbelastingplicht leiden;

- een aangifte of aanslag afwijkt van wat de vereniging verwacht.

Bereid zo’n gesprek voor met contracten, omzet per activiteit, relevante facturen en een beschrijving van hoe de vereniging daadwerkelijk werkt. Dan kan de adviseur een concrete beoordeling geven.', '[]', DATE '2027-09-19', 12, '79a623d0f3b35eec');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P10', 10, 'checklist', NULL, 'Jaarlijkse fiscale checklist', 'Jaarlijkse fiscale checklist', '- Alle inkomstenbronnen zijn afzonderlijk beoordeeld voor de btw.

- De omzet uit fondsenwervende goederen en diensten wordt gedurende het jaar gevolgd.

- Voor belaste en vrijgestelde activiteiten zijn de kosten en de btw-aftrek te onderscheiden.

- Vrijwilligersvergoedingen en betalingen aan trainers worden per persoon gevolgd.

- Ontvangen aangifteverzoeken zijn verwerkt, ook als de vereniging een vrijstelling verwacht.

- Nieuwe investeringen en contracten zijn vóór ondertekening fiscaal beoordeeld.

- De actuele regels en grensbedragen zijn gecontroleerd bij de Belastingdienst.

- De onderbouwing van gemaakte keuzes is samen met de administratie bewaard.', '[]', DATE '2027-09-19', 12, 'f98fb935ad60edd7');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H09' AND versie = '1.0'), 'H09-P11', 11, 'kern', NULL, 'Kern van dit hoofdstuk', NULL, 'Kern van dit hoofdstuk: bepaal belastingen per activiteit en per soort betaling. Een duidelijk onderscheid in de administratie helpt de vereniging vrijstellingen correct toe te passen, tijdig aangifte te doen en investeringen realistisch te begroten.', '[]', DATE '2027-09-19', 12, 'ebb169763b143d13');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H09' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H09', 'Basisversie 1.0 geïmporteerd, 12 paragrafen, goedgekeurd door Paul Baans');

-- H10 – Reserves, financiële risico’s en verzekeringen
INSERT INTO hoofdstuk (id, nummer) VALUES ('H10', 10);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H10', '1.0', 'concept', 'Reserves, financiële risico’s en verzekeringen', 'Een financieel gezonde sportvereniging kan haar gewone verplichtingen betalen én tegenvallers opvangen.', 'Hoofdstuk 10 — Reserves, financiële risico’s en verzekeringen', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'Een financieel gezonde sportvereniging kan haar gewone verplichtingen betalen én tegenvallers opvangen. Daarvoor heeft zij inzicht nodig in toekomstige uitgaven, een passende buffer en afspraken over risico’s. Verzekeringen kunnen grote schade beperken, maar vervangen goed financieel beheer niet.', '[]', DATE '2027-09-19', 12, '33e94356468478fa');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P01', 1, 'vraag', '10.1', 'Hoeveel geld moet de vereniging als buffer aanhouden?', '10.1 Hoeveel geld moet de vereniging als buffer aanhouden?', 'Er bestaat geen vast bedrag dat voor iedere sportvereniging passend is. Een club die een sportzaal huurt en vooral contributie ontvangt, loopt andere risico’s dan een vereniging met een eigen clubhuis, werknemers en wisselende sponsorinkomsten.

Bepaal de buffer in drie stappen:

- Breng de onvermijdelijke betalingen in beeld. Denk aan huur, bondskosten, lonen, verzekeringen en aflossingen.

- Schat realistische tegenvallers. Wat gebeurt er bij ledenverlies, een lagere subsidie, schade of een onverwachte reparatie?

- Bepaal hoeveel tijd nodig is om bij te sturen. Contributie verhogen of een huurcontract beëindigen kan meestal niet van de ene op de andere dag.

Leg vervolgens vast welk bedrag het bestuur als algemene buffer wil aanhouden en bespreek dit bij de begroting en jaarrekening met de leden. Herzie het bedrag als de activiteiten of verplichtingen veranderen. De aangeleverde Penningmeestergids benadrukt terecht dat de benodigde buffer afhangt van de risico’s en verplichtingen van de vereniging. 

Let op: een algemene reserve op de balans is niet automatisch geld dat direct op de bank beschikbaar is. Een deel van het vermogen kan vastzitten in een clubhuis of materiaal. Controleer daarom naast het eigen vermogen ook hoeveel geld de vereniging op korte termijn daadwerkelijk kan gebruiken.', '[]', DATE '2027-09-19', 12, '26b6e7994daae853');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P02', 2, 'vraag', '10.2', 'Voor welke toekomstige uitgaven maken we een aparte reserve?', '10.2 Voor welke toekomstige uitgaven maken we een aparte reserve?', 'Een aparte bestemmingsreserve helpt om zichtbaar te maken dat het bestuur geld wil aanhouden voor een concreet doel. Denk aan vervanging van een sportvloer, renovatie van kleedkamers of de aanschaf van kostbaar materiaal.

Leg bij iedere bestemmingsreserve vast:

| **Vraag** | **Voorbeeld** |
| --- | --- |
| Waarvoor is het bedrag bedoeld? | Vervanging van de sportvloer |
| Wanneer verwachten we de uitgave? | Over vier jaar |
| Wat gaat het naar verwachting kosten? | Gebaseerd op een actuele raming |
| Hoe bouwen we het bedrag op? | Jaarlijks volgens de meerjarenbegroting |
| Wie mag de bestemming wijzigen? | Volgens statuten en bestuurs- of ALV-besluit |

Een interne bestemmingsreserve blijft onderdeel van het eigen vermogen. Zij is iets anders dan een schuld of een boekhoudkundige voorziening. Ook kan een subsidieverstrekker voorwaarden verbinden aan geld dat de vereniging heeft ontvangen. Houd zulke externe verplichtingen afzonderlijk bij.

Voorbeeld: als over vier jaar naar verwachting € 20.000 nodig is voor een nieuwe vloer, kan de vereniging plannen om jaarlijks € 5.000 beschikbaar te houden. Controleer ieder jaar of die raming nog klopt én of het geld tegen de betaaldatum werkelijk beschikbaar zal zijn. De meerjarenplanning voor onderhoud en vervanging komt ook aan bod in hoofdstuk 8.', '[]', DATE '2027-09-19', 12, '7e53d6ba69931648');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P03', 3, 'vraag', '10.3', 'Hoe onderscheiden we vrij besteedbaar geld van geld met een bestemming?', '10.3 Hoe onderscheiden we vrij besteedbaar geld van geld met een bestemming?', 'Bekijk het banksaldo samen met de komende verplichtingen. Op de bank kan bijvoorbeeld € 45.000 staan, terwijl daarvan binnenkort € 12.000 nodig is voor huur en bondsafdrachten, € 8.000 moet worden besteed volgens een subsidiebeschikking en € 15.000 is gepland voor onderhoud. Het volledige banksaldo is dan niet vrij voor een nieuw project.

Maak hiervoor een kort overzicht:

Banksaldo + verwachte ontvangsten − openstaande rekeningen − komende vaste betalingen − bedragen met een afgesproken bestemming = voorlopig beschikbare ruimte.

Dat is een hulpmiddel voor besluitvorming, geen vervanging van de balans of liquiditeitsplanning. Neem ook de timing mee: een subsidie die pas na afloop van een project wordt betaald, kan vandaag geen factuur financieren.

Vermeld in de toelichting op de jaarrekening welke reserves er zijn, waarvoor zij dienen en hoe hun standen zijn veranderd. Zo kunnen bestuur, kascommissie en leden beoordelen welke ruimte de vereniging echt heeft.', '[]', DATE '2027-09-19', 12, '0c864dc4f7b72c46');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P04', 4, 'vraag', '10.4', 'Welke financiële risico’s loopt onze vereniging?', '10.4 Welke financiële risico’s loopt onze vereniging?', 'Maak jaarlijks met het bestuur een korte risico-inventarisatie. Veelvoorkomende risico’s zijn:

- Inkomsten: ledenverlies, contributieachterstanden of wegvallende subsidies en sponsors.

- Kosten: stijgende huur, energieprijzen of loonkosten.

- Accommodatie en materiaal: schade, groot onderhoud of vervanging eerder dan gepland.

- Verplichtingen: langdurige contracten, leningen en betalingen aan werknemers.

- Administratie: fouten, dubbele betalingen, verlies van gegevens of misbruik van banktoegang.

- Aansprakelijkheid: schade of letsel waarvoor de vereniging mogelijk verantwoordelijk wordt gehouden.

Gebruik per risico vier vragen: Hoe waarschijnlijk is het? Wat kan het kosten? Hoe kunnen we de kans verkleinen? Hoe betalen we de schade als het toch gebeurt? Die laatste vraag kan leiden tot een buffer, een verzekering of een aanpassing van de activiteit.

| **Risico** | **Mogelijk gevolg** | **Maatregel** | **Wie volgt dit op?** |
| --- | --- | --- | --- |
| Wegvallen hoofdsponsor | Minder inkomsten volgend seizoen | Alternatieve inkomsten zoeken en uitgaven tijdig aanpassen | Bestuur |
| Schade aan clubhuis | Grote herstelkosten | Onderhoud en polisdekking controleren | Accommodatiebeheerder |
| Onjuiste betaling | Geldverlies en herstelwerk | Betaalrechten beperken en bankmutaties laten nakijken | Penningmeester en tweede bestuurslid |

Een eenvoudig overzicht is voldoende:', '[]', DATE '2027-09-19', 12, 'ba3c5606cb58e1e9');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P05', 5, 'vraag', '10.5', 'Hoe verkleinen we de kans op fouten, misbruik of fraude?', '10.5 Hoe verkleinen we de kans op fouten, misbruik of fraude?', 'Zorg dat betalingen controleerbaar zijn. Leg vast wie een aankoop mag goedkeuren, wie de betaling klaarzet en wie de bankmutaties achteraf bekijkt. Pas betaal- en wijzigingslimieten toe die passen bij de omvang van de vereniging.

Praktische maatregelen zijn:

- laat een tweede bestuurslid regelmatig de bankmutaties rechtstreeks inzien;

- controleer bij een nieuw of gewijzigd rekeningnummer de wijziging via een bekend contactkanaal;

- betaal facturen op basis van een controleerbaar bewijsstuk en een akkoord van de juiste persoon;

- vergelijk bank, boekhouding en eventuele contante kas periodiek;

- geef bestuurders eigen toegangsrechten en trek rechten van vertrokken vrijwilligers tijdig in;

- laat de kascommissie beschikken over de stukken die zij voor haar controle nodig heeft.

De twee aangeleverde gidsen leggen nadruk op onafhankelijke inzage in bankmutaties, duidelijke betaalbevoegdheden en controle van betalingen aan de hand van bewijsstukken. 

De controle moet ook bij een kleine club uitvoerbaar zijn. Spreek liever een eenvoudige controle af die iedere maand echt plaatsvindt dan een uitgebreide procedure die niemand volgt.', '[]', DATE '2027-09-19', 12, '925646c0f9e1e8e1');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P06', 6, 'vraag', '10.6', 'Wat doen we bij een onverklaarde of mogelijk ongeoorloofde betaling?', '10.6 Wat doen we bij een onverklaarde of mogelijk ongeoorloofde betaling?', 'Behandel een afwijking eerst als een feit dat onderzocht moet worden. Een verkeerd bedrag kan een vergissing, een dubbele betaling of misbruik zijn.

- Leg vast wat is opgevallen. Noteer datum, bedrag, rekeningnummer en welke stukken ontbreken of afwijken.

- Controleer de onderbouwing. Zoek de factuur, declaratie, goedkeuring en eventuele correspondentie.

- Voorkom verdere schade. Neem bij een mogelijk onbevoegde bankbetaling direct contact op met de bank en laat toegangsrechten zo nodig aanpassen.

- Informeer het bestuur zorgvuldig. Betrek personen die onafhankelijk van de betaling kunnen handelen. Beschuldig niemand voordat de feiten zijn vastgesteld.

- Beslis over vervolg en herstel. Denk aan terugvordering, correctie van de administratie, melding bij de verzekeraar of nader onderzoek. Vraag bij een ernstig vermoeden van fraude juridisch advies over de vervolgstappen.

Bewaar de oorspronkelijke gegevens en noteer wie welke beslissing heeft genomen. Laat degene op wie de twijfel betrekking heeft niet als enige het onderzoek of de herstelbetaling afhandelen.', '[]', DATE '2027-09-19', 12, '06325d50f65c5cf3');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P07', 7, 'vraag', '10.7', 'Welke verzekeringen zijn voor onze vereniging relevant?', '10.7 Welke verzekeringen zijn voor onze vereniging relevant?', 'Begin bij de risico’s van de eigen club en controleer daarna welke dekking al via de sportbond, gemeente, verhuurder of een bestaande polis bestaat. [NOC*NSF](https://www.nocnsf.nl/handboek-wet-en-regelgeving/3-verzekeringen) adviseert verenigingen om per risico te beoordelen of zij de financiële gevolgen zelf kunnen dragen en of een verzekering die gevolgen daadwerkelijk dekt.

| **Verzekering** | **Welk risico onderzoekt de vereniging?** |
| --- | --- |
| Aansprakelijkheidsverzekering | Schade aan anderen door activiteiten van de vereniging. |
| Bestuurdersaansprakelijkheidsverzekering | Bepaalde aanspraken wegens bestuurlijke fouten; dekking en uitsluitingen verschillen. |
| Opstalverzekering | Schade aan een gebouw dat de vereniging bezit of waarvoor zij volgens afspraken het risico draagt. |
| Inventaris- of inboedelverzekering | Schade aan materiaal, apparatuur en inrichting. |
| Vrijwilligers- of ongevallenverzekering | Bepaalde gevolgen van ongevallen of schade rond vrijwilligersactiviteiten. |
| Evenementenverzekering | Specifieke risico’s van een groot evenement die bestaande polissen niet dekken. |
| Rechtsbijstandverzekering | Juridische hulp bij bepaalde geschillen. |

Dit is een controlelijst, geen advies om alle polissen af te sluiten. Kijk onder meer naar het verzekerd bedrag, eigen risico, uitsluitingen, gedekte activiteiten en wie als verzekerde geldt. Een bestuurdersaansprakelijkheidsverzekering dekt bijvoorbeeld niet vanzelf opzet of fraude. [NOC*NSF – verzekeringen](https://www.nocnsf.nl/handboek-wet-en-regelgeving/3-verzekeringen)', '[{"label": "NOC*NSF", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/3-verzekeringen"}]', DATE '2027-09-19', 12, '5cf31b8c19a9dab2');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P08', 8, 'vraag', '10.8', 'Hoe beoordelen we of een verzekering nog past?', '10.8 Hoe beoordelen we of een verzekering nog past?', 'Controleer de verzekeringen minimaal één keer per jaar en ook na een belangrijke verandering, zoals een verbouwing, nieuwe sportactiviteit, extra evenement of uitbreiding met personeel.

Loop per polis deze vragen na:

- Wat is verzekerd? Zijn gebouw, inventaris, activiteiten en betrokken personen juist omschreven?

- Voor welk bedrag? Sluit de verzekerde waarde nog aan bij mogelijke herstel- of vervangingskosten?

- Wat is uitgesloten? Zijn er situaties waarvoor de club zelf de schade moet dragen?

- Welke voorwaarden gelden? Denk aan onderhoud, beveiliging of tijdig melden van schade.

- Is er overlap? Biedt de sportbond of gemeente al een collectieve verzekering?

- Wie meldt schade en wanneer? Leg vast wie de verzekeraar benadert en welke gegevens nodig zijn.

Bewaar polissen, verlengingsdata en contactgegevens op een plek die ook voor een tweede bestuurslid bereikbaar is. Controleer na een verbouwing de verzekerde waarde opnieuw. [NOC*NSF – beheer van de verzekeringsportefeuille](https://www.nocnsf.nl/handboek-wet-en-regelgeving/3-verzekeringen)', '[{"label": "NOC*NSF – beheer van de verzekeringsportefeuille", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/3-verzekeringen"}]', DATE '2027-09-19', 12, '3e58c9b3425d957b');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P09', 9, 'vraag', '10.9', 'Wat doen we als de vereniging structureel geld tekortkomt?', '10.9 Wat doen we als de vereniging structureel geld tekortkomt?', 'Maak eerst onderscheid tussen een tijdelijk tekort aan geld en een structureel tekort in de exploitatie. Bij een tijdelijk tekort komen ontvangsten later binnen dan betalingen. Bij een structureel tekort zijn de gewone inkomsten onvoldoende om de terugkerende kosten te dragen. Een reserve kan tijd geven om bij te sturen, maar lost een structureel tekort niet op.

Werk met het bestuur een herstelplan uit:

- Maak een actuele liquiditeitsplanning en stel vast welke betalingen wanneer verschuldigd zijn.

- Zoek de oorzaak: minder leden, te lage contributie, gestegen kosten of een activiteit die jaarlijks verlies maakt.

- Bepaal welke uitgaven kunnen worden uitgesteld en welke verplichtingen contractueel vastliggen.

- Vergelijk haalbare maatregelen, zoals kosten beperken, activiteiten aanpassen, nieuwe inkomsten zoeken of een contributievoorstel.

- Leg per maatregel vast wie beslist, wanneer deze ingaat en wat het verwachte financiële effect is.

- Informeer de leden en vraag de ALV om een besluit wanneer de statuten of de aard van de maatregel dat vereisen.

Wacht bij dreigende betalingsproblemen niet tot de jaarrekening. Bespreek ze meteen in het bestuur en zoek tijdig deskundige hulp als de vereniging haar verplichtingen mogelijk niet kan nakomen.', '[]', DATE '2027-09-19', 12, 'f46588d84b21360b');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P10', 10, 'checklist', NULL, 'Jaarlijkse controle voor de penningmeester', 'Jaarlijkse controle voor de penningmeester', '- De hoogte van de algemene buffer is gekoppeld aan actuele risico’s en verplichtingen.

- Voor grote toekomstige uitgaven bestaat een bijgewerkt meerjarenoverzicht.

- Het bestuur weet welk deel van het geld op korte termijn beschikbaar is.

- De belangrijkste risico’s en maatregelen hebben een eigenaar.

- Een tweede persoon controleert de bankmutaties.

- Verzekerde waarden, activiteiten, uitsluitingen en collectieve dekking zijn nagekeken.

- De liquiditeitsplanning laat ook een tegenvallend scenario zien.

- Bestuur en leden krijgen een duidelijke toelichting op reserves en financiële risico’s.', '[]', DATE '2027-09-19', 12, '300fc1e9ca875dcc');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H10' AND versie = '1.0'), 'H10-P11', 11, 'kern', NULL, 'Kern van dit hoofdstuk', NULL, 'Kern van dit hoofdstuk: kies een buffer op basis van de risico’s van de eigen vereniging, plan grote uitgaven vooruit en controleer of geld werkelijk beschikbaar is. Beperk risico’s met heldere afspraken en gebruik verzekeringen voor schade die de vereniging niet zelf kan dragen.', '[]', DATE '2027-09-19', 12, 'f614f58914fcbbea');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H10' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H10', 'Basisversie 1.0 geïmporteerd, 12 paragrafen, goedgekeurd door Paul Baans');

-- H11 – ALV, kascommissie en financiële verantwoording
INSERT INTO hoofdstuk (id, nummer) VALUES ('H11', 11);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H11', '1.0', 'concept', 'ALV, kascommissie en financiële verantwoording', 'De penningmeester houdt de cijfers bij, maar het bestuur als geheel legt verantwoording af aan de leden.', 'Hoofdstuk 11 — ALV, kascommissie en financiële verantwoording', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'De penningmeester houdt de cijfers bij, maar het bestuur als geheel legt verantwoording af aan de leden. De algemene ledenvergadering (ALV) beoordeelt de financiële stukken en kan vragen stellen over het gevoerde beleid. De kascommissie onderzoekt de financiële stukken namens de leden en brengt daarover verslag uit.', '[]', DATE '2027-09-19', 12, 'bb5ba3759bd82051');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P01', 1, 'vraag', '11.1', 'Welke financiële stukken presenteren we aan de ALV?', '11.1 Welke financiële stukken presenteren we aan de ALV?', 'Voor een gewone vereniging legt het bestuur jaarlijks de balans en de staat van baten en lasten met toelichting ter goedkeuring voor aan de ALV. Het bestuur brengt ook verslag uit over de gang van zaken en het gevoerde beleid. Volgens de wet gebeurt dit binnen zes maanden na afloop van het boekjaar, tenzij de ALV de termijn verlengt. Controleer daarnaast de statuten: die kunnen aanvullende afspraken bevatten. [Burgerlijk Wetboek, Boek 2, artikel 48](https://wetten.overheid.nl/BWBR0003045/)

Geef de leden voor een begrijpelijke bespreking bij voorkeur ook:

- de begroting van het afgelopen jaar naast de werkelijke cijfers;

- de cijfers van het voorgaande jaar;

- een toelichting op belangrijke verschillen, schulden en reserves;

- de begroting voor het komende jaar, als deze volgens de statuten of verenigingsafspraken door de ALV wordt behandeld;

- het verslag van de kascommissie.

Stuur de stukken tijdig mee met de vergaderinformatie of maak duidelijk waar leden ze kunnen inzien. De penningmeester bereidt de uitleg voor, maar laat het bestuur de stukken vooraf samen bespreken en vaststellen als bestuursvoorstel.', '[{"label": "Burgerlijk Wetboek, Boek 2, artikel 48", "url": "https://wetten.overheid.nl/BWBR0003045/"}]', DATE '2027-09-19', 12, '229f830e50a580dd');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P02', 2, 'vraag', '11.2', 'Hoe leg ik de jaarstukken begrijpelijk uit?', '11.2 Hoe leg ik de jaarstukken begrijpelijk uit?', 'Begin bij de vragen die leden meestal hebben: Wat kwam er binnen? Waaraan is het geld besteed? Staat de vereniging er financieel goed voor? Wat betekent dit voor volgend seizoen?

Een korte toelichting kan deze volgorde volgen:

- Resultaat: wat is het overschot of tekort van het jaar?

- Belangrijkste oorzaken: welke inkomsten of kosten weken duidelijk af van de begroting?

- Balans: hoeveel geld, bezittingen, vorderingen en schulden heeft de vereniging?

- Beschikbare middelen: welke grote betalingen komen eraan en welk deel van het geld heeft al een bestemming?

- Vooruitblik: welke financiële keuzes vraagt het komende jaar?

Leg termen meteen uit. Bijvoorbeeld: “We sluiten het jaar af met een overschot van € 4.000. Dat betekent niet dat we € 4.000 extra kunnen uitgeven: een deel van de ontvangen contributie is nodig voor kosten aan het begin van volgend seizoen.”

Gebruik een eenvoudige tabel of grafiek als die de hoofdlijn verduidelijkt. Laat kleine boekingsdetails in de bijlage; leden kunnen er tijdens de vergadering wel naar vragen.', '[]', DATE '2027-09-19', 12, '267227a67fd1d22d');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P03', 3, 'vraag', '11.3', 'Hoe beantwoord ik vragen over tekorten, overschotten en reserves?', '11.3 Hoe beantwoord ik vragen over tekorten, overschotten en reserves?', 'Geef eerst de oorzaak, daarna de gevolgen en ten slotte het voorstel van het bestuur.

| **Vraag van leden** | **Wat licht je toe?** |
| --- | --- |
| Waarom is er een tekort? | Welke inkomsten vielen tegen of welke kosten waren hoger dan gepland? Was dit eenmalig of structureel? |
| Wat doen we met een overschot? | Welk deel is nodig voor komende verplichtingen, een buffer of een gepland project? |
| Waarom heeft de vereniging reserves? | Voor welk risico of toekomstig doel is het bedrag bestemd? |
| Kunnen we de contributie verlagen? | Wat betekent dit voor de begroting en liquiditeit in de komende jaren? |

Vergelijk niet alleen met het vorige jaar, maar ook met de goedgekeurde begroting. Als bijvoorbeeld de energiekosten sterk stegen, vermeld dan de stijging en de maatregelen voor het volgende jaar. Verberg een terugkerend tekort niet achter een eenmalige subsidie of een vrijval uit een reserve.

Een reserve is een post in het eigen vermogen; zij is niet automatisch gelijk aan vrij beschikbaar banksaldo. Dit onderscheid kwam aan bod in hoofdstuk 10.', '[]', DATE '2027-09-19', 12, '0f75a0db18f496d5');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P04', 4, 'vraag', '11.4', 'Wat doet de kascommissie?', '11.4 Wat doet de kascommissie?', 'Als er geen raad van commissarissen is en geen accountantsverklaring over de getrouwheid van de stukken aan de ALV wordt overgelegd, benoemt de ALV jaarlijks een commissie van ten minste twee leden die geen bestuurslid zijn. De commissie onderzoekt de financiële stukken en brengt verslag uit aan de ALV. Het bestuur moet haar de gevraagde informatie geven en boeken, bewijsstukken en andere gegevensdragers voor inzage beschikbaar stellen. [Burgerlijk Wetboek, Boek 2, artikel 48 lid 2](https://wetten.overheid.nl/BWBR0003045/)

De commissie kijkt onder meer of de gepresenteerde cijfers aansluiten op de administratie, of belangrijke bezittingen en schulden goed zijn weergegeven en of de toelichting voldoende duidelijk is. Zij bepaalt zelf welke controles nodig zijn. De kascommissie stelt de jaarstukken niet op en verleent geen decharge; dat zijn taken van respectievelijk het bestuur en de ALV.

De aangeleverde Kascommissiegids geeft praktische voorbeelden van controles op ontvangsten, betalingen, balansposten en de toelichting bij de jaarstukken. ', '[{"label": "Burgerlijk Wetboek, Boek 2, artikel 48 lid 2", "url": "https://wetten.overheid.nl/BWBR0003045/"}]', DATE '2027-09-19', 12, 'e90355c73dcad049');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P05', 5, 'vraag', '11.5', 'Hoe bereiden we de controle door de kascommissie voor?', '11.5 Hoe bereiden we de controle door de kascommissie voor?', 'Maak direct na het boekjaar een planning met de commissie. Spreek af wanneer het concept van de jaarstukken klaar is, wanneer de commissie de stukken krijgt en wanneer haar vragen beantwoord moeten zijn. Plan voldoende tijd om fouten nog vóór verzending aan de leden te herstellen.

Zorg dat ten minste het volgende beschikbaar is:

- balans, staat van baten en lasten, begroting en toelichting;

- volledige boekhouding en bankafschriften;

- facturen, declaraties en onderbouwing van ontvangsten;

- een overzicht van openstaande contributie en facturen;

- een specificatie van bezittingen, schulden en reserves;

- relevante contracten, subsidieafspraken en bestuursbesluiten;

- een verklaring van opvallende verschillen met begroting en vorig jaar.

Laat de commissie waar mogelijk de bankinformatie en andere oorspronkelijke gegevens raadplegen, in plaats van uitsluitend een door de penningmeester gemaakte samenvatting. Beantwoord vragen feitelijk en leg eventuele correcties vast. In de Penningmeestergids en Kascommissiegids wordt een tijdige, complete overdracht van de financiële stukken als belangrijke voorwaarde voor een goede controle beschreven. ', '[]', DATE '2027-09-19', 12, 'c3687ee716ee4722');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P06', 6, 'vraag', '11.6', 'Wat doen we met bevindingen van de kascommissie?', '11.6 Wat doen we met bevindingen van de kascommissie?', 'Maak onderscheid tussen fouten in de jaarstukken, onduidelijkheden en aanbevelingen voor de werkwijze.

- Fout in de cijfers: onderzoek de oorzaak, corrigeer de administratie en pas zo nodig de conceptstukken aan.

- Onduidelijke toelichting: vul de uitleg aan, zodat leden de cijfers kunnen beoordelen.

- Aanbeveling voor betere controle: bespreek in het bestuur wat wordt ingevoerd, wie dit doet en wanneer.

Bespreek belangrijke punten met de commissie vóór de ALV. De commissie behoudt haar eigen oordeel en rapporteert zelf aan de leden. Als zij onvoldoende informatie krijgt of een belangrijk verschil onopgelost blijft, moet dat duidelijk worden in haar verslag. [Burgerlijk Wetboek, Boek 2, artikel 48 lid 2](https://wetten.overheid.nl/BWBR0003045/)

Houd een korte actielijst bij. Daardoor kan het bestuur bij de volgende ALV laten zien wat met eerdere aanbevelingen is gedaan.', '[{"label": "Burgerlijk Wetboek, Boek 2, artikel 48 lid 2", "url": "https://wetten.overheid.nl/BWBR0003045/"}]', DATE '2027-09-19', 12, '47624ac1d7d1b8cd');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P07', 7, 'vraag', '11.7', 'Over welke financiële onderwerpen moet de ALV besluiten?', '11.7 Over welke financiële onderwerpen moet de ALV besluiten?', 'De ALV behandelt in elk geval de jaarlijkse financiële verantwoording die het bestuur volgens de wet voorlegt. Welke andere besluiten aan de leden zijn voorbehouden, volgt uit de wet, statuten en reglementen. Denk afhankelijk van de vereniging aan de begroting, contributie, grote investeringen of het gebruik van reserves. Zet elk besluitpunt afzonderlijk en helder op de agenda. [Burgerlijk Wetboek, Boek 2, artikelen 40 en 48](https://wetten.overheid.nl/BWBR0003045/)

Maak vooral onderscheid tussen:

- Goedkeuring van de financiële stukken: de leden beoordelen de verantwoording over het afgelopen jaar.

- Besluit over een voorstel voor de toekomst: bijvoorbeeld een contributiewijziging of investering.

- Decharge van het bestuur: een afzonderlijk oordeel over de verantwoording van het bestuur.

Goedkeuring van cijfers is niet vanzelf hetzelfde als decharge. Als het bestuur de ALV om decharge vraagt, zet dit dan uitdrukkelijk op de agenda en leg het besluit apart vast. [KVK – regels en taken van een verenigingsbestuurder](https://www.kvk.nl/wetten-en-regels/bestuurder-van-een-vereniging-dit-zijn-de-regels-en-taken/)', '[{"label": "Burgerlijk Wetboek, Boek 2, artikelen 40 en 48", "url": "https://wetten.overheid.nl/BWBR0003045/"}, {"label": "KVK – regels en taken van een verenigingsbestuurder", "url": "https://www.kvk.nl/wetten-en-regels/bestuurder-van-een-vereniging-dit-zijn-de-regels-en-taken/"}]', DATE '2027-09-19', 12, '5ebf87b1794091ed');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P08', 8, 'vraag', '11.8', 'Hoe leggen we financiële besluiten en goedkeuringen vast?', '11.8 Hoe leggen we financiële besluiten en goedkeuringen vast?', 'Formuleer vóór de vergadering precies waarover gestemd wordt. Bij een investering is “akkoord met renovatie” te vaag. Beschrijf liever het project, het maximale bedrag, de financieringsbron, eventuele voorwaarden en wie het bestuur machtigt om verplichtingen aan te gaan.

Neem in de notulen op:

- de tekst of duidelijke strekking van het voorstel;

- de uitslag van de stemming volgens de statutaire regels;

- voorwaarden of grenzen die de ALV heeft gesteld;

- wie het besluit uitvoert;

- bij jaarstukken: welke versie is goedgekeurd;

- het afzonderlijke besluit over decharge, als dit op de agenda stond.

Bewaar de vastgestelde stukken en het verslag van de kascommissie bij de notulen. Zo is later terug te vinden wat de leden daadwerkelijk hebben beoordeeld en besloten.', '[]', DATE '2027-09-19', 12, 'b48a497d91cc59e9');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P09', 9, 'vraag', '11.9', 'Hoe informeren we leden gedurende het jaar?', '11.9 Hoe informeren we leden gedurende het jaar?', 'Een ALV hoeft niet het eerste moment te zijn waarop leden horen dat de vereniging financieel moet bijsturen. Deel tussentijds een korte, begrijpelijke update wanneer belangrijke zaken veranderen, bijvoorbeeld bij een grote investering, een onverwacht tekort of een voorstel om de contributie aan te passen.

Beantwoord in zo’n update drie vragen: Wat is er veranderd? Wat betekent dit voor de vereniging? Welke beslissing of vervolgstap komt eraan? Vermeld bedragen en tijdstippen waar die bekend zijn. Als de uitkomst nog onzeker is, zeg dan wat nog moet worden onderzocht en wanneer leden nieuwe informatie krijgen.

Stem de informatie af met het bestuur en deel geen persoonsgegevens of vertrouwelijke contractdetails die leden niet nodig hebben om de financiële situatie te begrijpen. Regelmatige uitleg maakt het eenvoudiger voor leden om tijdens de ALV gerichte vragen te stellen.', '[]', DATE '2027-09-19', 12, 'd56734e081bf48b9');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P10', 10, 'overzicht', NULL, 'Planning rond de jaarlijkse ALV', 'Planning rond de jaarlijkse ALV', '| **Moment** | **Actie** |
| --- | --- |
| Na afloop van het boekjaar | Boekhouding afsluiten en ontbrekende stukken verzamelen. |
| Ruim vóór de ALV | Conceptjaarstukken en toelichting in het bestuur bespreken. |
| Vóór verzending aan leden | Kascommissie tijd geven voor onderzoek, vragen en verslag; noodzakelijke correcties verwerken. |
| Bij de oproep voor de ALV | Agenda, stukken en duidelijke besluitvoorstellen beschikbaar stellen volgens de statuten. |
| Tijdens de ALV | Cijfers toelichten, vragen beantwoorden, kascommissie laten rapporteren en besluiten apart vastleggen. |
| Na de ALV | Vastgestelde stukken, notulen en actiepunten bewaren en opvolgen. |', '[]', DATE '2027-09-19', 12, 'b95ea8a5677d1a98');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H11' AND versie = '1.0'), 'H11-P11', 11, 'kern', NULL, 'Kern van dit hoofdstuk', NULL, 'Kern van dit hoofdstuk: goede verantwoording begint vóór de ALV. Zorg voor begrijpelijke jaarstukken, geef de kascommissie tijd en toegang voor haar onderzoek, en laat de leden helder zien welke besluiten zij nemen.', '[]', DATE '2027-09-19', 12, 'e4c4bf25fa33bc3b');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H11' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H11', 'Basisversie 1.0 geïmporteerd, 12 paragrafen, goedgekeurd door Paul Baans');

-- H12 – Bestuur, regels en bevoegdheden
INSERT INTO hoofdstuk (id, nummer) VALUES ('H12', 12);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H12', '1.0', 'concept', 'Bestuur, regels en bevoegdheden', 'De penningmeester voert veel financiële werkzaamheden uit, maar bestuurt de vereniging niet alleen.', 'Hoofdstuk 12 — Bestuur, regels en bevoegdheden', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'De penningmeester voert veel financiële werkzaamheden uit, maar bestuurt de vereniging niet alleen. Het bestuur neemt besluiten, bewaakt de financiële situatie en legt daarover verantwoording af aan de leden. Heldere bevoegdheden beschermen de vereniging én de vrijwilligers die namens haar handelen.', '[]', DATE '2027-09-19', 12, '60a1c713e02a13e8');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P01', 1, 'vraag', '12.1', 'Welke financiële afspraken staan in de statuten en reglementen?', '12.1 Welke financiële afspraken staan in de statuten en reglementen?', 'Begin bij de statuten. Daarin staat onder meer hoe besluiten worden genomen en wie de vereniging mag vertegenwoordigen. Een huishoudelijk of financieel reglement kan praktische afspraken verder uitwerken. Zo’n reglement mag niet in strijd zijn met de wet of de statuten.

Zoek als penningmeester in ieder geval op:

- wie namens de vereniging contracten mag ondertekenen;

- of bestuurders alleen of gezamenlijk mogen handelen;

- welke besluiten goedkeuring van de ALV nodig hebben;

- hoe bestuur en ALV besluiten nemen en vastleggen;

- wie beslist over contributie en begroting;

- wat er gebeurt als bestuurders tijdelijk ontbreken of niet kunnen handelen.

Voor overeenkomsten over bijvoorbeeld de aankoop of verkoop van onroerend goed gelden bijzondere wettelijke regels: controleer vooraf of de statuten het bestuur die bevoegdheid geven en of er voorwaarden aan zijn verbonden. [Burgerlijk Wetboek, Boek 2, artikelen 44 en 45](https://wetten.overheid.nl/BWBR0003045/)

Maak van de relevante bepalingen een korte werkinstructie voor het bestuur. Verwijs daarin naar de statuten, zodat bij twijfel altijd de oorspronkelijke tekst kan worden geraadpleegd.', '[{"label": "Burgerlijk Wetboek, Boek 2, artikelen 44 en 45", "url": "https://wetten.overheid.nl/BWBR0003045/"}]', DATE '2027-09-19', 12, 'feb197e7414c5f36');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P02', 2, 'vraag', '12.2', 'Wie mag een uitgave goedkeuren, een contract tekenen en een betaling doen?', '12.2 Wie mag een uitgave goedkeuren, een contract tekenen en een betaling doen?', 'Dit zijn drie verschillende handelingen:

| **Handeling** | **Betekenis** |
| --- | --- |
| Uitgave goedkeuren | Besluiten dat de vereniging iets mag aanschaffen of een verplichting mag aangaan. |
| Contract tekenen | De vereniging tegenover een leverancier of andere partij verbinden. |
| Betaling uitvoeren | Geld overmaken via de bank. |

Toegang tot internetbankieren betekent dus niet vanzelf dat iemand een uitgave mag goedkeuren. En een bestuursbesluit geeft niet automatisch iedere bestuurder de bevoegdheid om alleen een contract te tekenen. De vertegenwoordigingsbevoegdheid volgt uit de wet en de statuten; de bank richt daarnaast eigen toegangsrechten in op basis van de verenigingsgegevens. [Burgerlijk Wetboek, Boek 2, artikel 45](https://wetten.overheid.nl/BWBR0003045/), [KVK – bankrekening voor een vereniging](https://www.kvk.nl/geldzaken/zakelijke-rekening-openen-deze-documenten-heb-je-nodig/)

Leg in een bevoegdhedenoverzicht vast wie wat mag doen en wanneer vooraf een bestuurs- of ALV-besluit nodig is. Controleer daarbij ook of de geregistreerde bevoegdheden bij KVK en de instellingen bij de bank overeenkomen met de actuele statuten.', '[{"label": "Burgerlijk Wetboek, Boek 2, artikel 45", "url": "https://wetten.overheid.nl/BWBR0003045/"}, {"label": "KVK – bankrekening voor een vereniging", "url": "https://www.kvk.nl/geldzaken/zakelijke-rekening-openen-deze-documenten-heb-je-nodig/"}]', DATE '2027-09-19', 12, 'e353fab40b6517ed');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P03', 3, 'vraag', '12.3', 'Hoe richten we controle op betalingen in die bij de club past?', '12.3 Hoe richten we controle op betalingen in die bij de club past?', 'Kies een werkwijze die de vereniging consequent kan uitvoeren. Een kleine club heeft vaak geen aparte financiële afdeling, maar kan wel voorkomen dat één persoon ongemerkt een betaling aanvraagt, goedkeurt, uitvoert én controleert.

Een werkbare basis is:

- Iemand bevestigt dat de aankoop is afgesproken en geleverd.

- Een bevoegde persoon keurt de factuur of declaratie goed.

- De betaling wordt volgens de bankafspraken uitgevoerd.

- Een ander bestuurslid bekijkt periodiek de bankmutaties en opvallende betalingen.

Stel daarnaast passende betaallimieten in en spreek af hoe een wijziging van een rekeningnummer wordt gecontroleerd. Leg voor contant geld vast wie telt, wie registreert en hoe verschillen worden onderzocht. De aangeleverde Penningmeestergids en Kascommissiegids geven praktische voorbeelden van onafhankelijke bankinzage en controle van betalingen aan de hand van bewijsstukken. 

Bespreek minstens jaarlijks of de controles nog passen bij de omvang van de vereniging. Een nieuwe kantine, betaald personeel of een groot bouwproject kan extra afspraken nodig maken.', '[]', DATE '2027-09-19', 12, '8474ef94db1b240f');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P04', 4, 'vraag', '12.4', 'Hoe gaan we om met belangenconflicten bij financiële besluiten?', '12.4 Hoe gaan we om met belangenconflicten bij financiële besluiten?', 'Een tegenstrijdig belang kan ontstaan als een bestuurder persoonlijk voordeel heeft bij een besluit en dat belang botst met het belang van de vereniging. Bijvoorbeeld: het bestuur kiest een aannemer en één bestuurslid heeft een financieel belang in een van de bedrijven.

Laat de betrokken bestuurder het belang direct melden. Leg in de notulen vast wat is gemeld, wie de offertes of andere opties heeft beoordeeld en hoe het besluit tot stand is gekomen. Een bestuurder met een direct of indirect tegenstrijdig persoonlijk belang neemt volgens de wet niet deel aan de beraadslaging en besluitvorming. Kan het bestuur daardoor geen besluit nemen, dan geldt de wettelijke of statutaire vervangende besluitroute. [Burgerlijk Wetboek, Boek 2, artikel 44 lid 6](https://wetten.overheid.nl/BWBR0003045/), [KVK – belangen die botsen](https://www.kvk.nl/wetten-en-regels/stemmen-in-bestuur-van-vereniging-en-belangen-die-botsen/)

Een bekende van een bestuurder als leverancier kiezen is niet automatisch verboden. Zorg wel dat de keuze aantoonbaar in het belang van de vereniging is, de prijs en voorwaarden zijn beoordeeld en de juiste personen hebben besloten.', '[{"label": "Burgerlijk Wetboek, Boek 2, artikel 44 lid 6", "url": "https://wetten.overheid.nl/BWBR0003045/"}, {"label": "KVK – belangen die botsen", "url": "https://www.kvk.nl/wetten-en-regels/stemmen-in-bestuur-van-vereniging-en-belangen-die-botsen/"}]', DATE '2027-09-19', 12, '28659463beaf82be');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P05', 5, 'vraag', '12.5', 'Welke verantwoordelijkheid draagt het bestuur voor de financiële administratie?', '12.5 Welke verantwoordelijkheid draagt het bestuur voor de financiële administratie?', 'Het bestuur moet zorgen voor een administratie waaruit de rechten en verplichtingen van de vereniging kunnen worden gekend. Jaarlijks maakt het bestuur een balans en een staat van baten en lasten. De penningmeester kan dit werk uitvoeren of coördineren, maar de andere bestuursleden moeten de financiële positie kunnen volgen en belangrijke afwijkingen bespreken. [Burgerlijk Wetboek, Boek 2, artikel 10](https://wetten.overheid.nl/BWBR0003045/), [NOC*NSF – bestuurstaak](https://www.nocnsf.nl/handboek-wet-en-regelgeving/5-bestuurstaak)

Vraag daarom niet alleen om een jaaroverzicht, maar bespreek gedurende het jaar een korte financiële rapportage met:

- het actuele banksaldo en de komende grote betalingen;

- de werkelijke inkomsten en kosten naast de begroting;

- openstaande contributie en facturen;

- belangrijke risico’s, afwijkingen en besluiten die nodig zijn.

Leg vast wie de administratie bijhoudt, wie controleert, wie een vervanger is en waar de informatie wordt bewaard. Zo blijft het bestuur handelingsbekwaam als de penningmeester afwezig is.', '[{"label": "Burgerlijk Wetboek, Boek 2, artikel 10", "url": "https://wetten.overheid.nl/BWBR0003045/"}, {"label": "NOC*NSF – bestuurstaak", "url": "https://www.nocnsf.nl/handboek-wet-en-regelgeving/5-bestuurstaak"}]', DATE '2027-09-19', 12, '5556f1e4b04ed275');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P06', 6, 'vraag', '12.6', 'Welke financiële persoonsgegevens mogen we bewaren en delen?', '12.6 Welke financiële persoonsgegevens mogen we bewaren en delen?', 'Voor contributie, declaraties en loonbetalingen heeft de vereniging persoonsgegevens nodig. Denk aan naam, contactgegevens, lidmaatschap, betaalstatus en rekeningnummer. Verwerk alleen gegevens die nodig zijn voor een duidelijk doel, geef uitsluitend toegang aan mensen die ze voor hun taak nodig hebben en bewaar ze niet langer dan noodzakelijk of wettelijk vereist. De vereniging moet voor iedere verwerking een passende grondslag hebben. [Autoriteit Persoonsgegevens – AVG-grondslagen](https://autoriteitpersoonsgegevens.nl/themas/basis-avg/avg-algemeen/grondslagen-avg-uitgelegd), [Autoriteit Persoonsgegevens – AVG-handleiding](https://autoriteitpersoonsgegevens.nl/uploads/imported/handleiding_avg.pdf)

Maak praktische afspraken:

- Deel in een bestuursrapportage waar mogelijk totalen, in plaats van namen van leden met betalingsachterstand.

- Beperk toegang tot individuele betaalgegevens tot degenen die contributie innen of problemen afhandelen.

- Verstuur geen volledige leden- of salarisadministratie in een brede e-mailgroep.

- Gebruik persoonlijke accounts en trek toegang in wanneer iemand zijn functie neerlegt.

- Spreek af hoe de vereniging reageert als gegevens verloren raken of bij de verkeerde persoon terechtkomen.

Bij een datalek moet de vereniging de gevolgen beoordelen en het incident vastleggen. Soms is melding bij de Autoriteit Persoonsgegevens en aan betrokkenen verplicht. [Autoriteit Persoonsgegevens – datalekken](https://autoriteitpersoonsgegevens.nl/themas/beveiliging/datalekken/datalek-dit-moet-u-doen)', '[{"label": "Autoriteit Persoonsgegevens – AVG-grondslagen", "url": "https://autoriteitpersoonsgegevens.nl/themas/basis-avg/avg-algemeen/grondslagen-avg-uitgelegd"}, {"label": "Autoriteit Persoonsgegevens – AVG-handleiding", "url": "https://autoriteitpersoonsgegevens.nl/uploads/imported/handleiding_avg.pdf"}, {"label": "Autoriteit Persoonsgegevens – datalekken", "url": "https://autoriteitpersoonsgegevens.nl/themas/beveiliging/datalekken/datalek-dit-moet-u-doen"}]', DATE '2027-09-19', 12, 'a7de7e3c468dd03f');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P07', 7, 'vraag', '12.7', 'Wat regelen we financieel bij een bestuurswissel?', '12.7 Wat regelen we financieel bij een bestuurswissel?', 'Een bestuurswissel is pas afgerond als ook registraties, toegang en lopende verplichtingen zijn overgedragen. Geef de wijziging door aan KVK, controleer of de UBO-registratie moet worden aangepast en informeer de bank en andere betrokken organisaties waar nodig. [KVK – bestuurswissel doorgeven](https://www.kvk.nl/wijzigen/bestuurswissel-doorgeven/)

Gebruik een overdrachtslijst voor:

| **Onderdeel** | **Controle** |
| --- | --- |
| Bank | Nieuwe bevoegdheden, passen, limieten en toegang; toegang van vertrokken bestuurders beëindigen. |
| Administratie | Boekhoudaccounts, facturen, bankafschriften, reservekopieën en openstaande posten overdragen. |
| Contracten | Contactpersonen, tekenbevoegden en komende verlengings- of opzegdata nalopen. |
| Belastingen en subsidies | Toegang tot portalen, lopende aangiften en verantwoordingsdeadlines controleren. |
| Verzekeringen | Contactpersoon en gedekte bestuurders of activiteiten controleren. |

Laat oude en nieuwe functionarissen waar mogelijk samen vastleggen welke zaken zijn overgedragen en welke vragen nog openstaan. Hoofdstuk 13 werkt de volledige jaarcyclus en overdracht verder uit.', '[{"label": "KVK – bestuurswissel doorgeven", "url": "https://www.kvk.nl/wijzigen/bestuurswissel-doorgeven/"}]', DATE '2027-09-19', 12, '7d6df24f66f52410');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P08', 8, 'vraag', '12.8', 'Hoe leggen we bevoegdheden, besluiten en uitzonderingen duidelijk vast?', '12.8 Hoe leggen we bevoegdheden, besluiten en uitzonderingen duidelijk vast?', 'Gebruik één actueel financieel afsprakenoverzicht dat het bestuur kan vinden. Neem daarin op:

- welke besluiten het bestuur zelf neemt en welke naar de ALV gaan;

- wie uitgaven mag voorstellen, goedkeuren, tekenen en betalen;

- welke bedragen of soorten verplichtingen extra akkoord vragen;

- hoe offertes worden beoordeeld;

- hoe afwijkingen van de begroting worden gemeld;

- wie bankrechten, contracten en het overzicht zelf mag wijzigen;

- wanneer het bestuur deze afspraken opnieuw beoordeelt.

Maak bij een uitzondering een afzonderlijk besluit. Noteer waarom van de normale werkwijze wordt afgeweken, wie heeft ingestemd, welk maximumbedrag geldt en wanneer de uitzondering eindigt. Een mondeling “dat is wel goed” is bij een grote verplichting onvoldoende houvast voor de penningmeester en diens opvolger.

Controleer altijd eerst of een werkafspraak binnen de statuten en de wettelijke bevoegdheden past. Een interne limiet helpt het bestuur uitgaven te beheersen, maar vervangt de regels voor de vertegenwoordiging van de vereniging niet.', '[]', DATE '2027-09-19', 12, '9d9631b45e2ff249');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P09', 9, 'checklist', NULL, 'Controlelijst voor het bestuur', 'Controlelijst voor het bestuur', '- De actuele statuten en financiële reglementen zijn voor alle bestuurders beschikbaar.

- Besluitbevoegdheid, tekenbevoegdheid en betaaltoegang zijn afzonderlijk vastgelegd.

- KVK-registratie en bankrechten sluiten aan op het huidige bestuur.

- Een tweede persoon controleert de bankmutaties regelmatig.

- Tegenstrijdige belangen worden gemeld en in de besluitvorming verwerkt.

- Het hele bestuur bespreekt tussentijdse financiële rapportages.

- Toegang tot persoonsgegevens en financiële systemen is beperkt en actueel.

- Besluiten, uitzonderingen en goedkeuringen zijn terug te vinden.', '[]', DATE '2027-09-19', 12, 'a5db6748fdf69204');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H12' AND versie = '1.0'), 'H12-P10', 10, 'kern', NULL, 'Kern van dit hoofdstuk', NULL, 'Kern van dit hoofdstuk: zorg dat ieder bestuurslid weet wie mag beslissen, tekenen, betalen en controleren. Leg die afspraken vast, pas ze daadwerkelijk toe en controleer ze bij iedere bestuurswissel.', '[]', DATE '2027-09-19', 12, '9eeb0b606b519a97');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H12' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H12', 'Basisversie 1.0 geïmporteerd, 11 paragrafen, goedgekeurd door Paul Baans');

-- H13 – Praktische jaarcyclus en overdracht
INSERT INTO hoofdstuk (id, nummer) VALUES ('H13', 13);
INSERT INTO hoofdstuk_versie (hoofdstuk_id, versie, status, titel, omschrijving, kop_origineel, versiedatum, auteur, basisversie, toelichting)
  VALUES ('H13', '1.0', 'concept', 'Praktische jaarcyclus en overdracht', 'Een goede financiële administratie draait op vaste gewoonten.', 'Hoofdstuk 13 — Praktische jaarcyclus en overdracht', DATE '2026-09-19', 'Import uit Vragenlijst Fin – FinSport versie 2 (Word)', TRUE, 'Basisversie 1.0: inhoud letterlijk overgenomen uit het door de redacteuren gecontroleerde Word-document.');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P00', 0, 'inleiding', NULL, 'Inleiding', NULL, 'Een goede financiële administratie draait op vaste gewoonten. Als ontvangsten, betalingen en afspraken gedurende het jaar worden bijgehouden, kost de jaarafsluiting minder tijd en kan een nieuwe penningmeester het werk gemakkelijker overnemen. Dit hoofdstuk brengt de terugkerende taken samen in één werkbare planning.', '[]', DATE '2027-09-19', 12, '5ce5b99e57872985');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P01', 1, 'vraag', '13.1', 'Welke financiële taken komen elke week, maand, kwartaal en jaar terug?', '13.1 Welke financiële taken komen elke week, maand, kwartaal en jaar terug?', 'De precieze frequentie hangt af van de omvang van de vereniging. Een club met een eigen kantine en werknemers verwerkt meer transacties dan een kleine vereniging die alleen contributie ontvangt. Gebruik dit schema als vertrekpunt.

| **Wanneer** | **Taken** |
| --- | --- |
| Wekelijks of na iedere activiteit | Binnengekomen facturen en declaraties verzamelen; betalingen volgens de afspraken laten goedkeuren; bankontvangsten en eventuele kasopbrengsten verwerken; opvallende mutaties uitzoeken. |
| Maandelijks | Bank en boekhouding vergelijken; openstaande contributie en facturen bekijken; komende betalingen plannen; de financiële stand kort met het bestuur delen. |
| Per kwartaal | Werkelijke cijfers met de begroting vergelijken; liquiditeitsprognose bijwerken; contracten, subsidies en belastingverplichtingen nalopen. |
| Jaarlijks | Begroting voorbereiden; bezittingen en reserves controleren; boekjaar afsluiten; jaarstukken opstellen; kascontrole en ALV voorbereiden; verzekeringen en financiële afspraken herzien. |

Laat een tweede persoon op afgesproken momenten de bankmutaties bekijken. Regel ook wie de taken overneemt als de penningmeester ziek is of met vakantie gaat. De aangeleverde Penningmeestergids en Kascommissiegids onderstrepen het belang van een administratie die gedurende het jaar wordt bijgewerkt en door anderen te controleren is. ', '[]', DATE '2027-09-19', 12, 'ceb0d3d2f4ce8c1c');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P02', 2, 'vraag', '13.2', 'Welke deadlines moet ik voor onze vereniging bijhouden?', '13.2 Welke deadlines moet ik voor onze vereniging bijhouden?', 'Maak onderscheid tussen wettelijke termijnen, contractuele afspraken en interne plandata.

- Jaarstukken en ALV: het bestuur legt jaarlijks de financiële stukken en het bestuursverslag aan de leden voor. Voor gewone verenigingen noemt de wet hiervoor een termijn van zes maanden na afloop van het boekjaar, behoudens verlenging door de ALV. Controleer ook de statuten. [Burgerlijk Wetboek, Boek 2, artikel 48](https://wetten.overheid.nl/BWBR0003045/)

- Belastingaangiften: alleen voor zover de vereniging daartoe verplicht is. Het aangiftetijdvak en de betaaldatum hangen af van de belastingsoort en de registratie van de vereniging. Raadpleeg de berichten en actuele datums van de [Belastingdienst](https://www.belastingdienst.nl/wps/wcm/connect/nl/ondernemers/content/inloggen-voor-ondernemers).

- Subsidies: noteer aanvraagtermijnen, de periode waarin kosten mogen worden gemaakt en de datum waarop de besteding moet worden verantwoord.

- Contracten en verzekeringen: leg verlengingsdata, opzegtermijnen en premiebetalingen vast.

- Sportbond en gemeente: houd termijnen bij voor afdrachten, gegevensaanlevering en eventuele vergunningen of heffingen.

- Contributie: plan de besluitvorming, facturatie, incasso en opvolging van achterstanden.

Neem deadlines over uit de eigen beschikkingen, contracten, statuten en berichten. Een algemeen voorbeeldschema is daarvoor geen betrouwbare vervanging.', '[{"label": "Burgerlijk Wetboek, Boek 2, artikel 48", "url": "https://wetten.overheid.nl/BWBR0003045/"}, {"label": "Belastingdienst", "url": "https://www.belastingdienst.nl/wps/wcm/connect/nl/ondernemers/content/inloggen-voor-ondernemers"}]', DATE '2027-09-19', 12, '2d91fdea9c81fefc');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P03', 3, 'vraag', '13.3', 'Hoe maak ik een werkbare financiële kalender?', '13.3 Hoe maak ik een werkbare financiële kalender?', 'Gebruik één gedeelde kalender of takenlijst die ook voor een tweede bestuurslid toegankelijk is. Noteer per taak vijf dingen: wat moet gebeuren, uiterste datum, voorbereidende datum, verantwoordelijke en waar de onderliggende afspraak staat.

| **Taak** | **Uiterste datum** | **Beginnen op** | **Verantwoordelijke** | **Bron** |
| --- | --- | --- | --- | --- |
| Contributie innen | Volgens contributiebesluit | Enkele weken eerder | Penningmeester en ledenadministratie | ALV-besluit |
| Subsidie verantwoorden | Volgens beschikking | Ruim vóór de einddatum | Projectleider en penningmeester | Subsidiebeschikking |
| Kascontrole | Vóór verzending ALV-stukken | Na conceptjaarstukken | Kascommissie | ALV-planning |
| Huurcontract beoordelen | Vóór opzegtermijn | Tijdig voor bestuursbesluit | Bestuur | Huurovereenkomst |

Zet herinneringen vóór de echte deadline. Houd bij een grote taak, zoals de jaarafsluiting, ruimte voor ontbrekende facturen en vragen van de kascommissie. Controleer de kalender bij iedere bestuursvergadering en werk haar bij zodra een nieuw contract of subsidie wordt toegekend.', '[]', DATE '2027-09-19', 12, 'ffaa71e45f1a1e16');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P04', 4, 'vraag', '13.4', 'Welke controles voer ik gedurende het jaar uit?', '13.4 Welke controles voer ik gedurende het jaar uit?', 'Een periodieke controle moet antwoord geven op de vraag: kloppen de cijfers en ziet het bestuur problemen op tijd aankomen?

Controleer in ieder geval:

- Bank en kas: sluiten saldi en mutaties aan op de boekhouding?

- Contributie: passen de verwachte inkomsten bij de actuele ledenlijst en de vastgestelde tarieven?

- Facturen en declaraties: is voor betalingen een bewijsstuk en het juiste akkoord aanwezig?

- Begroting: welke inkomsten en kosten wijken duidelijk af, en waarom?

- Liquiditeit: kan de vereniging haar betalingen de komende maanden op tijd doen?

- Subsidies en contracten: worden voorwaarden nagekomen en deadlines gehaald?

- Toegang en bevoegdheden: hebben alleen de juiste personen toegang tot bank en administratie?

Leg belangrijke verschillen en de oplossing kort vast. Meld een mogelijk tekort of een onverklaarde betaling meteen aan het bestuur; wacht niet tot de volgende jaarrekening. Hoofdstuk 2 beschrijft de administratieve controles en hoofdstuk 10 de aanpak van financiële risico’s uitgebreider.', '[]', DATE '2027-09-19', 12, '4cee066abfb79f5f');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P05', 5, 'vraag', '13.5', 'Hoe bereid ik het einde van het boekjaar voor?', '13.5 Hoe bereid ik het einde van het boekjaar voor?', 'Begin vóór de laatste dag van het boekjaar met een afsluitlijst. Vraag commissies en teams om hun nog ontbrekende inkomsten, uitgaven en bewijsstukken aan te leveren. Controleer welke facturen of bijdragen betrekking hebben op het afgelopen jaar, ook als de betaling pas later volgt.

Loop daarna de belangrijkste posten na:

- bankrekeningen en eventuele contante kas;

- nog te ontvangen contributie, subsidies en sponsorbedragen;

- nog te betalen facturen en andere verplichtingen;

- voorraden en waardevolle bezittingen;

- leningen, investeringen en afschrijvingen;

- vooruitbetaalde en vooruit ontvangen bedragen;

- reserves en de toelichting op belangrijke veranderingen.

Vergelijk de conceptjaarstukken met de begroting en het voorgaande jaar. Bespreek opvallende verschillen eerst in het bestuur. Geef vervolgens de kascommissie tijd en toegang voor haar onderzoek, verwerk eventuele correcties en stel de stukken tijdig beschikbaar voor de ALV. De formele behandeling van de stukken en de rol van de kascommissie staan in hoofdstuk 11.', '[]', DATE '2027-09-19', 12, '09e1f94fcc47e41e');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P06', 6, 'vraag', '13.6', 'Wat draag ik over aan mijn opvolger?', '13.6 Wat draag ik over aan mijn opvolger?', 'Een goede overdracht bestaat uit informatie, toegang en uitleg. Geef niet alleen een map met bestanden, maar bespreek ook wat nog moet gebeuren.

Gebruik deze overdrachtslijst:

- Verenigingsregels: statuten, financieel reglement, actuele bevoegdheden en belangrijke besluiten.

- Financiële stand: laatste begroting, jaarstukken, recente rapportage, banksaldi en openstaande posten.

- Administratie: boekhoudsysteem, rekeningschema, archiefstructuur en werkinstructies.

- Bank en betaalproces: rekeningen, passen, limieten, betaalrechten en controleafspraken.

- Lopende afspraken: contracten, leningen, verzekeringen, subsidies en termijnen.

- Contactpersonen: ledenadministratie, kascommissie, bond, gemeente, leveranciers en adviseurs.

- Openstaande kwesties: onverklaarde verschillen, verwachte grote betalingen en besluiten die het bestuur nog moet nemen.

- Financiële kalender: alle terugkerende taken en deadlines.

Draag toegang veilig over met eigen accounts voor de opvolger. Deel geen persoonlijke wachtwoorden. Controleer daarna of de vertrekkende penningmeester geen toegang meer heeft die niet nodig is. Bij een bestuurswissel moeten ook de registratie bij KVK, eventuele UBO-gegevens en de bankrechten worden bijgewerkt. [KVK – bestuurswissel doorgeven](https://www.kvk.nl/wijzigen/bestuurswissel-doorgeven/)', '[{"label": "KVK – bestuurswissel doorgeven", "url": "https://www.kvk.nl/wijzigen/bestuurswissel-doorgeven/"}]', DATE '2027-09-19', 12, '5e84a34564f715ba');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P07', 7, 'vraag', '13.7', 'Hoe blijft de administratie begrijpelijk als vrijwilligers wisselen?', '13.7 Hoe blijft de administratie begrijpelijk als vrijwilligers wisselen?', 'Gebruik een vaste indeling die niet afhangt van het geheugen van één persoon. Spreek af hoe facturen worden benoemd, waar contracten staan, welke rubrieken in de boekhouding worden gebruikt en waar besluiten worden bewaard. Het aangeleverde rekenschema kan daarbij als gemeenschappelijke indeling dienen. 

Bewaar bij iedere belangrijke boeking een begrijpelijke omschrijving en het bewijsstuk. Noteer bij een ongebruikelijke verwerking waarom daarvoor is gekozen. Houd een korte handleiding bij voor terugkerende handelingen, zoals contributie innen, bankmutaties verwerken en een bestuursrapportage maken.

Test de overdraagbaarheid één keer per jaar: laat een ander bestuurslid een factuur, contract en bestuursbesluit terugzoeken. Als dat niet lukt, verbeter dan de indeling. Zorg ook dat de vereniging zelf toegang houdt tot reservekopieën van de administratie.', '[]', DATE '2027-09-19', 12, '92ab9df9ae1dbdf5');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P08', 8, 'vraag', '13.8', 'Wat zijn de eerste stappen voor een nieuwe penningmeester?', '13.8 Wat zijn de eerste stappen voor een nieuwe penningmeester?', 'Probeer niet direct de hele administratie te veranderen. Breng eerst de huidige situatie en de eerstvolgende verplichtingen in beeld.

In de eerste weken:

- Lees de statuten, financiële afspraken en notulen van recente financiële besluiten.

- Bekijk de laatste jaarstukken, begroting en opmerkingen van de kascommissie.

- Controleer bankstanden, openstaande rekeningen en de betalingen voor de komende maanden.

- Vergelijk de banktoegang en bevoegdheden met de actuele bestuursregistratie.

- Neem samen met de ledenadministratie de contributie-inning door.

- Loop de financiële kalender en alle naderende deadlines na.

- Bespreek onduidelijkheden en risico’s met het hele bestuur.

Maak daarna een kort startoverzicht voor het bestuur: huidige geldpositie, verwachte ontvangsten en betalingen, openstaande vragen en de eerste besluiten die nodig zijn. Daarmee ontstaat een gezamenlijk vertrekpunt voor het komende verenigingsjaar.', '[]', DATE '2027-09-19', 12, 'c367fdb1bf18c6d4');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P09', 9, 'overzicht', NULL, 'Jaarcyclus in één oogopslag', 'Jaarcyclus in één oogopslag', '| **Fase** | **Hoofdvraag** |
| --- | --- |
| Plannen | Wat willen we doen en hoe betalen we dat? |
| Uitvoeren | Komen inkomsten binnen en worden uitgaven volgens afspraak gedaan? |
| Volgen | Wijken cijfers of risico’s af van de begroting? |
| Afsluiten | Zijn alle posten juist en volledig verwerkt? |
| Verantwoorden | Kunnen kascommissie en leden de financiële situatie beoordelen? |
| Overdragen | Kan een opvolger het werk zonder ontbrekende kennis voortzetten? |', '[]', DATE '2027-09-19', 12, 'c9a20855dce40fa6');
INSERT INTO paragraaf (hoofdstuk_versie_id, paragraaf_id, volgorde, soort, nummer, titel, kop_origineel, tekst, bronnen, reviewdatum, reviewtermijn_maanden, controlegetal) VALUES ((SELECT id FROM hoofdstuk_versie WHERE hoofdstuk_id = 'H13' AND versie = '1.0'), 'H13-P10', 10, 'kern', NULL, 'Kern van dit hoofdstuk', NULL, 'Kern van dit hoofdstuk: maak financiële taken voorspelbaar met een kalender, voer gedurende het jaar kleine controles uit en leg informatie zo vast dat een opvolger direct verder kan.', '[]', DATE '2027-09-19', 12, 'bb14359a007be598');
UPDATE hoofdstuk_versie SET status = 'goedgekeurd', goedgekeurd_door = 'Paul Baans', goedgekeurd_op = DATE '2026-09-19'
  WHERE hoofdstuk_id = 'H13' AND versie = '1.0';
INSERT INTO logboek (gebruiker, actie, onderwerp, details) VALUES ('systeem', 'import_basisversie', 'H13', 'Basisversie 1.0 geïmporteerd, 11 paragrafen, goedgekeurd door Paul Baans');
