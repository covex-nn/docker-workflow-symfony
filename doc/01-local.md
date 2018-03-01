Установка окружения разработчика
================================

1. Скачать и установить [**Docker Toolbox и VirtualBox**][1]

2. Создать Docker Machine

    ```
    docker-machine create --driver virtualbox default
    docker-machine start default
    ```

3. Настроить Docker Machine

    Содержимое результата выполнения команды `docker-machine env default` записать в переменные среды.
    
    Например, в Windows 8 нужно перейти в Компьютер - Свойства - Дополнительные параметры системы - Дополнительно - Переменные среды...

    ```
    C:\>docker-machine env default
    You can further specify your shell with either 'cmd' or 'powershell' with the --shell flag.

    SET DOCKER_TLS_VERIFY=1
    SET DOCKER_HOST=tcp://192.168.99.100:2376
    SET DOCKER_CERT_PATH=C:\Users\Пользователь\.docker\machine\machines\default
    SET DOCKER_MACHINE_NAME=default
    SET COMPOSE_CONVERT_WINDOWS_PATHS=true
    REM Run this command to configure your shell:
    REM     @FOR /f "tokens=*" %i IN ('"C:\Program Files\Docker Toolbox\docker-machine.EXE" env default') DO @%i
    ```
    
    Здесь нужно создать 5 переменных от `DOCKER_TLS_VERIFY` до `COMPOSE_CONVERT_WINDOWS_PATHS`
    
    Для macOS нужно дополнительно настроить машину, чтобы она корректно работала с NFS разделами.
    Дело в том, что [при использовании docker-machine на macOS появляется проблема с доступами к файлам][6]: 
    владелец и права на файлы не меняются на примонтированных nfs томах.
    
    Один из способов решения - использовать [docker-machine-nfs][5]:
    
    ```
    brew install docker-machine-nfs
    docker-machine-nfs default
    ```
      
4. Добавить запись в файл `C:\WINDOWS\System32\Drivers\etc\hosts`

    ```
    192.168.99.100		docker.local
    192.168.99.100		mysql
    ```
    
    где `192.168.99.100` - это IP адрес из переменной `DOCKER_HOST`

5. Запуск проекта в Docker

    Внутри папки пользователя (обязательно), например в `C:\Users\Пользователь\Docker` клонировать или скачать репозиторий проекта
 
    `C:\Users\Пользователь\Docker> git clone git@github.com:covex-nn/docker-workflow-symfony.git`

    Запустить `docker-compose` и инициализировать проект
    
    ```
    cd docker-workflow-symfony
    docker-compose up -d
    docker-compose exec php phing    
    ```
    
    Сайт проекта будет доступен по адресу http://docker.local/

6. Установка [Webpack Encore][2]

    ```
    docker-compose exec php composer require webpack-encore
    ```

    Установите [Nodejs][3], а затем [пакетный менеджер yarn][4]
    
    ```
    npm install --global npm
    npm install --global yarn
    ```

    Установите зависимости проекта

    ```
    yarn install --pure-lockfile
    ```
    
    Подробнее об использовании [Webpack Encore][2] на сайте symfony.com

    
[1]: https://docs.docker.com/toolbox/toolbox_install_windows/
[2]: http://symfony.com/doc/current/frontend/encore/installation.html
[3]: https://nodejs.org/en/download/
[4]: https://yarnpkg.com/en/
[5]: https://github.com/adlogix/docker-machine-nfs
[6]: https://github.com/boot2docker/boot2docker/issues/581
