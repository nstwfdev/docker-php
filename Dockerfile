ARG PHP_VERSION=8.3

FROM php:${PHP_VERSION}-fpm

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apt-get update -y \
    && apt-get install -y \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libzip-dev \
      zip \
      unzip \
      curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && chmod +x /usr/local/bin/composer

RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    intl \
    mysqli \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    opcache \
    soap \
    sodium \
    sockets \
    xsl \
    zip \
    xdebug

WORKDIR /var/www

RUN groupmod -g ${GROUP_ID} www-data && \
    usermod -u ${USER_ID} -g ${GROUP_ID} www-data && \
    chown -R www-data:www-data /var/www

EXPOSE 9000

CMD ["php-fpm"]
