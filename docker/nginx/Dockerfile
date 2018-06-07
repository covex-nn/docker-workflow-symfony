ARG app_image=scratch
FROM nginx:mainline AS base

ARG server_name=docker.local
ARG server_upstream=dev

COPY default.conf /etc/nginx/conf.d/
COPY backend_${server_upstream}.conf.default /etc/nginx/conf.d/backend.conf

RUN sed -i 's/@SERVER_NAME@/'"$server_name"'/g' /etc/nginx/conf.d/default.conf



FROM ${app_image} AS app
FROM base AS prod

COPY --from=app /srv/public/ /srv/public/
