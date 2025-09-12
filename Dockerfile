# Use a specific version for reproducibility
FROM php:8.2-fpm

# Set ARGs for user and group IDs
ARG UID=1000
ARG GID=1000

# Set working directory
WORKDIR /var/www/html

# Install system dependencies, PHP extensions, and clean up
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    mariadb-client \
    libmariadb-dev \
    libicu-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

# Create a non-root user and group for the application
RUN groupadd -g $GID -o antrian_klinik && \
    useradd -m -u $UID -g antrian_klinik -o -s /bin/bash antrian_klinik

# Copy composer dependency files and install, then clear cache
COPY composer.json ./
RUN composer install --no-dev --no-scripts --no-autoloader \
    && composer clear-cache

# Copy npm dependency files and install
COPY package.json package-lock.json vite.config.js tailwind.config.js postcss.config.js ./
RUN npm install && npm cache clean --force

# Copy the rest of the application files
COPY . .

# Generate autoloader and build assets
RUN composer dump-autoload --optimize && \
    npm run build

# Copy entrypoint script and make it executable
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Change ownership of the application files to the non-root user
RUN chown -R antrian_klinik:antrian_klinik /var/www/html

# Switch to the non-root user
USER antrian_klinik

# Expose port and define the entrypoint
EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]