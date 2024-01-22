# backstage-docker-compose

Dockerized backstage configuration for production use.

## Setup

1. Copy and edit the `.env` file

    ```bash
    cp .env.example .env
    ```

2. (optional) Clone plugins

    For instance, if you want to use the [`kubernetes` plugin](http://localhost:7007) in your Backstage instance, run the following command:

    ```bash
    git clone --depth 1 --filter=blob:none --sparse https://github.com/backstage/backstage.git
    cd backstage && git sparse-checkout set plugins/kubernetes && cd -
    mv ./backstage/plugins/kubernetes ./custom/plugins/
    ```

3. Build Backstage

    ```bash
    docker-compose -f build.docker-compose.yml down
    docker-compose -f build.docker-compose.yml up --build
    ```

4. Run Backstage

    ```bash
    docker-compose down
    docker-compose up --build
    ```

5. Access backstage at _http://localhost:3000_
