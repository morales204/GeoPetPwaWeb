FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    git unzip curl pkg-config protobuf-compiler libzip-dev zip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Mantienes tu instalación gRPC como pediste
RUN composer global require grpc/grpc google/protobuf

WORKDIR /var/www/html

# COPIA TU PROYECTO (antes no lo tenías bien puesto)
COPY . .

# 📌 Instalación de dependencias Laravel
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

EXPOSE 9000

CMD ["php-fpm"]
