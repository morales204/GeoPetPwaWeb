#!/bin/sh

# Si no existe APP_KEY, generarlo
if [ -z "$APP_KEY" ]; then
  echo "Generando APP_KEY..."
  php artisan key:generate --force
fi

# Cache de Laravel
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Iniciando aplicación..."
exec "$@"
