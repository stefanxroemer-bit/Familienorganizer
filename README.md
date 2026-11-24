# Familien-Tablet

Familien-Organizer für das Tablet im Flur (Lenovo Idea Tab mit Fully Kiosk) und die iPhones der Familie.
Eine einzige Datei `index.html`, gehostet über GitHub Pages: https://stefanxroemer-bit.github.io/Familienorganizer/

**Modi:** 🏠 Wand · 🧒 Kind · ✅ Todos · 🛒 Einkaufen · 🍳 Kochen (Römers Küche)
Direkt öffnen mit `#wand`, `#kind`, `#todos`, `#einkaufen` oder `#kochen` am Ende der Adresse (z. B. für NFC-Chips).
Neue Aufgabe per Link (Siri-Kurzbefehl): `https://stefanxroemer-bit.github.io/Familienorganizer/?todo=Text&wer=stefan` (`wer` = `stefan`, `kiara` oder `beide`).
Zum Ausprobieren ohne Konto: `#demo`.

## Aufbau

| Baustein | Dienst |
| --- | --- |
| App | `index.html` (ohne Build-Schritt) |
| Hosting | GitHub Pages (Branch `main`, Ordner `/`) |
| Datenbank, Login | Supabase, Region Frankfurt, ein Familienkonto, Row Level Security |
| Kalender | iCloud „Familie" und „Kind" (öffentlich), Abruf über Edge Function `kalender` |
| Wetter | Open-Meteo, Standard Düsseldorf |

## Keine Geheimnisse im Code

- Supabase-Adresse und Publishable Key werden **pro Gerät** eingegeben, nicht im Repo gespeichert.
- iCloud-Links stehen **nur** in den Supabase-Secrets `ICAL_FAMILIE` und `ICAL_KIND`.

## Einrichtung

1. **iCloud:** Kalender „Familie" und „Kind" anlegen, mit der Familie **teilen** (Schreibrechte) und zusätzlich „Öffentlicher Kalender" einschalten. Die öffentlichen Links nur in die Supabase-Secrets kopieren.
2. **Supabase:** Projekt anlegen (Frankfurt), im SQL Editor `supabase/schema.sql` und danach `supabase/todos.sql` ausführen, unter Authentication das Familienkonto anlegen.
3. **Edge Function:** „Deploy a new function" → „Via Editor", Name `kalender`, Inhalt von `supabase/functions/kalender/index.ts`. Secrets `ICAL_FAMILIE` und `ICAL_KIND` anlegen. „Verify JWT" bleibt an.
4. **Öffnen:** Seite am iPhone öffnen, Supabase-Adresse und Publishable Key eingeben (Project Settings → API), einloggen, über Safari „Zum Home-Bildschirm".
5. **Tablet:** Fully Kiosk, Seite als Startseite, Bewegungserkennung, Start beim Hochfahren, Kiosk-Sperre mit PIN.

## Tipps für Kalendertitel

| Schreibweise | Wirkung |
| --- | --- |
| `🎾 Tennis` | Emoji am Anfang wird als Symbol genommen (Kind- und Familienkalender) |
| `S Zahnarzt` · `K Yoga` · `SK Elternabend` (großes S/K, Doppelpunkt optional) | Farbiges Namensschild Stefan, Kiara oder Beide im Familienkalender |
| Termin auf der Wand antippen | Details mit Titel, Zeit und Ort |

## Update

`index.html` im Repo ersetzen → nach ca. 1 Minute live. Geräte laden nachts um 3 Uhr neu.
