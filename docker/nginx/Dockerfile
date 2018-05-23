FROM nginx:mainline
ARG server_port=80
ARG server_name=docker.local
ARG server_upstream=dev

COPY default.conf /etc/nginx/conf.d/
COPY *.conf.default /etc/nginx/

RUN cp '/etc/nginx/backend_'"$server_upstream"'.conf.default' /etc/nginx/conf.d/backend.conf \
    && sed -i 's/@SERVER_PORT@/'"$server_port"'/g' /etc/nginx/conf.d/default.conf \
    && sed -i 's/@SERVER_NAME@/'"$server_name"'/g' /etc/nginx/conf.d/default.conf
