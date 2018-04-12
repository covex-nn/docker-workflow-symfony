Symfony для Docker
==================

__Symfony для Docker__ - это шаблон приложения для разработки с использованием [Docker][9] и [docker-compose][10]

__Symfony для Docker__ - это набор процедур непрерывной интеграции/внедрения
изменений через [GitLab CI/CD Pipelines][8] от локального окружения разработчика
до production с практически нулевым deployment downtime.

__Symfony для Docker__ включает в себя:

* PHP 7.2 
* [FOSUserBundle][2]
* [SonataAdminBundle][3]
* Базовый twig-шаблон с подключёнными [Bootstrap][6] и [Jquery][7] в `templates/base.html.twig`

Вместе с __Symfony для Docker__ на разных этапах используются следующие образы Docker  

* `nginx:mainline`

* `php:7.2-fpm-stretch`

    PHP-FPM с установленными модулями `intl`, `mbstring`, `mcrypt`, `pdo_mysql`, `zip`, `opcache`.
    `xdebug` установливается только в локальном окружении разработчика

    Установлен `acl` для правильной установки [прав доступа к файлам][14]

    Установлен `cron` для запуска периодических задач. Задачи должны быть описаны в файле `docker/php/app.crontab`

* `mysql:5.7`

* `phpmyadmin/phpmyadmin` - используется для досупа к БД в локальном окружении разработчика

Инструкция по установке, настройке и использованию __Symfony для Docker__ находится в директории [doc](doc)

[2]:  https://github.com/FriendsOfSymfony/FOSUserBundle
[3]:  https://github.com/sonata-project/SonataAdminBundle
[4]:  http://symfony.com/doc/current/frontend.html
[5]:  https://yarnpkg.com/
[6]:  https://www.npmjs.com/package/bootstrap
[7]:  https://www.npmjs.com/package/jquery
[8]:  https://about.gitlab.com/features/gitlab-ci-cd/
[9]:  https://docs.docker.com/
[10]: https://docs.docker.com/compose/
[14]: https://symfony.com/doc/current/setup/file_permissions.html#using-acl-on-a-system-that-supports-setfacl-linux-bsd
