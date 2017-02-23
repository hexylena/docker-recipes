#!/bin/sh


until pg_isready; do
	echo "waiting on database container..."
	sleep 1
done

set -ex

cat > /tmp/postgrest.conf <<CONFFILE
db-uri = "postgres://${PGUSER}:${PGPASSWORD}@${PGHOST}:${PGPORT}/${PGDATABASE}"
db-schema = "$PGSCHEMA"
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
