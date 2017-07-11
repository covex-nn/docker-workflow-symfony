FROM nginx:alpine
ARG server_port=80
ARG server_name=docker.local
ARG app_php=app_dev

COPY default.conf /etc/nginx/conf.d/

RUN sed -i 's/@SERVER_PORT@/'"$server_port"'/g' /etc/nginx/conf.d/default.conf \
    && sed -i 's/@SERVER_NAME@/'"$server_name"'/g' /etc/nginx/conf.d/default.conf \
    && sed -i 's/@APP@/'"$app_php"'/g' /etc/nginx/conf.d/default.conf
