FROM php:8.3-fpm

# 1. Dependencias necesarias para compilar GRPC
RUN apt-get update && apt-get install -y \
    git unzip curl pkg-config protobuf-compiler \
    libssl-dev zlib1g-dev g++ autoconf make libtool \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar composer dentro del contenedor
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 3. Instalar GRPC PHP (versión estable para Firestore)
RUN pecl install grpc-1.51.3 \
    && echo "extension=grpc.so" > /usr/local/etc/php/conf.d/grpc.ini

# 4. Preparar proyecto
WORKDIR /var/www/html
COPY . .

# 5. Instalar dependencias del proyecto
RUN composer install --no-interaction --no-dev --prefer-dist --optimize-autoloader

EXPOSE 9000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=9000"]

