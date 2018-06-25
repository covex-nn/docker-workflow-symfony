ARG source_image=scratch
FROM nginx:1.14.0 AS base

ARG server_name=docker.local
ARG server_upstream=dev

COPY docker/nginx/default.conf /etc/nginx/conf.d/
COPY docker/nginx/backend_${server_upstream}.conf /etc/nginx/conf.d/backend.conf

RUN sed -i 's/@SERVER_NAME@/'"$server_name"'/g' /etc/nginx/conf.d/default.conf



FROM ${source_image} AS source



#FROM node:9-alpine as builder
#WORKDIR /srv
#COPY package.json package-lock.json webpack.config.js assets/ ./
#RUN npm install & npm run-script build



FROM base AS prod

COPY --from=source /srv/public/ /srv/public/
#COPY --from=builder /srv/public/ /srv/public/
