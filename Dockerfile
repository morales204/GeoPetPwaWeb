FROM php:8.3-fpm

# 1. Dependencias necesarias para GRPC / Firestore
RUN apt-get update && apt-get install -y \
    git unzip curl pkg-config protobuf-compiler \
    libssl-dev zlib1g-dev g++ autoconf make libtool \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar composer dentro del contenedor
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 3. Instalar extensión grpc
RUN pecl install grpc-1.51.3 \
    && echo "extension=grpc.so" > /usr/local/etc/php/conf.d/grpc.ini

# 4. Copiar proyecto
WORKDIR /var/www/html
COPY . .

# 5. Instalar dependencias Laravel
RUN composer install --no-interaction --no-dev --prefer-dist --optimize-autoloader

# 6. Copiar entrypoint para ejecutar comandos Laravel en runtime
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=9000"]
