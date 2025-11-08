const staticCacheName  = "pwa-v" + new Date().getTime();
const filesToCache = [
  '/manifest.json',
  '/js/pwa.js',
  '/images/boceto/ic_3_48.png',
  '/images/boceto/ic_3_72.png',
  '/images/boceto/ic_3_96.png',
  '/images/boceto/ic_3_144.png',
  '/images/boceto/ic_3_192.png',
  '/offline',             // Página offline genérica
  '/mascotas_offline'     
];

// Instalacion de cache
self.addEventListener("install", event => {
    this.skipWaiting();
    event.waitUntil(
        caches.open(staticCacheName)
            .then(cache => {
                return cache.addAll(filesToCache);
            })
    )
});


// Clear cache on activate
/* self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) return caches.delete(key);
        })
      )
    )
  );
  self.clients.claim();
}); */


// Activación: limpiar caches viejos
self.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames
                    .filter(cacheName => (cacheName.startsWith("pwa-")))
                    .filter(cacheName => (cacheName !== staticCacheName))
                    .map(cacheName => caches.delete(cacheName))
            );
        })
    );
});


// Serve from Cache
self.addEventListener("fetch", event => {
    // Solo interceptamos la ruta de mascotas
    if (event.request.url.includes('/mis-mascotas')) {
        event.respondWith(
            fetch(event.request)
                .catch(() => {
                    // Si no hay internet, mostrar la última cacheada
                    return caches.match('/mascotas_offline') || fetch('/mascotas_offline');
                })
        );
    } else {
        event.respondWith(
            caches.match(event.request)
                .then(response => response || fetch(event.request))
                .catch(() => caches.match('mascotas_offline'))
        );
    }
});
