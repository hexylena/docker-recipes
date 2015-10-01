FROM ubuntu:14.04
MAINTAINER Sven Hartmann <sid@sh87.net>

ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/root

RUN apt-mark hold initscripts udev plymouth mountall && \
    dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /bin/true /sbin/initctl

RUN sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list

RUN apt-get update && \
    apt-get upgrade -y --force-yes && \
    apt-get dist-upgrade -y --force-yes && \
    apt-get install -y --force-yes --no-install-recommends \
    supervisor openssh-server sudo net-tools lxde-core lxde-icon-theme x11vnc \
    xvfb screen openbox nodejs wget firefox htop bmon nano lxterminal \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

ADD startup.sh /
ADD supervisord.conf /

# Can we get away without this?
#EXPOSE 5800
EXPOSE 5900
WORKDIR /
ENTRYPOINT ["/startup.sh"]
