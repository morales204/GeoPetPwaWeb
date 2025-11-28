# ----------------------------
# Imagen base con PHP + Caddy
# ----------------------------
FROM dunglas/frankenphp:php8.2.29-bookworm AS base

# -----------------------------------
# Instalar dependencias necesarias
# -----------------------------------
RUN apt-get update && apt-get install -y \
    git zip unzip curl pkg-config libssl-dev autoconf build-essential \
    && pecl install grpc \
    && docker-php-ext-enable grpc

# -----------------------------------
# Instalar Composer
# -----------------------------------
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# -----------------------------------
# Establecer directorio del proyecto
# -----------------------------------
WORKDIR /var/www/html

# Copiar archivos
COPY . .

# -----------------------------------
# Instalar dependencias PHP y JS
# -----------------------------------
RUN composer install --optimize-autoloader --no-dev \
    && npm install \
    && npm run build

# -----------------------------------
# Cache Laravel
# -----------------------------------
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    php artisan event:cache

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
