php:8.5.12-apache image:
------------------------
Entrypoint: /usr/local/bin/docker-php-entrypoint
CMD: apache2-foreground
$ php artisan key:generate   <-auto file APP_KEY in .env file

.env file:
----------
.If you want to use web installer **DO NOT** create `.env` file manually. 
 If `.env` file exists in the root of your app, web installer won't run.

.Force FreeScout to use the Webklex library which does not require 
 the native PHP IMAP extension
APP_NEW_FETCHING_LIBRARY=true
.For versions bypassing native IMAP extensions during POP3 fetching
APP_USE_NEW_POP3_LIB=true

.After modify .env file, run
$ php artisan freescout:clear-cache

-Some available environment varialbes:
.Core FreeScout and Laravel Variables
APP_NAME — Name of the application (default is FreeScout).
APP_ENV — Environment mode (usually production or local).
APP_KEY — Encryption key generated via php artisan key:generate.
APP_DEBUG — Enables/disables debug mode (true or false).
APP_URL — The public-facing base URL of your FreeScout installation (e.g., https://yourdomain.com).
APP_TIMEZONE — Application time zone (e.g., UTC, America/New_York).
APP_LOCALE — Default language/locale (e.g., en).
APP_PROXY — Configure if running behind a reverse proxy.
APP_TRUSTED_PROXIES — Trusted proxy IPs (* for all or comma-separated IPs).
APP_CUSTOM_MAIL_HEADERS — Custom headers for outgoing emails.
APP_UPDATE_FOLDER_COUNTERS_IN_BACKGROUND — Background job toggle for folder counts (true or false).
APP_REMOTE_HOST_WHITE_LIST — Allowed remote hosts.
SESSION_SECURE_COOKIE — Require HTTPS for session cookies (true or false).

.Database Configuration (MySQL / MariaDB / PostgreSQL)
DB_CONNECTION — Database driver type (e.g., mysql, pgsql). ￼
DB_HOST — Database server host (e.g., localhost or container name). ￼
DB_PORT — Database port (e.g., 3306). ￼
DB_DATABASE — Name of the database. ￼
DB_USERNAME — Database user. ￼
DB_PASSWORD — Database password (max length considerations apply depending on driver). ￼
DB_PREFIX — Optional table prefix for database tables.

.Caching, Session, and Queue Drivers
BROADCAST_DRIVER — Driver for broadcasting (default log).
CACHE_DRIVER — Cache backend (file, redis, memcached, etc.).
SESSION_DRIVER — Session storage driver (file, cookie, database, redis).
QUEUE_DRIVER or QUEUE_CONNECTION — Queue system driver (sync, redis, etc.).

.Redis (Optional)
REDIS_HOST — Redis server host.
REDIS_PASSWORD — Redis password.
REDIS_PORT — Redis port (default 6379).


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


FreeScout directory:
--------------------
.htaccess: is required by rewrite module using Apache
.env.example: required
.Make sure all files/dirs are under www-data:www-data owner
$ find /var/www/html -user root -exec chown www-data:www-data {} +

Debug:
------
$ docker logs freescout-app
$ docker logs freescout-db
