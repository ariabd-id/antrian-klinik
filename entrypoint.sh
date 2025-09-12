#!/bin/bash

set -e

# Wait for the database to be ready
until mysqladmin ping -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" --skip-ssl --silent; do
    echo "Waiting for database connection..."
    sleep 2
done

echo "Database is ready!"

# Run migrations
php artisan migrate --force

# Recreate storage link for other parts of the app
if [ -L "public/storage" ]; then
    rm public/storage
fi
php artisan storage:link

# Force storage permissions
echo "Forcing storage permissions..."
find /var/www/html/storage -type d -exec chmod 755 {} \;
find /var/www/html/storage -type f -exec chmod 644 {} \;

# Clear and cache configuration
echo "Clearing and caching configuration..."
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan event:cache

# Start PHP-FPM
echo "Starting PHP-FPM..."
php-fpm