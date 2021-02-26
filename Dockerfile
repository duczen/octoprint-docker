FROM python:alpine3.13

ENV OCTOPRINT_VERSION 1.5.3
ENV DIALOUT_GROUP 20

# Build and install octoprint
WORKDIR /usr/src
RUN apk add --no-cache ca-certificates raspberrypi ffmpeg sudo \
        zlib-dev jpeg-dev gcc libc-dev linux-headers \
    && wget https://github.com/foosel/OctoPrint/archive/$OCTOPRINT_VERSION.tar.gz \
    && tar -xzf $OCTOPRINT_VERSION.tar.gz \
    && rm $OCTOPRINT_VERSION.tar.gz \
    && mv OctoPrint-$OCTOPRINT_VERSION /opt/octoprint \
    && cd /opt/octoprint \
    && pip install -r requirements.txt

# Setup users/permissions for running non root
RUN apk add --no-cache --virtual .build-deps shadow \
    && addgroup octoprint \
    && adduser -S -G octoprint octoprint \
    && adduser octoprint dialout \
    && groupmod -g $DIALOUT_GROUP dialout \
    && apk del .build-deps

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
