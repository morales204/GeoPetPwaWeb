FROM dunglas/frankenphp:php8.2

# Instalar extensiones necesarias incluyendo GRPC
RUN install-php-extensions \
    ctype curl dom fileinfo filter hash mbstring openssl pcre pdo session tokenizer xml grpc

# Copiar archivos del proyecto
COPY . /app/

WORKDIR /app

# Instalar dependencias backend y frontend
RUN composer install --optimize-autoloader --no-dev --no-interaction
RUN npm ci && npm run build

# Optimizar Laravel
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    php artisan event:cache

CMD ["/start-container.sh"]
