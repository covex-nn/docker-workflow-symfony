#!/bin/sh

if [ -d $DEPLOY_DIRECTORY ]; then
    cd $DEPLOY_DIRECTORY
    docker-compose stop
    docker-compose rm -f
    rm -rf $DEPLOY_DIRECTORY
fi

cp -r ''"$DEPLOY_DIRECTORY"'_tmp' $DEPLOY_DIRECTORY
cd $DEPLOY_DIRECTORY
docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY
docker-compose up -d --build
docker-compose exec -T php php bin/console --env=prod doctrine:migrations:status
docker-compose exec -T php php bin/console --env=prod --no-interaction --allow-no-migration doctrine:migrations:migrate

rm -rf ''"$DEPLOY_DIRECTORY"'_tmp'
