FROM begriffs/postgrest

ENV DB_URI="postgres://postgres:postgres@postgres:5432/postgres" \
	DB_SCHEMA=public \
	DB_ANON_ROLE=postgres \
	DB_POOL=10 \
	DB_MAXROWS=1000 \
	JWT_SECRET="deadbeefcafe"

EXPOSE 3000

COPY entrypoint.sh /
CMD ["/entrypoint.sh"]
