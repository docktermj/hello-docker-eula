FROM alpine

ARG REFRESHED_AT=2018-09-20

# Install prerequisites.

RUN apk update \
 && apk upgrade \
 && apk add \
      bash

# Copy the repository from the local host.

COPY . /hello-docker-eula

# At runtime, run the following:

CMD /bin/bash
