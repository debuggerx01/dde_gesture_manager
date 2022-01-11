#!/usr/bin/env bash

docker build -t dgm_api_image .
docker image prune -f --filter label=stage=dart_builder
docker rm -f dgm_api
docker run -d --restart=always --name dgm_api -p 3000:3000 dgm_api_image
docker image prune -f
