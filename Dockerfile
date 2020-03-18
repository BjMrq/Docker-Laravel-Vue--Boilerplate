FROM bjmrq/laravel:php-7.4

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory permissions
RUN chown -R www:www /var/www
COPY --chown=www:www . /var/www

# Install composer dependencies for testing
RUN composer self-update
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist --no-suggest --optimize-autoloader
RUN composer clear:cache

# Install npm dependencies for testing
RUN yarn --ignore-engines --pure-lockfile
RUN yarn production

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm", "--allow-to-run-as-root"]
