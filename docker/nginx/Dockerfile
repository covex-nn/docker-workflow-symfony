FROM nginx:alpine
ARG server_name=docker.local
ARG app_php=app_dev

COPY default.conf upstream_php.conf-template upstream_spare.conf-template /etc/nginx/conf.d/
COPY upstream_php.conf-template /etc/nginx/conf.d/upstream.conf
COPY nginx-upstream-php.sh nginx-upstream-spare.sh /usr/local/bin/

RUN sed -i 's/@SERVER_NAME@/'"$server_name"'/g' /etc/nginx/conf.d/default.conf \
    && sed -i 's/@APP@/'"$app_php"'/g' /etc/nginx/conf.d/default.conf \
    && chmod 755 /usr/local/bin/nginx-upstream-php.sh /usr/local/bin/nginx-upstream-spare.sh
