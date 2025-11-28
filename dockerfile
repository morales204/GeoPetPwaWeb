FROM php:8.3-fpm

# Instalar extensiones requeridas
RUN apk update && apk add --no-cache git curl unzip autoconf make g++ openssl-dev

# Instalar y habilitar GRPC
RUN pecl install grpc \
    && docker-php-ext-enable grpc

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install --optimize-autoloader --no-interaction --no-scripts

CMD ["php-fpm"]
