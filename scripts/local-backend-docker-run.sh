#!/bin/bash

# IMAGE
IMAGE_REPO=$(cat .env | grep BACKEND_DOCKER_HUB_IMAGE_REPO | cut -d '=' -f 2)
IMAGE_NAME=$(cat .env | grep BACKEND_DOCKER_HUB_IMAGE_NAME | cut -d '=' -f 2)
IMAGE_VERSION=$(cat .env | grep BACKEND_DOCKER_HUB_IMAGE_VERSION | cut -d '=' -f 2)

# ENV
ENV=$(cat .env | grep BACKEND_DOCKER_HUB_ENV | cut -d '=' -f 2)
APP_NAME=$(cat .env | grep BACKEND_DOCKER_HUB_APP_NAME | cut -d '=' -f 2)

echo "Running Docker image $IMAGE_REPO/$IMAGE_NAME:v$IMAGE_VERSION..."

cd app/backend-app

docker run -e ENV="$ENV" -e APP_NAME="$APP_NAME" $IMAGE_REPO/$IMAGE_NAME:v$IMAGE_VERSION
