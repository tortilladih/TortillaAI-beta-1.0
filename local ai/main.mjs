import { app, BrowserWindow, dialog } from 'electron';
import { createAppServer } from './server.mjs';
import { join } from 'node:path';

let server;
let mainWindow;
const hasLock = app.requestSingleInstanceLock();
if (!hasLock) app.quit();
else {
  app.on('second-instance', () => {
    if (mainWindow) { if (mainWindow.isMinimized()) mainWindow.restore(); mainWindow.focus(); }
  });
  app.whenReady().then(async () => {
    try {
      server = createAppServer();
      await new Promise((resolve, reject) => {
        server.once('error', reject);
        server.listen(0, '127.0.0.1', () => { server.removeListener('error', reject); resolve(); });
      });
      const address = server.address();
      const port = typeof address === 'object' && address ? address.port : 3000;
      mainWindow = new BrowserWindow({
        width: 1180, height: 820, minWidth: 760, minHeight: 560,
        show: false, title: 'TortillaAI', backgroundColor: '#11140f',
        icon: join(app.getAppPath(), 'assets', 'tortilla.ico'),
        autoHideMenuBar: true,
        webPreferences: { contextIsolation: true, nodeIntegration: false, sandbox: true }
      });
      mainWindow.once('ready-to-show', () => mainWindow.show());
      mainWindow.on('closed', () => { mainWindow = null; });
      await mainWindow.loadURL('http://127.0.0.1:' + port + '/');
    } catch (error) {
      await dialog.showMessageBox({ type: 'error', title: 'TortillaAI konnte nicht starten', message: 'Die App konnte nicht geöffnet werden.', detail: error.message });
      app.quit();
    }
  });
}
app.on('before-quit', () => { if (server?.listening) { server.closeAllConnections?.(); server.close(); } });
app.on('window-all-closed', () => app.quit());