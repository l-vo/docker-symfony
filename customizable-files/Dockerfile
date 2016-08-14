FROM tutum/apache-php

RUN apt-get update && \
  apt-get -y install acl php-apc php5-curl php5-gd php5-intl php5-xdebug

# Rewrite mode required for Symfony
RUN a2enmod rewrite

# Copy xdebug default config instead of symlinks for allowing specific configuration for each with volumes
RUN rm /etc/php5/apache2/conf.d/20-xdebug.ini
RUN cp /etc/php5/mods-available/xdebug.ini /etc/php5/apache2/conf.d/20-xdebug.ini
RUN rm /etc/php5/cli/conf.d/20-xdebug.ini
RUN cp /etc/php5/mods-available/xdebug.ini /etc/php5/cli/conf.d/20-xdebug.ini

# Copy xdebug default config instead of symlinks for allowing specific configuration for each with volumes
RUN cp /etc/php5/mods-available/xdebug.ini /etc/php5/apache2/conf.d/20-xdebug.ini
RUN cp /etc/php5/mods-available/xdebug.ini /etc/php5/cli/conf.d/20-xdebug.ini

# Composer self-update
COPY composer.phar /usr/local/bin/composer
RUN composer self-update

# Install symfony
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod u+x /usr/local/bin/symfony

# Add symfony installer wrapper
COPY install-sf.sh /install-sf.sh
RUN chmod u+x /install-sf.sh 
