#!/bin/bash

cd app/frontend-app

pnpm run build --out-dir dist

aws s3 sync ./dist/ s3://dev-e-commerce-app-bucket/html
