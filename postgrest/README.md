# Postgrest

Based on https://github.com/begriffs/postgrest but with updated paths for
use with new v2 docker-compose.yml files.


```yaml
version: '2'
services:
  postgres:
    build: .
    links:
      - "db:db"
    environment:
      POSTGREST_JWT_SECRET: thisisnotarealsecret
      POSTGREST_SCHEMA: public
      PG_PASSWORD: password
      PG_DB: postgres
    volumes_from:
        - "galaxy:ro"
    ports:
      - "8000"
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: password
```
