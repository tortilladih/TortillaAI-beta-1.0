import { app, BrowserWindow, dialog, session } from 'electron';
import { createAppServer } from './server.mjs';
import { join } from 'node:path';

const HOST = '127.0.0.1';
const PORT = 3001;
const ORIGIN = 'http://' + HOST + ':' + PORT;
let server;
let mainWindow;

function isLocalOrigin(value) {
  try { return new URL(value).origin === ORIGIN; } catch { return false; }
}

const hasLock = app.requestSingleInstanceLock();
if (!hasLock) app.quit();
else {
  app.on('second-instance', () => {
    if (mainWindow) { if (mainWindow.isMinimized()) mainWindow.restore(); mainWindow.focus(); }
  });

  app.whenReady().then(async () => {
    try {
      session.defaultSession.setPermissionCheckHandler((_webContents, permission, requestingOrigin, details) =>
        permission === 'media' && isLocalOrigin(requestingOrigin) && details?.mediaType === 'audio'
      );
      session.defaultSession.setPermissionRequestHandler((webContents, permission, callback, details) => {
        const requestingUrl = details?.requestingUrl || webContents.getURL();
        const mediaTypes = details?.mediaTypes || [];
        const audioOnly = mediaTypes.includes('audio') && !mediaTypes.includes('video');
        callback(permission === 'media' && isLocalOrigin(requestingUrl) && audioOnly);
      });

      server = createAppServer();
      await new Promise((resolve, reject) => {
        server.once('error', reject);
        server.listen(PORT, HOST, () => { server.removeListener('error', reject); resolve(); });
      });

      mainWindow = new BrowserWindow({
        width: 1180, height: 820, minWidth: 760, minHeight: 560,
        show: false, title: 'TortillaAI', backgroundColor: '#10140f',
        icon: join(app.getAppPath(), 'assets', 'tortilla.ico'),
        autoHideMenuBar: true,
        webPreferences: { contextIsolation: true, nodeIntegration: false, sandbox: true }
      });
      mainWindow.webContents.setWindowOpenHandler(() => ({ action: 'deny' }));
      mainWindow.once('ready-to-show', () => mainWindow.show());
      mainWindow.on('closed', () => { mainWindow = null; });
      await mainWindow.loadURL(ORIGIN + '/');
    } catch (error) {
      await dialog.showMessageBox({
        type: 'error',
        title: 'TortillaAI konnte nicht starten',
        message: 'Die App konnte nicht geöffnet werden.',
        detail: error.code === 'EADDRINUSE'
          ? 'Der lokale App-Port 3001 ist bereits belegt. Schließe eine zweite TortillaAI-Instanz und starte die App erneut.'
          : error.message
      });
      app.quit();
    }
  });
}

app.on('before-quit', () => {
  if (server?.listening) { server.closeAllConnections?.(); server.close(); }
});
app.on('window-all-closed', () => app.quit());
