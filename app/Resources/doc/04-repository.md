Создание репозитория
====================

## Основной репозиторий

Основной репозиторий проекта может находиться в произвольной группе.

### Настроить основной репозиторий

Настройки в разделе `Settings --> CI/CD Pipelines`

* Git strategy for pipelines [x] git clone

* Public pipelines [ ]

* Создать переменные

|Переменная|Значение|
| -------- | ------ |
|COMPOSER_GITHUB_TOKEN|Создать токен на странице https://github.com/settings/tokens|
|SSH_PRIVATE_KEY|заполнить её содержимым файла id_rsa пользователя `master`|
|NETWORK_NAME_MASTER|graynetwork|
|SERVER_NAME_MASTER|site-staging.ru|
|NETWORK_IP_MASTER|выбрать свободный IP в подсети graynetwork|
|NETWORK_NAME_PRODUCTION|graynetwork|
|SERVER_NAME_PRODUCTION|site-production.ru|
|NETWORK_IP_PRODUCTION|выбрать свободный IP в подсети graynetwork|
|DEPLOY_USER_MASTER|master|
|DEPLOY_HOST_MASTER|docker-server-prod.ru|
|DEPLOY_DIRECTORY_MASTER|/home/master/site-staging.ru|
|DEPLOY_USER_PRODUCTION|master|
|DEPLOY_HOST_PRODUCTION|docker-server-prod.ru|
|DEPLOY_DIRECTORY_PRODUCTION|/home/master/site-production.ru|
|PROJECT_FORKS|<оставить пустым>|

* Залить ветку `master` в репозиторий

    ```
    git push origin master
    ```

## Репозиторий разработчика

Репозиторий разработчика должен находиться в группе проектов разработчика.
Для пользователя `dev1` - это `dev1-projects`
 
Репозиторий разработчика создаётся путём создания Fork администратором из основного репозитория.

### Настройка репозитория разработчика в `Settings --> CI/CD Pipelines`

* Git strategy for pipelines [x] git clone

* Public pipelines [ ]

* Создать переменные

|Переменная|Значение|
| -------- | ------ |
|COMPOSER_GITHUB_TOKEN|Создать токен на странице https://github.com/settings/tokens|
|SSH_PRIVATE_KEY|заполнить её содержимым файла id_rsa пользователя `dev1`|
|NETWORK_NAME_MASTER|graynetwork|
|SERVER_NAME_MASTER|site-dev1.ru|
|NETWORK_IP_MASTER|выбрать свободный IP в подсети graynetwork|
|DEPLOY_USER_MASTER|dev|
|DEPLOY_HOST_MASTER|docker-server-dev.ru|
|DEPLOY_DIRECTORY_MASTER|/home/dev1/site-dev1.ru|
|PROJECT_FORKS|<оставить пустым>|

### Настройка репозитория разработчика

В разделе `Settings --> Repository`

* Unprotect ветку master
* Protect ветку stable
* Protect все тэги

Создать ветку `stable` в том же месте, что и `master` 

Запустить Pipeline для ветки `master`

Выдать роль `Developer` пользователю `dev1` в репозитории разработчика 

### Настройка основного репозитория

Добавить новую строку с адресом репозитория разработчика в переменную `PROJECT_FORKS` в основном репозитории

Выдать роль `Reporter` пользователю `dev1` в основном репозитории 
