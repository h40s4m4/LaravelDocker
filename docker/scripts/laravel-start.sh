#!/bin/sh
set -e

LARAVEL_VERSION=${LARAVEL_VERSION:-"12.*"}
PHP_VERSION=${PHP_VERSION:-"8.2"}

echo "🚀 Starting Laravel Script"
echo "Laravel Version: ${LARAVEL_VERSION}"
echo "PHP Version: ${PHP_VERSION}"

# Crear proyecto Laravel si no existe
if [ ! -f composer.json ]; then

    echo "No composer.json found — creating Laravel project."
    #Create Laravel project in tmp directory
    composer create-project "laravel/laravel:^${LARAVEL_VERSION}" tmp --prefer-dist --no-progress --no-interaction || {
      echo "Error: Download of Laravel failed."
      exit 1
    }

   # Move directory contents to the current directory
   mv tmp/* tmp/.* . 2>/dev/null || true
   rm -rf tmp/
fi

# Validar composer.json
if composer validate --strict; then
    echo "composer.json is valid ✅"
else
    echo "composer.json is invalid ❌"
    exit 1
fi

# Permisos
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Instalar dependencias si no existen
if [ ! -d "vendor" ] || [ -z "$(ls -A vendor/)" ]; then
    echo "Installing dependencies..."
    composer install --prefer-dist --no-progress --no-interaction
else
    echo "Dependencies already installed. Skipping."
fi

# Marcar contenedor como saludable
touch /tmp/healthy
echo "Container marked as healthy ✅"

# Ejecutar PHP-FPM
exec docker-php-entrypoint "$@"
