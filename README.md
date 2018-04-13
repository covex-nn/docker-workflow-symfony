Docker for Symfony Flex
=======================

This repository is a skeleton of `Symfony Flex` application for development and deployment with `docker-compose`.
It contains a set of [GitLab CI/CD Pipeline][1] procedures for almost zero deployment downtime.

Only trusted base docker images are used at all stages from development to production: 

* `nginx:mainline`
* `php:7.2-fpm-stretch`
* `mysql:5.7`
* `phpmyadmin/phpmyadmin`

Use `composer` to create a new Symfony Flex application:

```bash
composer create-project covex-nn/docker-symfony .
```

To initialize and run a new application with `PHP-builtin web-server` use following commands (only `MySQL` and
`phpMyAdmin` will be started with `docker-compose`):

```bash
docker-compose up -d
phing
php -S localhost:80 -t public
```

To initialize application and run `nginx` and `php-fpm` inside docker use following commands:

```bash
cp docker-compose.override.yml.dist docker-compose.override.yml
docker-compose up -d
docker-compose exec php phing    
```

Endpoint image for container with `php-fpm`, built with [Dockerfile](Dockerfile), contains:

* PHP extensions `intl`, `mbstring`, `mcrypt`, `pdo_mysql`, `zip`, `opcache` и `xdebug` (for dev-environment only)
* `cron` (for prod-environment only). Add your crontab jobs to `docker/php/app.crontab`

Also visit [wiki][2] to review complete instructions for installation and configuration    

[1]: https://about.gitlab.com/features/gitlab-ci-cd/
[2]: https://github.com/covex-nn/docker-workflow-symfony/wiki
