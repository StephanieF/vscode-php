@echo off
docker run --rm -i ^
  -v "%USERPROFILE%:/home/%USERNAME%" ^
  -v "%CD%:/code" ^
  -w /code ^
  php:8.4.18-zts-alpine3.22 php %*
