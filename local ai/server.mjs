import http from 'node:http';
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const root = fileURLToPath(new URL('.', import.meta.url));
const ollama = process.env.OLLAMA_URL || 'http://127.0.0.1:11434';

export function createAppServer() {
  return http.createServer(async (req, res) => {
    try {
      const url = new URL(req.url, 'http://' + (req.headers.host || 'localhost'));
      if (url.pathname === '/api/tags' || url.pathname === '/api/chat') {
        const target = new URL(url.pathname + url.search, ollama);
        const headers = { 'content-type': req.headers['content-type'] || 'application/json' };
        let body;
        if (req.method !== 'GET' && req.method !== 'HEAD') {
          const chunks = [];
          for await (const chunk of req) chunks.push(chunk);
          body = Buffer.concat(chunks);
        }
        const options = { method: req.method, headers };
        if (body) options.body = body;
        const upstream = await fetch(target, options);
        res.writeHead(upstream.status, { 'content-type': upstream.headers.get('content-type') || 'application/json' });
        if (upstream.body) for await (const chunk of upstream.body) res.write(chunk);
        return res.end();
      }
      if (url.pathname !== '/' && url.pathname !== '/index.html') { res.writeHead(404); return res.end('Not found'); }
      const page = await readFile(join(root, 'index.html'));
      res.writeHead(200, { 'content-type': 'text/html; charset=utf-8' });
      res.end(page);
    } catch (error) {
      if (!res.headersSent) res.writeHead(error.code === 'ENOENT' ? 404 : 502, { 'content-type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({ error: error.code === 'ENOENT' ? 'Datei nicht gefunden' : 'Ollama ist nicht erreichbar. Ist Ollama gestartet?' }));
    }
  });
}

export function startServer(port = Number(process.env.PORT ?? 3000)) {
  const server = createAppServer();
  return new Promise((resolve, reject) => {
    server.once('error', reject);
    server.listen(port, '127.0.0.1', () => {
      server.removeListener('error', reject);
      const address = server.address();
      const actualPort = typeof address === 'object' && address ? address.port : port;
      console.log('TortillaAI bereit: http://127.0.0.1:' + actualPort);
      resolve(server);
    });
  });
}

if (process.argv[1] && pathToFileURL(process.argv[1]).href === import.meta.url) {
  startServer().catch(error => { console.error('TortillaAI konnte nicht starten:', error.message); process.exitCode = 1; });
}