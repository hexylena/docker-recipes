#!/bin/sh
go get -v github.com/codegangsta/cli
go get -v github.com/boombuler/barcode
go get -v github.com/gorilla/mux
go get -v github.com/gorilla/handlers
git clone ${GIT_REPO} /usr/src/myapp
cd /usr/src/myapp && git checkout ${GIT_VERSION}
go build -v  -ldflags "-s" -a -installsuffix cgo -o /out/main
chown 1000:1000 /out/main
