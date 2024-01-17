# Stage 1 - Create yarn install skeleton layer
FROM node:18-bookworm-slim AS packages

WORKDIR /app

RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/backstage/backstage
WORKDIR /app/backstage

RUN git pull
RUN git checkout ${BACKSTAGE_VERSION}

# Removing problematic plugins (they do not build)
RUN rm -rf plugins/xcmetrics
RUN rm yarn.lock

RUN find packages \! -name "package.json" -mindepth 2 -maxdepth 2 -exec rm -rf {} \+

# Stage 2 - Install dependencies and build packages
FROM node:18-bookworm-slim AS build

# Install isolate-vm dependencies, these are needed by the @backstage/plugin-scaffolder-backend.
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 g++ build-essential && \
    yarn config set python /usr/bin/python3

# Install sqlite3 dependencies. You can skip this if you don't use sqlite3 in the image,
# in which case you should also move better-sqlite3 to "devDependencies" in package.json.
RUN apt-get update && \
    apt-get install -y --no-install-recommends libsqlite3-dev

USER node
WORKDIR /app

COPY --from=packages --chown=node:node /app/backstage .

RUN yarn cache clear && yarn install

COPY --chown=node:node . .

RUN yarn tsc
RUN yarn --cwd packages/backend build
# If you have not yet migrated to package roles, use the following command instead:
# RUN yarn --cwd packages/backend backstage-cli backend:bundle --build-dependencies

RUN mkdir packages/backend/dist/skeleton packages/backend/dist/bundle \
    && tar xzf packages/backend/dist/skeleton.tar.gz -C packages/backend/dist/skeleton \
    && tar xzf packages/backend/dist/bundle.tar.gz -C packages/backend/dist/bundle

# Stage 3 - Build the actual backend image and install production dependencies
FROM node:18-bookworm-slim

# Install isolate-vm dependencies, these are needed by the @backstage/plugin-scaffolder-backend.
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 g++ build-essential && \
    yarn config set python /usr/bin/python3

# Install sqlite3 dependencies. You can skip this if you don't use sqlite3 in the image,
# in which case you should also move better-sqlite3 to "devDependencies" in package.json.
RUN apt-get update && \
    apt-get install -y --no-install-recommends libsqlite3-dev

# From here on we use the least-privileged `node` user to run the backend.
USER node

# This should create the app dir as `node`.
# If it is instead created as `root` then the `tar` command below will
# fail: `can't create directory 'packages/': Permission denied`.
# If this occurs, then ensure BuildKit is enabled (`DOCKER_BUILDKIT=1`)
# so the app dir is correctly created as `node`.
WORKDIR /app

# Copy the install dependencies from the build stage and context
COPY --from=build --chown=node:node /app/yarn.lock /app/package.json /app/packages/backend/dist/skeleton/ ./

RUN yarn install --frozen-lockfile --production --network-timeout 600000

# Copy the built packages from the build stage
COPY --from=build --chown=node:node /app/packages/backend/dist/bundle/ ./

# This switches many Node.js dependencies to production mode.
ENV NODE_ENV production

CMD ["node", "packages/backend", "--config", "app-config.yaml"]
