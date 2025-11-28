FROM php:8.2-cli

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git unzip libz-dev libssl-dev pkg-config

# Instalar grpc vía pecl
RUN pecl install grpc \
    && docker-php-ext-enable grpc

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install --no-interaction --optimize-autoloader --no-scripts

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=3000"]
