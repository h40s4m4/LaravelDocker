# Laravel Docker

Just another boring docker for Laravel

When you start docker, it checks if there is no composer.json file, if not, 
it automatically runs the Symfony installation with a basic skeleton.

Install a TEST DB too

> [!WARNING]  
> It is only for development purposes :P


## Getting Started

1. Run `docker compose build --no-cache` to build fresh images
2. Run `docker compose up --pull always -d --wait` to set up and start a fresh Symfony project
3. Open `https://localhost` in your favorite web browser
4. Run `docker compose down --remove-orphans` to stop the Docker containers.

## Remover componentes de Docker
docker system prune -a --volumes