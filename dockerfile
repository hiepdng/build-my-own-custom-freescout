# Use PHP with Apache as the base image
FROM php:8.5.12-apache

# Install required system dependencies and PHP extensions
RUN apt-get update && apt-get install -y
RUN apt-get install libpng-dev -y
RUN apt-get install libjpeg-dev -y
RUN apt-get install libfreetype6-dev -y
RUN apt-get install libzip-dev -y
RUN apt-get install libicu-dev -y
RUN apt-get install libxml2-dev -y
RUN apt-get install ibonig-dev -y
RUN apt-get install libssl-dev -y
RUN apt-get install libcurl4-openssl-dev -y
RUN apt-get install git -y
RUN apt-get install zip -y
RUN apt-get install unzip -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions needed for FreeScout
#RUN docker-php-ext-configure imap --with-imap-ssl --with-kerberos \   #this is for php version <=8.3
#    && docker-php-ext-install -j$(nproc) imap
RUN mkdir -p /usr/src/php && tar Jxvf /usr/src/php.tar.xz -C /usr/src/php --strip-components=1
RUN cp /usr/src/php/ext/openssl/config0.m4 /usr/src/php/ext/openssl/config.m4
RUN cp /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4
RUN cd /usr/src/php/ext/gd && /usr/local/bin/phpize
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install ctype
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install intl
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip
RUN docker-php-ext-install openssl
RUN docker-php-ext-install curl
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install zlib
RUN rm -rf /usr/src/php

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer require webklex/php-imap

# Enable Apache rewrite module for Laravel routing
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Download the latest FreeScout stable release
RUN git clone https://github.com/freescout-help-desk/freescout.git . \
    && composer install --no-dev --optimize-autoloader

# Set appropriate permissions for Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Set the document root to FreeScout's public folder if needed
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}/!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Expose HTTP port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
