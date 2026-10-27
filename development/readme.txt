dockerfile:
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
  Install PHP extensions required by FreeScout

- RUN a2enmod rewrite
  will create a link rewrite.load in /etc/apache2/mods-enabled/
  Same as:
  $ ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

- COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
  Copy composer binary from composer:latest image

