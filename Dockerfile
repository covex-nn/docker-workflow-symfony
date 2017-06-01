FROM covex/php7.1-fpm:1.0

WORKDIR /srv

COPY composer.json ./
COPY composer.lock ./
COPY var/ ./var/

RUN composer config -g cache-dir ./var/cache/composer \
    && composer install \
        --prefer-dist \
        --no-scripts \
        --no-autoloader \
        --no-dev \
        --no-interaction

COPY . ./
RUN chmod -R -x+X . \
    && chmod 755 bin/console \
    && chmod 755 docker/php/start.sh \
    && composer dump-autoload --optimize \
    && sed 's/^/export /' .env > /tmp/.composer-run-script \
    && echo 'composer run-script post-install-cmd' >> /tmp/.composer-run-script \
    && chmod 755 /tmp/.composer-run-script \
    && sh /tmp/.composer-run-script \
    && rm /tmp/.composer-run-script \
    && composer clear-cache \
    && phing image-prepare

ENTRYPOINT [ "/srv/docker/php/start.sh" ]
CMD [ "php-fpm" ]
