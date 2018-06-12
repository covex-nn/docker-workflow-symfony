ARG source_image=scratch
FROM php:7.2.6-fpm-stretch AS php

WORKDIR /srv

RUN apt-get update && apt-get install -y \
            libicu-dev \
            zlib1g-dev \
            cron \
            netcat \
    && docker-php-ext-install -j$(nproc) \
            intl \
            opcache \
            pdo_mysql \
            zip \
    && curl -sS -L -o /usr/local/bin/phing http://www.phing.info/get/phing-latest.phar \
    && chmod +x /usr/local/bin/phing \
    && docker-php-source delete \
    && rm -rf /var/lib/apt/lists/* /tmp/*

#RUN apt-get update && apt-get install -y \
#            libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
#    && docker-php-ext-configure gd \
#            --with-freetype-dir=/usr/include/ \
#            --with-jpeg-dir=/usr/include/ \
#    && docker-php-ext-install -j$(nproc) \
#            gd



FROM ${source_image} AS source_image



FROM php AS base

COPY --from=jakzal/phpqa:1.9.2-alpine /usr/local/bin/phpunit /usr/bin/composer /usr/local/bin/



FROM base AS dev

COPY docker/php/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && chmod 644 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && adduser --system --no-create-home --uid 1000 --gid 50 docker \
    && mkdir -p /tmp/sessions \
    && chmod -R 777 /tmp/sessions \
    && rm -rf /tmp/*



FROM base AS source

ENV APP_ENV="prod"

COPY *.json *.lock ./

RUN composer check-platform-reqs \
    && composer install \
        --no-dev \
        --prefer-dist \
        --no-scripts \
        --optimize-autoloader \
        --no-interaction \
    && composer clear-cache

COPY . .

RUN chmod -R -x+X . \
    && chmod 755 bin/console \
    && phing app-deploy -Dsymfony.env=prod



FROM php AS prod

ENV APP_ENV="prod"

COPY --from=source_image /srv/ .

RUN cat docker/php/app.crontab > /var/spool/cron/crontabs/root
