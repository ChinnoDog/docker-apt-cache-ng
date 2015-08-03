FROM debian:jessie
MAINTAINER Stephen Nichols <ChinnoDog@lonesheep.net>

# Solves apt-get problems
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  libwrap0 \
  init-system-helpers \
  libssl1.0.0

COPY *.deb /tmp/
RUN dpkg -i /tmp/*.deb
# Do I need to delete items from tmp?

VOLUME /CacheDir
Volume /LogDir

# ENTRYPOINT ["/usr/sbin/apt-cacher-ng"]
CMD [ \
  "/usr/sbin/apt-cacher-ng"\
  ,"-c"\
  ,"/etc/apt-cacher-ng" \
  ,"pidfile=/var/run/apt-cacher-ng/pid" \
  ,"SocketPath=/var/run/apt-cacher-ng/socket" \
  ,"foreground=1" \
  ,"CacheDir=/CacheDir" \
  ,"LogDir=/LogDir" \
]

# Most interesting variables:
# ForeGround: Don't detach (default: 0)
# Port: TCP port number (default: 3142)
# CacheDir: /directory/for/storage
# LogDir: /directory/for/logfiles

EXPOSE 3142

# Enable centos 7 caching
RUN echo "VfilePatternEx: \?((release=.*|arch=.*|repo=.*)&?)+|\/repodata\/.*xml" >>/etc/apt-cacher-ng/acng.conf
RUN echo "PfilePatternEX: \/RPM-GPG-KEY\/" >>/etc/apt-cacher-ng/acng.conf
