#!/bin/bash

IMAGE_REPO=$(cat .env | grep BACKEND_DOCKER_HUB_IMAGE_REPO | cut -d '=' -f 2)
IMAGE_NAME=$(cat .env | grep BACKEND_DOCKER_HUB_IMAGE_NAME | cut -d '=' -f 2)
IMAGE_VERSION=$(cat .env | grep BACKEND_DOCKER_HUB_IMAGE_VERSION | cut -d '=' -f 2)

echo "Pushing Docker image $IMAGE_REPO/$IMAGE_NAME:v$IMAGE_VERSION..."

docker push $IMAGE_REPO/$IMAGE_NAME:v$IMAGE_VERSION
docker push $IMAGE_REPO/$IMAGE_NAME:latest