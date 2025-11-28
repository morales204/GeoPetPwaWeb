FROM php:8.2-fpm

# Dependencias del sistema
RUN apt-get update && apt-get install -y \
    git unzip libz-dev libssl-dev libcurl4-openssl-dev pkg-config \
    libprotobuf-dev protobuf-compiler && \
    rm -rf /var/lib/apt/lists/*

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instala GRPC versión compatible con PHP 8.2
RUN pecl install grpc-1.57.0 \
    && echo "extension=grpc.so" > /usr/local/etc/php/conf.d/grpc.ini

# Copia proyecto Laravel
WORKDIR /var/www/html
COPY . .

# Instala dependencias backend
RUN composer install --no-dev --optimize-autoloader

# Exponer puerto
EXPOSE 9000

CMD ["php-fpm"]
