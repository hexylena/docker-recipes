#!/bin/sh


pg_isready -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -t 10

set -ex

cat > /tmp/postgrest.conf <<CONFFILE
db-uri = "postgres://${DB_USER}:${PGPSSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
db-schema = "$DB_SCHEMA"
db-anon-role = "$DB_ANON_ROLE"
db-pool = $DB_POOL

## choose a secret to enable JWT auth
## (use "@filename" to load from separate file)
jwt-secret = "$JWT_SECRET"
secret-is-base64 = false

## limit rows in response
max-rows = $DB_MAXROWS

## stored proc to exec immediately after auth
# pre-request = "stored_proc_name"
CONFFILE

postgrest /tmp/postgrest.conf
