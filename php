#!/bin/bash
docker run --rm -i \
-v /home/{username}:/home/{username} \
-v $PWD:/code \
-w /code \
php:7.4-fpm-alpine php "$@"
