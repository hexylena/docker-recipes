FROM samos123/drupal

RUN apt-get -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install patch \
    && rm -rf /var/lib/apt/lists/*

RUN cd /var/www/html && drush pm-download ctools views tripal

RUN cd /var/www/html/ && \
    curl -O -k https://www.drupal.org/files/drupal.pgsql-bytea.27.patch && \
    patch -p1 < drupal.pgsql-bytea.27.patch && \
    cd /var/www/html/sites/all/modules/views && \
    patch -p1 < ../tripal/tripal_views/views-sql-compliant-three-tier-naming-1971160-22.patch

ADD themes/ sites/all/themes/
ADD scripts/ /scripts
