#!/bin/bash

# IMAGE
IMAGE_REPO=$(cat .env | grep BACKEND_IMAGE_REPO | cut -d '=' -f 2)
IMAGE_NAME=$(cat .env | grep BACKEND_IMAGE_NAME | cut -d '=' -f 2)
IMAGE_VERSION=$(cat .env | grep BACKEND_IMAGE_VERSION | cut -d '=' -f 2)

# ENV
ENV=$(cat .env | grep BACKEND_ENV | cut -d '=' -f 2)
APP_NAME=$(cat .env | grep BACKEND_APP_NAME | cut -d '=' -f 2)
KINESIS_STREAM=$(cat .env | grep BACKEND_KINESIS_STREAM_NAME | cut -d '=' -f 2)
AWS_REGION=$(cat .env | grep BACKEND_AWS_REGION | cut -d '=' -f 2)

echo "Installing HELM Chart ${ENV}-${APP_NAME}-chart..."

helm install $ENV-$APP_NAME-Chart ./k8s/backend-helm \
  --set image.repository="$IMAGE_REPO/$IMAGE_NAME" \
  --set image.tag="v$IMAGE_VERSION" \
  --set env.env="$ENV" \
  --set env.appName="$APP_NAME" \
  --set env.kinesisStreamName="$KINESIS_STREAM" \
  --set env.awsRegion="$AWS_REGION"
