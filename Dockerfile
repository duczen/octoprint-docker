FROM alpine:3.11

ENV OCTOPRINT_VERSION 1.3.12

# Build and install octoprint
WORKDIR /usr/src
RUN addgroup -g 99 octoprint \
    && adduser -u 99 -S octoprint \
    && apk add --no-cache ca-certificates python py-setuptools py-pip raspberrypi ffmpeg sudo \
    && apk add --no-cache --virtual .build-deps gcc python-dev libc-dev linux-headers \
    && wget https://github.com/foosel/OctoPrint/archive/$OCTOPRINT_VERSION.tar.gz \
    && tar -xzf $OCTOPRINT_VERSION.tar.gz \
    && rm $OCTOPRINT_VERSION.tar.gz \
    && mv OctoPrint-$OCTOPRINT_VERSION /opt/octoprint \
    && cd /opt/octoprint \
    && pip install -r requirements.txt \
    && apk del .build-deps

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

