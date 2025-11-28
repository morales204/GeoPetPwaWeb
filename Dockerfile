FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    git unzip curl pkg-config protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instala gRPC PHP sin compilar la extensión nativa
RUN composer require grpc/grpc google/protobuf

WORKDIR /var/www/html
EXPOSE 9000
CMD ["php-fpm"]

