USERNAME:=erasche
PROJECT:=barcode-server
PWD:=$(shell pwd)
TAG:=cptjenkins/barcode-server:latest

default: builddocker

main:
	docker run \
		-e CGO_ENABLED=0 \
		-e GOOS=linux \
		--rm \
		-e GIT_REPO=https://github.com/${USERNAME}/${PROJECT} \
		-e GIT_VERSION=eb23a47dcc812888c6deb30986f1b1689f0d7243 \
		-v /opt/jenkins/data/jobs/docker-barcode/workspace/barcodes/:/out \
		-w /usr/src/myapp \
		golang:1.5 \
		/out/build.sh

builddocker: main
	chmod 755 ./main
	docker build --rm=true --tag=${TAG} -f Dockerfile .

run: builddocker
	docker run \
		-p 10000:80 ${TAG}
