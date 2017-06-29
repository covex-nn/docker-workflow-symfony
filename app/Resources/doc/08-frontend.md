Управление файлам CSS и Javascript
==================================

Исходный код CSS и JS должен лежать в папке `/assets` репозитория

В [базовом шаблоне](../views/base.html.twig) используются 3 файла

* `global.scss` - CSS от Bootstrap
* `main.js` - jQuery + код для Bootstrap
* `app.js` - javascript-код приложения

Инструкция по использованию Webpack Encore находится на сайте [symfony.com][1]

Для frontend-разработчика доступны следующие команды

* `yarn run assets:dev` - запускает `webpack` для разработки
* `yarn run assets:watch` - запускает `webpack` для разработки с опцией `--watch`
* `yarn run assets:build` - формирует минимизированные файлы, готовые к отправке в репозиторий 

[1]: http://symfony.com/doc/current/frontend.html
