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
* `docker-compose -f docker-compose-deploy.yml up -d`
