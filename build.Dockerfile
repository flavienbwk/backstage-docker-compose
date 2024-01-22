FROM docker:24.0.7-dind

WORKDIR /app

# Install expect
RUN apk update && \
    apk add --no-cache expect bash curl git nodejs=20.11.0-r0 npm python3 build-base

# Install musl
RUN apk add --no-cache musl-dev libc-dev

COPY ./build.exp /build.exp
RUN chmod +x /build.exp

COPY ./build.entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
