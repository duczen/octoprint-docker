FROM alpine:3.11

ENV OCTOPRINT_VERSION 1.4.0
ENV UUCP_GROUP 987

# Build and install octoprint
WORKDIR /usr/src
RUN apk add --no-cache ca-certificates python3 py3-setuptools py3-pip raspberrypi ffmpeg sudo \
    && apk add --no-cache --virtual .build-deps gcc python3-dev libc-dev linux-headers \
    && wget https://github.com/foosel/OctoPrint/archive/$OCTOPRINT_VERSION.tar.gz \
    && tar -xzf $OCTOPRINT_VERSION.tar.gz \
    && rm $OCTOPRINT_VERSION.tar.gz \
    && mv OctoPrint-$OCTOPRINT_VERSION /opt/octoprint \
    && cd /opt/octoprint \
    && pip3 install -r requirements.txt \
    && apk del .build-deps

# Setup users/permissions for running non root
RUN apk add --no-cache --virtual .build-deps shadow \
    && addgroup octoprint \
    && adduser -S -G octoprint octoprint \
    && adduser octoprint uucp \
    && groupmod -g $UUCP_GROUP uucp \
    && apk del .build-deps

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
