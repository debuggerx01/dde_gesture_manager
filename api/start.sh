#!/usr/bin/env bash

docker-compose build
docker-compose up -d
MIGRATION_IMAGE="$(docker image ls --filter label=stage=dart_builder -q)"
docker run --name=dgm_api_migrate --network dgm_api_default "$MIGRATION_IMAGE"
docker rm "$(docker ps -a --filter name=dgm_api_migrate -q)"
docker image prune -f --filter label=stage=dart_builder
docker image prune -f