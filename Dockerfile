FROM covex/php7.1-fpm:latest

WORKDIR /srv

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

ENV APP_ENV=prod
ENV TRUSTED_PROXIES=0.0.0.0/0

RUN chmod -R -x+X . \
    && chmod 755 bin/console \
    && chmod 755 docker/php/start.sh \
    && composer dump-autoload --no-dev --optimize \
    && composer run-script post-install-cmd \
    && phing app-deploy -Dsymfony.env=prod \
    && cat docker/php/app.crontab > /etc/crontabs/root

ENTRYPOINT [ "/srv/docker/php/start.sh" ]
CMD [ "php-fpm" ]
