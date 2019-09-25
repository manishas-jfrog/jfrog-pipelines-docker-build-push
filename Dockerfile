FROM alpine:3.7

ADD . /tmp

RUN apk add --no-cache bash
RUN /tmp/install.sh
