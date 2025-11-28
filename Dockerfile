FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    git unzip curl pkg-config protobuf-compiler libzip-dev zip build-essential autoconf \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ================================
# 📌 Instalar extensión GRPC requerida por Firestore
# ================================
RUN pecl install grpc \
    && echo "extension=grpc.so" > /usr/local/etc/php/conf.d/grpc.ini

# Librerías PHP que querías mantener
RUN composer global require grpc/grpc google/protobuf

WORKDIR /var/www/html
COPY . .

RUN composer install --no-interaction --prefer-dist --optimize-autoloader

EXPOSE 9000
CMD ["php-fpm"]
