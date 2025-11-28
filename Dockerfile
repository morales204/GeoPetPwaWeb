FROM php:8.2-fpm

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    git unzip libz-dev libssl-dev libcurl4-openssl-dev pkg-config libprotobuf-dev protobuf-compiler

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instala extensiones de PHP necesarias
RUN pecl install grpc \
    && docker-php-ext-enable grpc

# Copia tu proyecto
WORKDIR /var/www/html
COPY . .

# Instala dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Expone el puerto
EXPOSE 9000

CMD ["php-fpm"]
