FROM php:8.3-fpm AS base

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git unzip libz-dev libssl-dev libcurl4-openssl-dev pkg-config \
    libprotobuf-dev protobuf-compiler g++ autoconf make \
    && rm -rf /var/lib/apt/lists/*

# Copiar composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ⚠️ Instalar versión estable compatible con PHP 8.3
RUN pecl install grpc-1.56.3 \
    && echo "extension=grpc.so" > /usr/local/etc/php/conf.d/grpc.ini

# Opcional: instalar protobuf PHP
RUN pecl install protobuf \
    && echo "extension=protobuf.so" > /usr/local/etc/php/conf.d/protobuf.ini

WORKDIR /var/www/html

# Instala dependencias de tu proyecto
# COPY composer.json composer.lock ./
# RUN composer install --no-dev --prefer-dist --optimize-autoloader

CMD ["php-fpm"]
EXPOSE 9000
