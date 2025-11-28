FROM php:8.2-cli

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git unzip libz-dev libssl-dev pkg-config

# Instalar extensiones PHP
RUN install-php-extensions grpc ctype curl dom fileinfo filter hash mbstring openssl pcre pdo session tokenizer xml

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install --no-interaction --optimize-autoloader --no-scripts

