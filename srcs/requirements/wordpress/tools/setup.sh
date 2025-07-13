#!/bin/sh

# Wait for MariaDB to be ready echo "Waiting for MariaDB to be ready..."
MAX_TRIES=60
count=0

# First check if the host is reachable
while ! nc -z ${WORDPRESS_DB_HOST} 3306; do
    echo "MariaDB is not reachable yet... waiting"
    sleep 5
    count=$((count+1))
    if [ $count -ge $MAX_TRIES ]; then
        echo "Error: MariaDB host not reachable after $MAX_TRIES attempts"
        exit 1
    fi
done

echo "MariaDB host is reachable, waiting for database to accept connections..."
count=0

# Then check if we can actually connect to it
while ! mysqladmin ping -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; do
    echo "Waiting for MariaDB to accept connections..."
    sleep 5
    count=$((count+1))
    if [ $count -ge $MAX_TRIES ]; then
        echo "Error: MariaDB did not accept connections after $MAX_TRIES attempts"
        exit 1
    fi
done

echo "MariaDB is up and running!"

# Check if WordPress is already installed
if [ ! -f "/var/www/html/wp-config.php" ]; then
    # Download WordPress
    echo "Downloading WordPress..."
    wp core download --allow-root
    
    # Create wp-config.php
    echo "Creating wp-config.php..."
    wp config create \
        --dbname=${WORDPRESS_DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${WORDPRESS_DB_HOST} \
        --dbprefix=${WORDPRESS_TABLE_PREFIX} \
        --allow-root
    
    # Install WordPress
    echo "Installing WordPress..."
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="Inception WordPress" \
        --admin_user=${WORDPRESS_ADMIN_USER} \
        --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --allow-root
    
    echo "Creating regular user..."
    wp user create ${WORDPRESS_USER} ${WORDPRESS_USER_EMAIL} \
        --user_pass=${WORDPRESS_USER_PASSWORD} \
        --role=author \
        --allow-root
    
    echo "WordPress setup completed!"
else
    echo "WordPress already installed!"
fi

# Ensure correct ownership of files
chown -R nobody:nobody /var/www/html

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm8 -F
