FROM covex/php7.1-fpm:1.0

WORKDIR /srv

COPY composer.json ./
COPY composer.lock ./

RUN composer install \
        --prefer-dist \
        --no-scripts \
        --no-autoloader \
        --no-dev \
        --no-interaction

COPY . ./
RUN chmod -R -x+X /srv \
    && composer dump-autoload --optimize \
    && phing deploy
