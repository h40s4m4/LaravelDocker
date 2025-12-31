#!/bin/sh
set -e

# ---------------------------------
# Variables
# ---------------------------------
LARAVEL_VERSION=${LARAVEL_VERSION:-"12.*"}
APP_DIR=/var/www/html
STORAGE_DIR=${APP_DIR}/storage
CACHE_DIR=${APP_DIR}/bootstrap/cache

echo "🚀 Starting Laravel container"
echo "Laravel Version: ${LARAVEL_VERSION}"
echo "Running as user: $(whoami)"

# ---------------------------------
# Crear proyecto Laravel si no existe
# ---------------------------------
if [ ! -f "${APP_DIR}/composer.json" ]; then
    echo "No composer.json found — creating Laravel project."
    composer create-project laravel/laravel:^${LARAVEL_VERSION} ${APP_DIR}/tmp --prefer-dist --no-progress --no-interaction

    # Mover contenido al directorio final
    mv ${APP_DIR}/tmp/* ${APP_DIR}/
    mv ${APP_DIR}/tmp/.* ${APP_DIR}/ 2>/dev/null || true
    rm -rf ${APP_DIR}/tmp
fi

# ---------------------------------
# Validar composer.json
# ---------------------------------
if composer validate --strict; then
    echo "composer.json is valid ✅"
else
    echo "composer.json is invalid ❌"
    exit 1
fi

# ---------------------------------
# Instalar dependencias si faltan
# ---------------------------------
if [ ! -d "${APP_DIR}/vendor" ] || [ -z "$(ls -A ${APP_DIR}/vendor/)" ]; then
    echo "Installing dependencies..."
    composer install --prefer-dist --no-progress --no-interaction
else
    echo "Dependencies already installed. Skipping."
fi

# ---------------------------------
# Permisos correctos para Laravel
# ---------------------------------
# Solo asegurar storage y cache
chmod -R 775 ${STORAGE_DIR} ${CACHE_DIR}

# ---------------------------------
# Marcar contenedor como saludable
# ---------------------------------
touch /tmp/healthy
echo "Container marked as healthy ✅"

# ---------------------------------
# Ejecutar PHP-FPM
# ---------------------------------
exec docker-php-entrypoint "$@"