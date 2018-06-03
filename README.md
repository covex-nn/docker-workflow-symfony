Symfony Flex application skeleton with docker support
===

This repository is a skeleton of `Symfony Flex` application for development and
deployment with `docker-compose`. It contains a set of [GitLab CI/CD Pipeline][1]
procedures for almost zero deployment downtime.

Only trusted base docker images are used at all stages from development to production:

* `nginx:mainline`
* `php:7.2-fpm-stretch`
* `mysql:5.7`
* `phpmyadmin/phpmyadmin`

This repository is a `symfony/skeleton` composer project, bootstrapped by
[Environment configurator][3] by the following commands:

```bash
composer global require covex-nn/environment
composer create-project symfony/skeleton .
composer env:apply docker-ci
```

Usage
---

Use `composer` to create a new Symfony Flex application:

```bash
composer create-project covex-nn/docker-symfony .
```

Before launching `docker-compose`, add two records to `C:\WINDOWS\System32\Drivers\etc\hosts`
or `/etc/hosts` file:

    docker.local 127.0.0.1
    mysql 127.0.0.1
    
If you use Docker Toolbox, execute `docker-machine env`, get IP-address from `DOCKER_HOST`
variable and use that IP instead of `127.0.0.1`

To initialize and run a new application with `PHP-builtin web-server` use following
commands (only `MySQL` and `phpMyAdmin` will be started with `docker-compose`):

```bash
docker-compose up -d
phing
php -S localhost:80 -t public
```

But if you want to use `Nginx` as Web server, or if you do not have `PHP 7.2` installed
on your host, execute the following instead:

```bash
cp docker-compose.override.yml.dist docker-compose.override.yml
docker-compose up -d
phing
```

Endpoint image for container with `php-fpm`, built with [Dockerfile](Dockerfile), contains:

* PHP extensions `intl`, `mbstring`, `mcrypt`, `pdo_mysql`, `zip`, `opcache` и `xdebug` (for dev-environment only)
* `cron` (for prod-environment only). Add your crontab jobs to `docker/php/app.crontab`

Also visit [wiki][2] to review complete instructions for installation and configuration:

[1]: https://about.gitlab.com/features/gitlab-ci-cd/
[2]: https://github.com/covex-nn/docker-workflow-symfony/wiki
[3]: https://github.com/covex-nn/env-configurator
