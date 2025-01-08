#!/bin/bash
set -e

echo "Starting Symfony Script :)"
echo "Using Symfony Version: ${SYMFONY_VERSION}"
echo "Using PHP Version: ${PHP_VERSION}"

if [ -f composer.json ]; then
  echo "A composer.json file exists, skipping the install of Symfony Skeleton."
else
  echo "A composer.json doesn't exist, creating Symfony Skeleton."

  # Create Symfony Skeleton projectcomposer create-project laravel/laravel:^9
  composer create-project "laravel/laravel:^9" tmp --no-progress --no-interaction || {
    echo "Error: Download of Laravel failed."
    exit 1
  }

  # Move directory contents to the current directory
    mv tmp/* tmp/.* . 2>/dev/null || true
    rm -rf tmp/

  # Basic Skeleton Install
  composer require "php:>=$PHP_VERSION" --no-progress --no-interaction
fi


# Composer Check
if composer validate --strict; then
    echo "composer.json is valid."
else
    echo "composer.json is invalid."
    exit 1
fi

#
## Dependencies Install
#if [ -z "$(ls -A 'vendor/' 2>/dev/null)" ]; then
#  echo "The vendor file doesn't exist. Installing dependencies"
#  composer install --prefer-dist --no-progress --no-interaction
#else
#   echo "The vendor file exist. skipping dependencies install"
#fi


# Mark container as healthy
touch /tmp/healthy
echo "Container is now healthy."

exec docker-php-entrypoint "$@"