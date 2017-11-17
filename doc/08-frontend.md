Управление файлам CSS и Javascript
==================================

Исходный код CSS и JS должен лежать в папке `/assets` репозитория

В [базовом шаблоне](../templates/base.html.twig) используются 3 файла

* `global.scss` - CSS от Bootstrap
* `main.js` - jQuery + код для Bootstrap
* `app.js` - javascript-код приложения

Инструкция по использованию Webpack Encore находится на сайте [symfony.com][1]

Для frontend-разработчика доступны следующие команды

* `yarn run dev` - запускает `webpack` для разработки
* `yarn run watch` - запускает `webpack` для разработки с опцией `--watch`
* `yarn run build` - формирует минимизированные файлы, готовые к отправке в репозиторий 

[1]: http://symfony.com/doc/current/frontend.html
