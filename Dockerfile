FROM alpine

ARG REFRESHED_AT=2018-09-20

# Install prerequisites.

RUN apk update \
 && apk upgrade \
 && apk add \
      bash

# Copy the repository's "app" directory from the local host.

COPY ./app /app

# At runtime, run the following.
# Note: The use of ENTRYPOINT and CMD stiffles over-riding the accept-eula.sh checking.

ENTRYPOINT /app/accept-eula.sh && /app/mock-program.sh
CMD ""
