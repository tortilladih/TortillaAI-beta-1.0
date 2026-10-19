# TortillaAI

Dein lokaler KI-Chat mit Ollama und einer eigenen Windows-Desktop-App auf Electron.

## Einmal einrichten
1. Ollama für Windows installieren und starten: https://ollama.com/download
2. In PowerShell ein Modell laden, zum Beispiel ollama pull llama3.2
3. In diesem Ordner einmalig npm install ausführen.
4. Eine Desktop-Verknüpfung erstellen: npm run shortcut

## Starten
Doppelklicke künftig auf TortillaAI auf dem Desktop. Ollama muss im Hintergrund laufen. Die Unterhaltung wird lokal über Ollama verarbeitet.

Alternativ zum Entwickeln im Browser: npm start, dann http://127.0.0.1:3000 öffnen.

## Voraussetzungen
Für den Electron-Start wird Node.js nicht benötigt; Electron bringt seine eigene Laufzeit mit. Node.js und npm werden nur für die einmalige Einrichtung und den Browser-Start gebraucht.