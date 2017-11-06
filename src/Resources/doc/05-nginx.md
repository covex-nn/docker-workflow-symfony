Настройка Nginx на серверах с Docker
====================================

Конфигурация HTTP-домена происходит в 3 этапа

## Создание конфигурационного файла

Пример конфигурация для домена `site-dev1.ru`

Здесь `192.168.10.10` - содержимое переменной `NETWORK_IP_MASTER` из настроек репозитория разработчика `dev1` 

```
server {
    listen 80;
#    listen 443 ssl;

    server_name site-dev1.ru;
#    ssl_certificate /etc/letsencrypt/live/site-dev1.ru/fullchain.pem;
#    ssl_certificate_key /etc/letsencrypt/live/site-dev1.ru/privkey.pem;
#    if ($ssl_protocol = "") {
#        rewrite ^/(.*) https://$server_name/$1 permanent;
#    }

    location / {
        proxy_pass http://192.168.10.10;
        include proxy_params;
    }

    location ~ /.well-known {
        allow all;
        alias /var/lib/letsencrypt/.well-known;
    }
}
```
    
## Создание SSL-сертификата

```
/root/certbot-auto certonly \
  --no-self-upgrade \
  --webroot \
  -d site-dev1.ru \
  -w /var/lib/letsencrypt
```

## Переключение с HTTP на HTTPS 

Нужно раскоментировать строки в конфигурации HTTP-домена и перегрузить Nginx

```
nginx -t
service nginx reload
```
