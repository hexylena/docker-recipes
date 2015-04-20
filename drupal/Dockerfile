FROM nginx:latest
MAINTAINER Eric Rasche <esr@tamu.edu>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update --fix-missing 
RUN apt-get --no-install-recommends -y install \
        php5-cli php-pear postgresql-client postgresql-common \
        php5-pgsql php5-gd  php-apc php5-curl curl

# Installing Composer, horrifically insecure.
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install drush
RUN composer global require drush/drush:7.* && \
    ln -s /root/.composer/vendor/bin/drush /usr/bin/drush

ENV DRUPAL_VERSION 7.38
# Install Drupal
RUN curl -O http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz && \
    cd /usr/share/nginx && \
    tar xvfz /drupal-${DRUPAL_VERSION}.tar.gz && \
    rm /drupal-${DRUPAL_VERSION}.tar.gz

ENV DRUPAL_SITE_NAME="My Drupal Site" \
    DRUPAL_DEFAULT_THEME=garland \
    DRUPAL_HOME=/usr/share/nginx/drupal-${DRUPAL_VERSION}

ADD ./default.settings.php ${DRUPAL_HOME}/sites/default/settings.php
