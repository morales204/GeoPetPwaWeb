
(function(){
  try {
    const link = document.createElement('link');
    link.rel = 'manifest';
    link.href = '/manifest.json';
    document.head.appendChild(link);
  } catch (e) { console.warn('No head to append manifest to', e); }

  // register service worker
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/sw.js').then(() => {
      console.log('Service Worker registrado');
    }).catch((err) => console.warn('SW registration failed:', err));
  }

})();
