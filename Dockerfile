FROM php:8.2-apache

ENV COMPOSER_ALLOW_SUPERUSER=1

# Activer les modules Apache
RUN a2enmod rewrite headers

# Installer Composer et les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    curl zip unzip git libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
 && docker-php-ext-install zip gd \
 && rm -rf /var/lib/apt/lists/*

# Copier l’API PHP dans un dossier dédié
COPY ./deployApi/ /var/www/html/api

# Copier l’app Angular dans la racine web Apache
COPY ./deployApp/ /var/www/html/

WORKDIR /var/www/html/api

# Installer les dépendances backend (API)
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer install --prefer-dist --no-dev --optimize-autoloader

EXPOSE 80
CMD ["apache2-foreground"]
