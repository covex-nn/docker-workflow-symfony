Dev-environment
---------------

* `docker-compose up -d`
* `docker-compose exec php phing`
* ...

CI
---

* `git clone ...`
* `docker build -t docker-lemp .`
* `docker push docker-lemp`

Prod-environment
----------------

* @see .env
* `export APP_PHP=app`
* `docker-compose -f docker-remote.yml up -d`
