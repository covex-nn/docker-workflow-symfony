Настройка параметров Symfony
============================

Данная инструкция покажет как внедрить параметры для проекта
начиная от окружения разработчика, заканчивая Production

## Локальное окружение разработчика

1. Добавить дефолтные значение переменной в файл `.env`

    ```
    ENV_hwi_facebook_client_id=1234
    ENV_hwi_facebook_client_secret=4567
    ```

2. Добавить информацию о переменной в файл `docker-common.yml`

    Так значения переменных попадают в окружение контейнера `php`

    ```
    services:
        php:
            environment:
                ENV_hwi_facebook_client_id: "${ENV_hwi_facebook_client_id}"
                ENV_hwi_facebook_client_secret: "${ENV_hwi_facebook_client_secret}"
    ```

3. Добавить параметр в файл `app/config/parameters.yml`

    Файл `app/config/parameters.yml` является часть приложения

    ```
    parameters:
        hwi_facebook_client_id: "%env(ENV_hwi_facebook_client_id)%"
        env(ENV_hwi_facebook_client_id): ~
        hwi_facebook_client_secret: "%env(ENV_hwi_facebook_client_secret)"
        env(ENV_hwi_facebook_client_secret): ~
    ```

4. Перезапустить `docker-compose`

    ```
    docker-compose stop
    docker-compose up -d
    ```

## Тестовый сайт разработчика

Перед выкаткой изменений на тестовый сайт разработчика,
администратор должен добавить значения переменных для этого сайта в разделе
`Settings --> CI/CD Pipelines`

К именам переменных должен быть добавлен суффикс `_MASTER`

```
ENV_hwi_facebook_client_id_MASTER
ENV_hwi_facebook_client_secret_MASTER
```

Если переменные не будут созданы, значения для них будут браться из файла `.env`

## Staging

В основной репозиторий нужно добавить переменные с суффиксом `_MASTER`, как это было сделано для тестового сайта разработчика.

После принятия Merge Request и внедрения изменений на `staging` нужно
добавить переменные во все остальные репозитории разработчиков,
если это необходимо.

## Production

В основной репозиторий нужно добавить переменные с суффиксом `_PRODUCTION`, как это было сделано для тестового сайта разработчика.
