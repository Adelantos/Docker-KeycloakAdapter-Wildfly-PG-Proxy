#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker rm wildflykeycloak-pg-adapter
docker build --no-cache --tag=adelantos/wildflykeycloak-pg-adapter .
docker run -it -p 8080:8080 --name=wildflykeycloak-pg-adapter --network=host \
    -e POSTGRES_PORT_5432_TCP_ADDR=localhost -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres adelantos/wildflykeycloak-pg-adapter