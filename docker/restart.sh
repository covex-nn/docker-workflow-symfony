#!/bin/sh

docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY
docker-compose pull

if [ -d $DEPLOY_DIRECTORY ]; then
    cd $DEPLOY_DIRECTORY
    docker-compose down --rmi local
    rm -rf $DEPLOY_DIRECTORY
fi

cp -r ''"$DEPLOY_DIRECTORY"'_tmp' $DEPLOY_DIRECTORY
cd $DEPLOY_DIRECTORY

docker-compose up -d --remove-orphans
docker-compose exec -T php phing app-deploy -Dsymfony.env=prod

rm -rf ''"$DEPLOY_DIRECTORY"'_tmp'
