FROM tutum/apache-php

RUN apt-get update && \
  apt-get -y install acl php-apc php5-curl php5-gd php5-intl php5-xdebug

RUN a2enmod rewrite

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer.phar
RUN composer self-update

# Install symfony
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod u+x /usr/local/bin/symfony

# Add symfony installer wrapper
COPY install-sf.sh /install-sf.sh
RUN chmod u+x /install-sf.sh 
