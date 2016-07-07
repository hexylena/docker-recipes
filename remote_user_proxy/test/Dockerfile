FROM alpine
RUN apk update && apk add netcat-openbsd
CMD ["nc", "-l", "10000"]
