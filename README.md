# backstage-docker-compose

[![Init Check](https://github.com/flavienbwk/backstage-docker-compose/actions/workflows/init.yml/badge.svg)](https://github.com/flavienbwk/backstage-docker-compose/actions/workflows/init.yml)
[![Build Check](https://github.com/flavienbwk/backstage-docker-compose/actions/workflows/build.yml/badge.svg)](https://github.com/flavienbwk/backstage-docker-compose/actions/workflows/build.yml)

Properly dockerized [Backstage](https://github.com/backstage/backstage) configuration for development and production use.

## Development mode

1. Copy and edit the `.env` file

    ```bash
    cp .env.example .env
    ```

2. Initialize Backstage (to be run only once!)

    ```bash
    docker-compose -f init.docker-compose.yml down
    docker-compose -f init.docker-compose.yml up --build
    ```

3. Run Backstage

    ```bash
    docker-compose down
    docker-compose up --build
    ```

    You can now use the following command to start Backstage

4. Access backstage at _http://172.17.0.1:7008_

## Production mode

1. Copy and edit the `.env` file

    ```bash
    cp .env.example .env
    ```

2. Initialize Backstage (to be run only once!)

    ```bash
    docker-compose -f init.docker-compose.yml down
    docker-compose -f init.docker-compose.yml up --build
    ```

3. Generate SSL certificates

    ```bash
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./nginx/ssl/nginx.key -out ./nginx/ssl/nginx.crt
    ```

4. Run Backstage

    ```bash
    docker-compose -f prod.docker-compose.yml down
    docker-compose -f prod.docker-compose.yml up --build
    ```

    You can now use the following command to start Backstage

5. Access backstage at _https://172.17.0.1:7008_

## Learn more

- [What is backstage ?](https://www.youtube.com/watch?v=85TQEpNCaU0&t=0s) (YouTube video by Spotify)
- [Hands-on tutorial](https://backstage.spotify.com/learn/standing-up-backstage/) (by Spotify)
- [Platform Engineering Series | Backstage](https://www.youtube.com/watch?v=R4qJN6S4qHw&list=PLGVPcLSzJXQos1O18dvKoW2XSczz2I2lH&index=2) (YouTube video by [The Good Guy](https://www.youtube.com/@the_good_guy))
- [Spotify’s Backstage Roadmap Aims to Speed Adoption](https://thenewstack.io/spotifys-backstage-roadmap-aims-to-speed-up-adoption/) (by The New Stack)
