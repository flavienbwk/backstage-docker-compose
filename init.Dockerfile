FROM docker:24.0.7-dind

WORKDIR /app

# Install expect
RUN apk update && \
    apk add --no-cache expect bash curl git nodejs=20.11.0-r0 npm python3 build-base

# Install musl
RUN apk add --no-cache musl-dev libc-dev

RUN npm install -ug npm@10.3.0

COPY ./init.exp /init.exp
RUN chmod +x /init.exp

ENTRYPOINT [ "/init.exp" ]
