#!/bin/bash

# ENV
ENV=$(cat .env | grep BACKEND_ENV | cut -d '=' -f 2)

echo "Creating NAMESPACE $ENV..."

kubectl create namespace $ENV