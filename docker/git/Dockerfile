FROM debian:stretch-slim

RUN apt-get update && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/* /tmp/*

COPY ./ssh_config /etc/ssh/ssh_config

RUN chmod 644 /etc/ssh/ssh_config \
    && git config --global user.name "John Doe" \
    && git config --global user.email "doe@example.com"
