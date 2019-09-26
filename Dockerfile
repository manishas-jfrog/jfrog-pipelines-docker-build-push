FROM alpine:3.7

ADD . /tmp

RUN apk add --no-cache bash
chmod +rwx /tmp/install.sh
RUN /tmp/install.sh
