#!/bin/bash

# IMAGE
IMAGE_REPO=$(cat .env | grep BACKEND_IMAGE_REPO | cut -d '=' -f 2)
IMAGE_NAME=$(cat .env | grep BACKEND_IMAGE_NAME | cut -d '=' -f 2)
IMAGE_VERSION=$(cat .env | grep BACKEND_IMAGE_VERSION | cut -d '=' -f 2)

# ENV
ENV=$(cat .env | grep BACKEND_ENV | cut -d '=' -f 2)
APP_NAME=$(cat .env | grep BACKEND_APP_NAME | cut -d '=' -f 2)
BACKEND_KINESIS_STREAM_NAME=$(cat .env | grep BACKEND_KINESIS_STREAM_NAME | cut -d '=' -f 2)
AWS_REGION=$(cat .env | grep BACKEND_AWS_REGION | cut -d '=' -f 2)

echo "Running Docker image $IMAGE_REPO/$IMAGE_NAME:v$IMAGE_VERSION..."

cd app

docker run \
  -e ENV="$ENV" \
  -e APP_NAME="$APP_NAME" \
  -e KINESIS_STREAM_NAME="$BACKEND_KINESIS_STREAM_NAME" \
  -e AWS_REGION="$AWS_REGION" \
  -e API_URL="http://localhost:5000/api" \
  -e VERSION="v$IMAGE_VERSION" \
  -p 5000:5000 \
  -d \
  $IMAGE_REPO/$IMAGE_NAME:v$IMAGE_VERSION
