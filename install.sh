#!/bin/bash -e

export PACKAGES="\
    coreutils \
    sudo \
    git \
    openssh-client \
    ca-certificates \
    musl \
    linux-headers \
    build-base \
    python2 \
    python2-dev \
    py-pip \
    wget \
"

echo "================ installing packages ======================="
apk update
apk add --no-cache $PACKAGES


echo "================ installing glibc from sgerrand======================="
wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-2.27-r0.apk
wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-bin-2.27-r0.apk
wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-i18n-2.27-r0.apk

apk add glibc-2.27-r0.apk glibc-bin-2.27-r0.apk glibc-i18n-2.27-r0.apk
/usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8

JFROG_VERSION=1.33.2
echo "================= Adding jfrog-cli $JFROG_VERSION  ================"
wget -nv https://api.bintray.com/content/jfrog/jfrog-cli-go/"$JFROG_VERSION"/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 -O jfrog
sudo chmod +x jfrog
mv jfrog /usr/bin/jfrog

echo "================ make some useful symlinks that are expected to exist ======================="
if [[ ! -e /usr/bin/python ]];        then ln -sf /usr/bin/python2.7 /usr/bin/python; fi
if [[ ! -e /usr/bin/python-config ]]; then ln -sf /usr/bin/python2.7-config /usr/bin/python-config; fi
if [[ ! -e /usr/bin/easy_install ]];  then ln -sf /usr/bin/easy_install-2.7 /usr/bin/easy_install; fi

echo "================ install and upgrade pip ======================="
easy_install pip
pip install --upgrade pip
if [[ ! -e /usr/bin/pip ]]; then ln -sf /usr/bin/pip2.7 /usr/bin/pip; fi

echo "================ test ssh ======================="
eval `ssh-agent -s`
