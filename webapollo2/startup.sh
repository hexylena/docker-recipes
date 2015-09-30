#!/bin/bash

. /bin/common.sh

echo "Sleeping on Postgres at $DB_PORT_5432_TCP_ADDR:$DB_PORT_5432_TCP_PORT"
until nc -z $DB_PORT_5432_TCP_ADDR $DB_PORT_5432_TCP_PORT; do
    echo "$(date) - waiting for postgres..."
    sleep 2
done

# Use default postgres user...
#psql -U postgres -h $DB_PORT_5432_TCP_ADDR -c "CREATE USER $PGUSER NOCREATEROLE CREATEDB NOINHERIT LOGIN NOSUPERUSER ENCRYPTED PASSWORD '$WEBAPOLLO_PASSWORD'"
psql -U postgres -h $DB_PORT_5432_TCP_ADDR -c "CREATE DATABASE $WEBAPOLLO_DATABASE ENCODING='UTF-8' OWNER=$PGUSER"

CONFIG_FILE=$DEPLOY_DIR/config/config.properties
sed -i "s|database.url=.*|database.url=jdbc:postgresql://$DB_PORT_5432_TCP_ADDR:$DB_PORT_5432_TCP_PORT/$WEBAPOLLO_DATABASE|g" $CONFIG_FILE
sed -i "s|database.username=.*|database.username=$PGUSER|g" $CONFIG_FILE
sed -i "s|database.password=.*|database.password=$PGPASSWORD|g" $CONFIG_FILE
sed -i "s|organism=.*|organism=$APOLLO_ORGANISM|g" $CONFIG_FILE

HIBERNATE_CONFIG_FILE=$DEPLOY_DIR/config/hibernate.xml
sed -i "s|ENTER_DATABASE_CONNECTION_URL|jdbc:postgresql://$DB_PORT_5432_TCP_ADDR:$DB_PORT_5432_TCP_PORT/$WEBAPOLLO_DATABASE|g" $HIBERNATE_CONFIG_FILE
sed -i "s|ENTER_USERNAME|$PGUSER|g" $HIBERNATE_CONFIG_FILE
sed -i "s|ENTER_PASSWORD|$PGPASSWORD|g" $HIBERNATE_CONFIG_FILE

XML_CONFIG_FILE=$DEPLOY_DIR/config/config.xml
sed -i "s|<authentication_class>.*</authentication_class>|<authentication_class>$APOLLO_AUTHENTICATION</authentication_class>|g" $XML_CONFIG_FILE
sed -i "s|<organism>.*</organism>|<organism>$APOLLO_ORGANISM</organism>|g" $XML_CONFIG_FILE
sed -i "s|<translation_table>.*</translation_table>|<translation_table>/config/translation_tables/ncbi_${APOLLO_TRANSLATION_TABLE}_translation_table.txt</translation_table>|g" $XML_CONFIG_FILE

ANNOT_TRACK_JS=$DEPLOY_DIR/jbrowse/plugins/WebApollo/js/View/Track/AnnotTrack.js
sed -i "s|var gserv = 'http://golr.geneontology.org/solr/'|var gserv = '$GOLR_URL'|g" $ANNOT_TRACK_JS

# TODO wait for endpoint to be alive

psql -U $PGUSER $WEBAPOLLO_DATABASE -h $DB_PORT_5432_TCP_ADDR < $WEBAPOLLO_ROOT/tools/user/user_database_postgresql.sql

mkdir -p /opt/apollo/annotations /opt/apollo/jbrowse/data/
# Need JBlib.pm
$WEBAPOLLO_ROOT/tools/user/add_user.pl -D $WEBAPOLLO_DATABASE -U $PGUSER -P $PGPASSWORD -u $APOLLO_USERNAME -p $APOLLO_PASSWORD -H $DB_PORT_5432_TCP_ADDR

if [ -e "/data/autodetect.sh" ];
then
    /data/autodetect.sh /data
else
    /bin/autodetect.sh /data
fi

# Run tomcat and tail logs
cd $CATALINA_HOME && ./bin/catalina.sh run
