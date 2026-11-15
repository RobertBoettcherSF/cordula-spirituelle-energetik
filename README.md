# Cordula Dobos – Spirituelle Energetik

Einseitige Website. Ein Ada-Programm erzeugt `index.html` im Wurzelverzeichnis: CSS, SVG und das kleine Laufzeit-Skript stehen in dieser einen Datei. So lässt sich die Seite über einen relativen Link (zum Beispiel raw.githack.com) teilen.

Deutsch ist voreingestellt. Englisch schaltet eine Flagge um, ohne JavaScript. Der Splash, die Flaggen und die Sprungmarken sind HTML und CSS. JavaScript startet nur den Ton und lässt den Gecko laufen.

## Bauen

Voraussetzung ist GNAT mit `gprbuild` (Debian/Ubuntu: Pakete `gnat` und `gprbuild`).

```sh
make
```

Das übersetzt `src/` nach `bin/site` und schreibt `index.html`. Der Compiler läuft mit `-gnatwa -gnatwe` und soll ohne Warnung durchlaufen.

Ohne Make:

```sh
gprbuild -p -P site.gpr
./bin/site -o index.html
```

`make clean` entfernt `obj/`, `bin/` und `index.html`. Dateien unter `audio/` bleiben stehen.

## Ansehen

`index.html` direkt im Browser öffnen. Für die Musik einen kleinen Webserver im Projektordner verwenden; manche Browser spielen keine lokalen Audiodateien über `file://`.

Der Splash zeigt das Schild: senfgelber Grund, bordeauxrotes Unendlichzeichen. Ein goldener Punkt läuft einmal die Kurve entlang (etwa 53 Sekunden), danach blendet die Seite ein. „Überspringen / Skip“ beendet den Splash sofort. Bei `prefers-reduced-motion` erscheint die Seite ohne Animation, und der Gecko bleibt aus. Auf schmalen Fenstern (bis 700 px) und auf Telefonen bleibt auch die Sonne aus; der Gecko läuft dort nicht.

Ein Tippen auf den Splash oder auf „Klang“ startet leise Musik (Lautstärke 0,25). Beim Wechsel auf die Seite wird von `audio/splash.mp3` nach `audio/seite.mp3` übergeblendet. Beide Stücke laufen in einer Schleife. Der Schalter schaltet auf Stumm. Fehlt eine Datei, bleibt die Seite benutzbar.

## Platzhalter ersetzen

Texte über Cordula und die beiden Angebote sind Entwürfe. In `src/translations.adb` stehen sie in `Text_DE` und `Text_EN` und sind mit `--  PLACEHOLDER` markiert. Nach dem Ändern neu bauen. In der Seite steht zusätzlich der Kommentar `<!-- PLACEHOLDER: Von Cordula zu ersetzen. -->` und ein sichtbares „Entwurf“ bzw. „draft“.

Nicht ergänzen: Adresse, Preise, Qualifikationen oder andere Angaben, die nicht von Cordula stammen.

Der Name, „Spirituelle Energetik“, „· Heilungen · Besetzungen“ und die Telefonzeile auf Deutsch folgen dem Hausschild. Telefonlink und angezeigte Nummer stehen in `src/tuning.ads` (`Tel_Href`, `Tel_Display`).

## Eine Sprache hinzufügen

Nur `src/translations.adb` anfassen:

1. Eine Funktion `Text_XX` schreiben. Die `case`-Anweisung muss jeden Wert von `Phrase` nennen, sonst bricht der Bau ab.
2. Eine Zeile in `Catalog` ergänzen: Sprachcode (zwei Buchstaben), Eigenname, Funktion. Die erste Zeile ist die Voreinstellung.

Danach `make`. Radios, CSS und Texte entstehen aus dieser Tabelle.

`de` und `en` haben gezeichnete Flaggen (`Draw.Flag` in `src/draw.adb`). Jeder andere Code bekommt eine kleine Kachel mit dem Kürzel.

## Wo die Werte stehen

| Was | Datei |
| --- | --- |
| Übersetzungen | `src/translations.adb` |
| Farben | `src/palette.ads` |
| Zeiten, Lautstärke, Klangschale, Gecko | `src/tuning.ads` |
| Lemniskate, Kacheln, Gecko-Form | `src/draw.adb` |

Das Skript in `index.html` liest die von Ada erzeugte Konstante `CFG`. Eigene Zeiten oder Frequenzen gehören nicht ins Skript, sondern nach `tuning.ads`.
