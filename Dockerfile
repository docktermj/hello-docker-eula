FROM alpine

ARG REFRESHED_AT=2018-09-20

# Install prerequisites.

RUN apk update \
 && apk upgrade \
 && apk add \
      bash

# Copy the repository's "app" directory from the local host.

COPY ./app /app

# At runtime, run the following:

CMD /app/accept-eula.sh || /app/mock-program.sh
