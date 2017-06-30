Symfony для Docker
==================

__Symfony для Docker__ - это шаблон приложения для разработки с использованием [Docker][9] и [docker-compose][10]

__Symfony для Docker__, дополнительно вместе с пакетами из [Symfony Standard Edition][1], включает в себя:
 
* [FOSUserBundle][2]
* [SonataAdminBundle][3]
* Управление CSS и Javascript файлами используя [Webpack Encore][4] и [Yarn][5]
* Базовый twig-шаблон с подключёнными [Bootstrap][6] и [Jquery][7] в `app/Resource/views/base.html.twig` 

__Symfony для Docker__ - это набор процедур непрерывной интеграции/внедрения
изменений через [GitLab CI/CD Pipelines][8] от локального окружения разработчика до production

Вместе с __Symfony для Docker__ на разных этапах используются следующие образы Docker  

* `nginx:alpine`

* `mysql:5.7`

* `phpmyadmin/phpmyadmin` - используется для досупа к БД в локальном окружении разработчика

* [covex/docker-compose:1.0][11] - `docker-compose` внутри docker-контейнера

* [covex/alpine-git:1.0][13] - Alpine Linux с установленнымb `bash`, `openssh-client` и `git`

* [covex/php7.1-fpm:1.0][12] 

    PHP-FPM с установленными модулями `intl`, `mbstring`, `mcrypt`, `pdo_mysql`, `zip`, `opcache`.         
    `xdebug` установлен, но включён только в локальном окружении разработчика
    
    Установлен `acl` для правильной установки [прав доступа к файлам][14]
    
    Установлен и настроен `composer`. Папка `vendor` находится внутри контейнера и не оказывает влияние на быстродействие в локальном окружении разработчика

    Для функционирования функции `autocomplete` в IDE код папки `vendor` синхронизируется с хостом в виде `phar` архивов

Инструкция по установке, настройке и использованию __Symfony для Docker__ находится в директории [app/Resources/doc](app/Resources/doc)

[1]:  https://github.com/symfony/symfony-standard
[2]:  https://github.com/FriendsOfSymfony/FOSUserBundle
[3]:  https://github.com/sonata-project/SonataAdminBundle
[4]:  http://symfony.com/doc/current/frontend.html
[5]:  https://yarnpkg.com/
[6]:  https://www.npmjs.com/package/bootstrap
[7]:  https://www.npmjs.com/package/jquery
[8]:  https://about.gitlab.com/features/gitlab-ci-cd/
[9]:  https://docs.docker.com/
[10]: https://docs.docker.com/compose/
[11]: https://hub.docker.com/r/covex/docker-compose/
[12]: https://hub.docker.com/r/covex/php7.1-fpm/
[13]: https://hub.docker.com/r/covex/alpine-git/
[14]: https://symfony.com/doc/current/setup/file_permissions.html#using-acl-on-a-system-that-supports-setfacl-linux-bsd
