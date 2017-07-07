FROM covex/php7.1-fpm:1.0

WORKDIR /srv

COPY composer.json ./
COPY composer.lock ./
COPY auth.json ./

RUN composer install \
        --prefer-dist \
        --no-scripts \
        --no-autoloader \
        --no-dev \
        --no-interaction \
    && composer clear-cache

ADD . ./
RUN chmod -R -x+X . \
    && chmod 755 bin/console \
    && chmod 755 docker/php/start.sh \
    && composer dump-autoload --optimize \
    && phing app-deploy -Dsymfony.env=prod

ENTRYPOINT [ "/srv/docker/php/start.sh" ]
CMD [ "php-fpm" ]
