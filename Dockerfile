FROM node:20-alpine

WORKDIR /app

# Install expect
RUN apk update && \
    apk add --no-cache expect bash curl git nodejs=20.11.0-r0 npm

RUN npm install -ug npm@10.3.0 && \
    npm install -ug yarn@1.22.21

ENTRYPOINT [ "yarn", "dev" ]
