// Service Worker - YBYgram PWA • Rede Soberana
const CACHE_NAME = 'ybygram-cache-v20';
const ASSETS_TO_CACHE = [
  './',
  './index.html',
  './manifest.json',
  './icons/icon.svg',
  './assets/logo-arara.png',
  './assets/arara-original.jpg',
  './assets/login-araras.jpg'
];

// Instalação do Service Worker
self.addEventListener('install', (event) => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[YBYgram SW] Pré-armazenando shell da aplicação');
      return cache.addAll(ASSETS_TO_CACHE);
    })
  );
});

// Ativação e limpeza imediata de caches antigos
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            console.log('[YBYgram SW] Removendo cache legado:', key);
            return caches.delete(key);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Interceptação com estratégia Network-First para sempre exibir a versão mais recente
self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;

  const url = new URL(event.request.url);

  // Não intercepta chamadas de mídia de terceiros ou streaming de vídeo (.mp4 / Range)
  if (
    event.request.headers.get('range') ||
    url.pathname.endsWith('.mp4') ||
    url.origin.includes('odysee.com') ||
    url.origin.includes('youtube.com') ||
    url.origin.includes('unsplash.com')
  ) {
    return;
  }

  event.respondWith(
    fetch(event.request, { cache: 'no-store' })
      .then((networkResponse) => {
        if (networkResponse && networkResponse.status === 200) {
          const responseClone = networkResponse.clone();
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, responseClone);
          });
        }
        return networkResponse;
      })
      .catch(() => {
        return caches.match(event.request).then((cachedResponse) => {
          if (cachedResponse) return cachedResponse;
          if (event.request.mode === 'navigate') {
            return caches.match('./index.html');
          }
        });
      })
  );
});
