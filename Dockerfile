FROM debian:buster
MAINTAINER Lon Kaut <lonkaut@gmail.com>

ENV LANG C.UTF-8
RUN  \
  apt-get update \
  && apt-get install -yq --no-install-recommends curl gnupg2 jq git ca-certificates \
  && apt-get install -yq golang gcc openssh-client \
  && git clone https://github.com/pivotal/hammer.git && cd hammer && go install \
  && mv /root/go/bin/hammer /usr/local/bin/ \
  && curl -s https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add - \
  && curl -s https://raw.githubusercontent.com/starkandwayne/homebrew-cf/master/public.key | apt-key add - \
  && curl -Lo /usr/local/bin/bosh "https://github.com/cloudfoundry/bosh-cli/releases/download/v6.4.7/bosh-cli-6.4.7-linux-amd64" \
  && chmod a+x /usr/local/bin/bosh \
  && echo "deb https://packages.cloudfoundry.org/debian stable main" >> /etc/apt/sources.list.d/cloudfoundry-cli.list \
  && echo "deb http://apt.starkandwayne.com stable main" >> /etc/apt/sources.list.d/starkandwayne.list \
  && apt-get update \
  && apt-get install -yq cf-cli om \
  && rm -rf /hammer /root/go \
  && apt-get -yq autoremove gcc golang \
  && apt-get autoclean

CMD ["/bin/true"]
