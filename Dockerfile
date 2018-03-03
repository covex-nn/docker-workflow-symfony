FROM covex/php7.2-fpm:latest

WORKDIR /srv

ENV APP_ENV=prod

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
    && chmod 755 docker/php/start.sh \
    && composer dump-autoload --no-dev --optimize \
    && phing app-deploy -Dsymfony.env=prod \
    && cat docker/php/app.crontab > /var/spool/cron/crontabs/root

ENTRYPOINT [ "/srv/docker/php/start.sh" ]
CMD [ "php-fpm" ]
