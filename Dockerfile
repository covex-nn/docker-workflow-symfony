FROM php:7.2-fpm-stretch AS base

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer/home

COPY --from=composer:1.5 /usr/bin/composer /usr/bin/composer

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

WORKDIR /srv



FROM base AS dev

ENV APP_ENV="dev"
ENV APP_DEBUG="1"

COPY docker/php/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && chmod 644 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && adduser --system --no-create-home --uid 1000 --gid 50 docker \
    && mkdir -p /tmp/sessions \
    && chmod -R 777 /tmp/sessions



FROM base AS prod

ENV APP_ENV="prod"
ENV APP_DEBUG=""

COPY composer.json ./
COPY composer.lock ./
COPY auth.json ./

RUN composer install \
        --no-dev \
        --prefer-dist \
        --no-scripts \
        --no-autoloader \
        --no-interaction \
    && rm -rf $COMPOSER_HOME/cache/*

ADD . ./

RUN chmod -R -x+X . \
    && chmod 755 bin/console \
    && composer dump-autoload --no-dev --optimize \
    && phing app-deploy -Dsymfony.env=prod \
    && cat docker/php/app.crontab > /var/spool/cron/crontabs/root
