#!/bin/sh

set -ex

cat <<CONFFILE
db-uri = "$DB_URI"
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
> /tmp/postgrest.conf;

postgrest /tmp/postgrest.conf
