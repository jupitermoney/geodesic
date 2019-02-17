FROM debian:9-slim

COPY packages.txt /tmp/packages.txt

# Install common packages
RUN (echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections) \
    && APK_PACKAGES=$(cat /tmp/packages.txt | paste -sd ' ' -) \
    && apt-get update \
    && apt-get -y install --no-upgrade --no-install-recommends ${APK_PACKAGES} \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /etc/bash_completion.d/ /etc/profile.d/ \
    && mkdir -p /conf \
    && mkdir -p /var/lib/syslog-ng \
    && touch /conf/.gitconfig \
    &&  echo 'set noswapfile' >> /etc/vim/vimrc
