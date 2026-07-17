FROM php:8.4-apache

RUN apt-get update && apt-get install -y \
    git unzip zip libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN cp .env.example .env || true

RUN php artisan key:generate || true

RUN chown -R www-data:www-data storage bootstrap/cache

RUN a2enmod rewrite

EXPOSE 80

CMD ["apache2-foreground"]