Docker для Symfony Flex
=======================

__Docker для Symfony__ - это шаблон Flex приложения для разработки с использованием [Docker][2] и [docker-compose][3]

__Docker для Symfony__ - это набор процедур непрерывной интеграции/внедрения
изменений через [GitLab CI/CD Pipelines][1] от локального окружения разработчика
до production с практически нулевым deployment downtime.

Вместе с __Docker для Symfony__ на разных этапах используются следующие образы Docker

* `nginx:mainline`

* `php:7.2-fpm-stretch`

    PHP-FPM с установленными модулями `intl`, `mbstring`, `mcrypt`, `pdo_mysql`, `zip`, `opcache`.
    `xdebug` установливается только в локальном окружении разработчика

    Установлен `acl` для правильной установки [прав доступа к файлам][4]

    Установлен `cron` для запуска периодических задач. Задачи должны быть описаны в файле `docker/php/app.crontab`

* `mysql:5.7`

* `phpmyadmin/phpmyadmin` - используется для досупа к БД в локальном окружении разработчика

Инструкция по установке, настройке и использованию __Docker для Symfony Flex__ находится в директории [doc](doc)

[1]:  https://about.gitlab.com/features/gitlab-ci-cd/
[2]:  https://docs.docker.com/
[3]: https://docs.docker.com/compose/
[4]: https://symfony.com/doc/current/setup/file_permissions.html#using-acl-on-a-system-that-supports-setfacl-linux-bsd
