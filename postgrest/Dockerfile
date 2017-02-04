FROM alpine:3.4

ENV POSTGREST_VERSION=0.4.0.0 \
	DB_SCHEMA=public \
	DB_ANON_ROLE=postgres \
	DB_POOL=10 \
	DB_MAXROWS=1000

RUN apk update && \
	apk add xz curl ca-certificates gmp gmp-dev postgresql-client tar

RUN curl -L https://github.com/begriffs/postgrest/releases/download/v${POSTGREST_VERSION}/postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz | \
	tar -xJv > /usr/local/bin/postgrest && \
	chmod u+x /usr/local/bin/postgrest

EXPOSE 3000

COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
