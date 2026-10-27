# Use PHP with Apache as the base image
FROM php:8.5.12-apache

# Install required system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions needed for FreeScout
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install -j$(nproc) \
        gd \
        imap \
        bcmath \
        ctype \
        fileinfo \
        intl \
        mbstring \
        mysqli \
        pdo_mysql \
        xml \
        zip \
        openssl \
        curl \
        pcntl \
        zlib

# Enable Apache rewrite module for Laravel routing
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Download the latest FreeScout stable release
RUN git clone https://github.com/freescout-help-desk/freescout . \
    && composer install --no-dev --optimize-autoloader

# Set appropriate permissions for Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Set the document root to FreeScout's public folder if needed
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}/!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Expose HTTP port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
