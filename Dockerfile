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
RUN chmod -R -x+X . \
    && chmod 744 bin/console \
    && setfacl -R -m u:"www-data":rwX -m u:`whoami`:rwX var \
    && setfacl -dR -m u:"www-data":rwX -m u:`whoami`:rwX var \
    && composer dump-autoload --optimize \
    && composer run-script post-install-cmd \
    && phing deploy -Dsymfony.env=prod
