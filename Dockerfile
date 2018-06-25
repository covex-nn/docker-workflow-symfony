ARG source_image=scratch
FROM debian:stretch-slim AS php

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
            apt-transport-https gnupg ca-certificates curl \
            cron netcat \
    && echo "deb https://packages.sury.org/php/ stretch main" >> /etc/apt/sources.list.d/sury.org.list \
    && curl -sS https://packages.sury.org/php/apt.gpg | apt-key add - \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
            php7.2-fpm \
            php7.2-intl \
            php7.2-mysql \
            php7.2-xml \
            php7.2-zip \
    && apt-get purge --autoremove -y gnupg \
    && apt-get clean -y \
    && curl -sS -L -o /usr/local/bin/phing http://www.phing.info/get/phing-latest.phar \
    && chmod +x /usr/local/bin/phing \
    && rm -rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/* /var/cache/* /var/log/* /tmp/*

WORKDIR /srv

COPY docker/php /etc/php/7.2/

EXPOSE 9000



FROM ${source_image} AS source_image



FROM php AS base

COPY --from=jakzal/phpqa:1.9.2-alpine /usr/local/bin/phpunit /usr/bin/composer /usr/local/bin/



FROM base AS dev

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
            php-xdebug \
    && apt-get clean -y \
    && mkdir -p /tmp/sessions \
    && chmod -R 777 /tmp/sessions

CMD ["php-fpm7.2"]



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

RUN cat docker/app.crontab > /var/spool/cron/crontabs/root

CMD ["php-fpm7.2"]
