php:8.5.12-apache image:
------------------------
Entrypoint: /usr/local/bin/docker-php-entrypoint
CMD: apache2-foreground
$ php artisan key:generate   <-auto file APP_KEY in .env file

.env file:
----------
.If you want to use web installer **DO NOT** create `.env` file manually. 
 If `.env` file exists in the root of your app, web installer won't run.

.After modify .env file, run
$ php artisan freescout:clear-cache

Dockerfile:
-----------
- RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
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
  .Install PHP extensions required by FreeScout.
  .Source extensions: /usr/src/php/ext/
  .Libraries have been installed in:
  /usr/local/lib/php/extensions/no-debug-non-zts-20250925/
  
- RUN a2enmod rewrite
  will create a link rewrite.load in /etc/apache2/mods-enabled/
  Same as:
  $ ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

- RUN a2enmod headers
  mod_headers is needed to secure uploads folder

- COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
  Copy composer binary from composer:latest image

FreeScout includes webklex/php-imap natively as its core email-fetching engine, meaning you do not need to install it manually. As of FreeScout version 1.8.140, the developers completely replaced the old PHP IMAP extension with this native PHP library


Debug:
------
$ docker logs freescout-app
$ docker logs freescout-db
