# WebApollo
# VERSION 2.0
FROM tomcat:7
MAINTAINER Eric Rasche <esr@tamu.edu>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update --fix-missing && \
    apt-get --no-install-recommends -y install \
    git build-essential maven2 openjdk-7-jdk libpq-dev postgresql-common \
    postgresql-client xmlstarlet netcat libpng12-dev zlib1g-dev libexpat1-dev \
    ant perl5

COPY sdkman.sh /bin/sdkman.sh
RUN bash /bin/sdkman.sh

ENV WA_VERSION d5e78c4c689d35768e9761a00de6b4c478dafa6d
RUN cd / && \
    wget --quiet https://github.com/GMOD/Apollo/archive/${WA_VERSION}.tar.gz && \
    tar xfz ${WA_VERSION}.tar.gz && \
    mv /Apollo-* /apollo

COPY build.sh /bin/build.sh
RUN cp /apollo/sample-docker-apollo-config.groovy /apollo/apollo-config.groovy && \
    bash /bin/build.sh && \
    rm -rf ${CATALINA_HOME}/webapps/* && \
    cp /apollo/target/apollo*.war ${CATALINA_HOME}/webapps/apollo.war
