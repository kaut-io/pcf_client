FROM debian:bullseye
LABEL MAINTAINER="Lon Kaut <lonkaut@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
RUN  \
  apt-get update \
  && apt-get install -yq --no-install-recommends curl gnupg2 jq git netcat-openbsd ca-certificates vim-nox python3-pip\
  && apt-get install -yq golang gcc openssh-client zsh autojump fzf \
  && python3 -m pip install --upgrade pip \
  && pip3 install yq \
  && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
  && git clone https://github.com/frodenas/bosh-zsh-autocomplete-plugin.git ~/.oh-my-zsh/plugins/bosh \
  && sed -i 's/^plugins=.*/plugins=\(git\ zsh-autosuggestions\ zsh-syntax-highlighting\ bosh\ autojump\ fzf\ python\)/' $HOME/.zshrc \
  $$ sed -i 's/^ZSH_THEME.*/[[ -z "${ZSH_THEME}" ]] \&\& ZSH_THEME="jonathan"/' $HOME/.zshrc \
  && git clone https://github.com/pivotal/hammer.git && cd hammer && go install \
  && mv /root/go/bin/hammer /usr/local/bin/ \
  && curl -s https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add - \
  && curl -s https://raw.githubusercontent.com/starkandwayne/homebrew-cf/master/public.key | apt-key add - \
  && curl -Lo /usr/local/bin/bosh "https://github.com/cloudfoundry/bosh-cli/releases/download/v6.4.7/bosh-cli-6.4.7-linux-amd64" \
  && chmod a+x /usr/local/bin/bosh \
  && echo "deb https://packages.cloudfoundry.org/debian stable main" >> /etc/apt/sources.list.d/cloudfoundry-cli.list \
  && curl -JLo /usr/local/bin/om  "https://github.com/pivotal-cf/om/releases/download/7.9.0/om-linux-amd64-7.9.0" \
  && chmod a+rx /usr/local/bin/om \
  && apt-get update \
  && apt-get install -yq cf-cli \
  && rm -rf /hammer /root/go \
  && apt-get -yq autoremove gcc golang \
  && apt-get autoclean \
  && mkdir /persist

  RUN git config --global --add safe.directory /persist


RUN echo  \
"echo '---=== This should get you started ===---' \n \
echo '  hammer -t <creds>.json cf-login' \n \
echo '  cf create-org myorg' \n \
echo '  cf csp -o myorg staging' \n \
echo '  cf target -o myorg -s staging' \n \
echo '  cd <my app>' \n \
echo '  cf-push' \n \
\n "\
| tee -a /root/.zshrc /root/.bashrc

ADD makedroplet.sh /bin/
WORKDIR /persist
CMD ["/bin/makedroplet.sh"]
