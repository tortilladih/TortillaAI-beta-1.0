# TortillaAI

Dein lokaler KI-Chat mit Ollama und einer eigenen Windows-Desktop-App auf Electron.

## Funktionen

- Chat, Code-Assistent und defensive Cybersecurity-Erklärungen
- Unterhaltungen werden im lokalen App-Profil gespeichert
- Spracheingabe über die Spracherkennung des Browsers; der erkannte Text geht an Ollama auf deinem PC
- Antworten vorlesen lassen sowie Code und Antworten kopieren

## Einmal einrichten

1. Ollama für Windows installieren und starten: https://ollama.com/download
2. In PowerShell ein Modell laden, zum Beispiel: ollama pull llama3.2
3. In diesem Ordner einmalig npm install ausführen.
4. Eine Desktop-Verknüpfung erstellen: npm run shortcut

## Starten

Doppelklicke künftig auf TortillaAI auf dem Desktop. Ollama muss im Hintergrund laufen. Für Electron nutzt TortillaAI den lokalen Port 3001. Der Browser-Start verwendet weiterhin http://127.0.0.1:3000.

## Datenschutz

Chatnachrichten werden an Ollama unter 127.0.0.1 auf deinem PC gesendet. Die Sprache-zu-Text-Erkennung kann einen Online-Sprachdienst des Browsers verwenden und Audio dorthin übertragen. Beim ersten Klick auf das Mikrofon zeigt TortillaAI diesen Hinweis an. Die Vorlesefunktion nutzt die Sprachsynthese des Systems.

## Voraussetzungen

Für den Electron-Start wird Node.js nicht benötigt; Electron bringt seine eigene Laufzeit mit. Node.js und npm werden nur für die einmalige Einrichtung und den Browser-Start gebraucht.
