Настройка Nginx с использованием docker-gen
===========================================

Использование `jwilder/docker-gen` на сервере с Docker позволит автоматически
конфигурировать внешний Nginx.

Перед использованием `docker-gen` нужно внести изменения в код проекта:

* Убрать все упоминания подсети `nw_external` в файле `docker-compose.deploy.yml`
* Убрать все переменные вида `NETWORK_NAME_*` и `NETWORK_IP_*` из конфигурации проекта в GitLab 

Тогда метка `docker-gen.host` сервиса `nginx` будет использоваться `docker-gen` для генерации конфигурации по шаблону 

## Установка, настройка, запуск docker-gen

[Инструкция по установке][1] docker-gen на хост находится в файле README.md проекта.
Поместите исполняемый файл `docker-gen` куда-либо в PATH, например, в `/usr/bin/docker-gen`.   

Конфигурацию `docker-gen` можно положить в файл `/etc/docker-gen.cfg`

```toml
[[config]]
template = "/etc/nginx/docker-gen.tmpl"
dest = "/etc/nginx/sites-available/docker-gen"
onlypublished = true
watch = true
notifycmd = "service nginx reload"
```

Шаблон для генерации конфигурации `nginx` можно положить в `/etc/nginx/docker-gen.tmpl`

```
#
# NOTE: THIS FILE IS GENERATED VIA docker-gen
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
{{ range $host, $containers := groupByLabel $ "docker-gen.host" }}
upstream {{ $host }}.docker {

{{ range $index, $value := $containers }}
    {{ $addrLen := len $value.Addresses }}
    {{ $network := index $value.Networks 0 }}

    {{/* If only 1 port exposed, use that */}}
    {{ if eq $addrLen 1 }}
        {{ with $address := index $value.Addresses 0 }}
            # {{$value.Name}}
            server {{ $network.IP }}:{{ $address.Port }};
        {{ end }}

    {{/* Else default to standard web port 80 */}}
    {{ else }}
        {{ range $i, $address := $value.Addresses }}
            {{ if eq $address.Port "80" }}
            # {{$value.Name}}
            server {{ $network.IP }}:{{ $address.Port }};
            {{ end }}
        {{ end }}
    {{ end }}
{{ end }}
}

server {
    listen 80;
    server_name {{ $host }};

    access_log off;
    error_log off;

    location ^~ /.well-known {
        allow all;
        alias /var/www/.well-known;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name {{ $host }};

    ssl_certificate /etc/letsencrypt/live/{{ $host }}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/{{ $host }}/privkey.pem;

    location / {
        proxy_pass http://{{ trim $host }}.docker;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        client_max_body_size 100m;
    }

    access_log off;
    error_log off;
}
{{ end }}
```

Тогда при запуске `docker-gen -config /etc/docker-gen.cfg` будет сформирован
файл `/etc/nginx/sites-available/docker-gen`, который можно подключать к конфигурации `nginx`.

В данном случае, SSL-сертификат уже должен быть выпущен. Порядок действий может быть следующим:

* Добавить `location ^~ /.well-known` в конфигурацию сервера по умолчанию внешнего `nginx`
* Создать домен и направить его в сервер с Docker
* Создать SSL-сертификат через LetsEncrypt
* Запустить pipeline в GitLab и выложить код проекта на сервер  

Запуск `docker-gen` можно доверить [systemd][2] или [upstart][3]

[1]: https://github.com/jwilder/docker-gen#host-install
[2]: https://github.com/jwilder/docker-gen/blob/master/examples/docker-gen.service
[3]: https://github.com/jwilder/docker-gen/blob/master/examples/docker-gen.upstart.conf
