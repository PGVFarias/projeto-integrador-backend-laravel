FROM php:8.2-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libpq-dev \
    zip \
    unzip \
    libzip-dev \
    git \
    curl

RUN docker-php-ext-install zip

RUN docker-php-ext-install pdo pdo_pgsql gd

RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=node:18.16.0-slim /usr/local/bin /usr/local/bin
COPY --from=node:18.16.0-slim /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 9000
CMD ["php-fpm", "-R"]
