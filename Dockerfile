FROM debian:buster
MAINTAINER Lon Kaut <lonkaut@gmail.com>

ENV LANG C.UTF-8
RUN  \
  apt-get update \
  && apt-get install -yq curl gnupg2 \
  && curl -s https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add - \
  && apt-get update \
  && apt-get install -yq cf-cli 

CMD ["/bin/true"]
