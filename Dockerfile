FROM node:20-alpine

WORKDIR /app

# Install expect
RUN apk update && \
    apk add --no-cache expect bash curl git nodejs=20.11.0-r0 npm

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
