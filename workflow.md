Dev-environment
---------------

* `docker-compose up -d`
* `docker-compose exec php phing`
* ...

CI
---

* `git clone ...`
* `docker build -t docker-lemp --no-cache=true .`
* `docker push docker-lemp`

Prod-environment
----------------

* `export APP_PHP=app`
* ... see .env
* `docker-compose -f docker-remote.yml -f docker-networking.yml up -d`
