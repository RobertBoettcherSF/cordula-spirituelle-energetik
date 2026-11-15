# Ton

Hier liegen die beiden Schleifen für die Seite:

- `splash.mp3` — Musik während des Splash
- `seite.mp3` — Musik auf der Seite danach

Die Dateien nicht umbenennen und nicht löschen. Die Seite verweist relativ auf `audio/splash.mp3` und `audio/seite.mp3`.

Beide Stücke werden geloopt, erst nach einem Klick oder Tipp gestartet und leise abgespielt (Lautstärke 0,25). Beim Ende oder Überspringen des Splash wird übergeblendet. Fehlt eine Datei, bleibt die Seite still an dieser Stelle und sonst benutzbar.

Lautstärke, Überblendung und die leisen Klangschalen-Töne stehen in `src/tuning.ads`.
