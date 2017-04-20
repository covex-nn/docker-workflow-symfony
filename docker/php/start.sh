#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

setfacl -R -m u:"www-data":rwX -m u:`whoami`:rwX /srv/var
setfacl -dR -m u:"www-data":rwX -m u:`whoami`:rwX /srv/var

exec "$@"
