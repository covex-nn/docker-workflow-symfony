Инфраструктура
==============

Потребуется три сервера GitLab, Docker-для-production и Docker-для-разработки

## GitLab

1. Установка GitLab

    С инструкцией по установке GitLab можно ознакомиться на сайте [about.gitlab.com][1]

2. Настройка SSL-сертификата

    Создать SSL-сертификат можно с помощью сервиса [LetsEncrypt][2]
    
    Настроить Nginx в файле `/etc/gitlab/gitlab.rb`

    ```
    nginx['ssl_certificate'] = "/etc/letsencrypt/live/gitlab-server.ru/fullchain.pem"
    nginx['ssl_certificate_key'] = "/etc/letsencrypt/live/gitlab-server.ru/privkey.pem"
    ```
    
    Перегрузить GitLab
    
    ```
    gitlab-ctl restart
    ```
    
    Для настройки автоматического обновления сертификата нужно:
    
    1. добавить ещё одну строку в конфигурацию Nginx
    
        ```
        nginx['custom_gitlab_server_config'] = "location ^~ /.well-known { \n allow all;\n alias /var/lib/letsencrypt/.well-known/;\n default_type \"text/plain\";\n try_files $uri =404;\n }\n"
        ```
    
    2. перегрузить GitLab
    
    3. настроить crontab для обновления сертификатов
    
        ```
        41 0 * * * /root/certbot-auto renew --no-self-upgrade --webroot -w /var/lib/letsencrypt --renew-hook "service nginx reload"
        ```

3. Настройка Container Registry
    
    С инструкцией по установке Container Registry можно ознакомиться на сайте [docs.gitlab.com][3]
    
    Добавить в файл конфигурации `/etc/gitlab/gitlab.rb` информацию о SSL-сертификате
    для Contaner Registry (будет использоваться тот же, что и для самого GitLab) и перегрузить GitLab

    ```
    registry_nginx['ssl_certificate'] = "/etc/letsencrypt/live/gitlab-server.ru/fullchain.pem"
    registry_nginx['ssl_certificate_key'] = "/etc/letsencrypt/live/gitlab-server.ru/privkey.pem"
    ```


## Docker для production

С инструкцией по установке Container Registry можно ознакомиться на сайте [docs.docker.com][4]

Дополнительно нужно создать локальную сеть для назначения контейнерам внутренних IP адресов

```
docker network create graynetwork --gateway 192.168.10.1 --subnet 192.168.10.0/24
```

Кроме Docker на сервер нужно установить `nginx` и `certbot-auto` от [LetsEncrypt][2]

Nginx будет проксировать запросы к веб-серверам в контейнерах Docker. С инструкцией по установке Nginx можно ознакомиться на сайте [nginx.org][6]

Обновление будущих SSL-сертификатов должно быть настроено сразу же так, как с на сервере с GitLab.

```
41 0 * * * /root/certbot-auto renew --no-self-upgrade --webroot -w /var/lib/letsencrypt --renew-hook "service nginx reload"
```


## Docker для разработки

Нужно выполнить все пункты установки Docker для production и дополнительно на сервер нужно установить GitLab CI Runner

С инструкцией по установке GitLab Runner можно ознакомиться на сайте [docs.docker.com][4]

Запуск GitLab Runner

```
gitlab-ci-multi-runner verify --delete
printf "concurrent = 10\ncheck_interval = 0\n\n" > /etc/gitlab-runner/config.toml
gitlab-ci-multi-runner register -n \
   --url https://gitlab-server.ru/ \
   --registration-token <token> \
   --tag-list "executor-docker,docker-in-docker" \
   --executor docker \
   --description "docker-dev" \
   --docker-image "docker:latest" \
   --docker-volumes "/composer/home/cache" \
   --docker-volumes "/root/.composer/cache" \
   --docker-volumes "/var/run/docker.sock:/var/run/docker.sock"
```

Токен `<token>` нужно скопировать из Web-интерфейсе GitLab в разделе `Admin Area -> Runners`


[1]: https://about.gitlab.com/installation/
[2]: https://certbot.eff.org/docs/using.html
[3]: https://docs.gitlab.com/ce/administration/container_registry.html
[4]: https://docs.docker.com/engine/installation/
[5]: https://docs.gitlab.com/runner/install/linux-repository.html
[6]: http://nginx.org/ru/docs/install.html
