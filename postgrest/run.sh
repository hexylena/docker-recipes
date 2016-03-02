#!/bin/bash
echo "Sleeping on Postgres at $POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT"
until nc -z $POSTGRES_PORT_5432_TCP_ADDR $POSTGRES_PORT_5432_TCP_PORT; do
    echo "$(date) - waiting for postgres..."
    sleep 2
done

/opt/postgrest \
    postgres://postgres:$POSTGRES_ENV_POSTGRES_PASSWORD@$POSTGRES_PORT_5432_TCP_ADDR:5432/$POSTGRES_DB_NAME \
    --schema $SCHEMA \
    --jwt-secret $JWT_SECRET \
    --port 8000 \
    -a postgres \
    --pool $POOL_SIZE
