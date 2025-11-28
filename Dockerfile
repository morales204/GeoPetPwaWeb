FROM php:8.3-fpm

# Dependencias del sistema
RUN apt-get update && apt-get install -y \
    git unzip curl pkg-config protobuf-compiler libzip-dev zip \
    && rm -rf /var/lib/apt/lists/*

# Instala extensiones necesarias
RUN docker-php-ext-install pdo pdo_mysql

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiamos proyecto
WORKDIR /var/www/html
COPY . .

# Instalar dependencias Laravel
RUN composer install --no-dev --optimize-autoloader

# Generar APP_KEY automáticamente en Railway
RUN php artisan key:generate

# Exponer puerto Railway usa 8080
EXPOSE 8080

# Comando de arranque para que Laravel sea accesible en web
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
