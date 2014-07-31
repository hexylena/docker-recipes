# InterProScan
# VERSION 0.1
# Tracking 5.6-48.0

FROM debian:wheezy

MAINTAINER Eric Rasche <rasche.eric@yandex.ru>

# make sure the package repository is up to date
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update

# Install required software
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install openjdk-7-jre

RUN wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/lookup_service/lookup_service_5.6-48.0.tar.gz.md5
RUN wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/lookup_service/lookup_service_5.6-48.0.tar.gz 
RUN md5sum -c lookup_service_5.6-48.0.tar.gz.md5
RUN tar -pxvzf lookup_service_5.6-48.0.tar.gz

EXPOSE 8080
CMD java -Xmx2000m -jar lookup_service_5.6-48.0/server-5.6-48.0-jetty-console.war --sslProxied --port 8080 --forwarded --contextPath /i5lookup/ --headless
