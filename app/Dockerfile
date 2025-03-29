FROM node:22-alpine AS frontend-builder
WORKDIR /app

COPY frontend-app/package.json frontend-app/pnpm-lock.yaml ./

RUN npm install -g pnpm@10.0.0

RUN pnpm install

COPY frontend-app/ ./

RUN pnpm build --out-dir dist

FROM python:3.11-slim-bullseye
WORKDIR /app

COPY backend-app/requirements.txt ./
RUN pip install --no-cache-dir --upgrade -r requirements.txt

ARG ENV
ARG APP_NAME
ARG KINESIS_STREAM_NAME
ARG AWS_REGION
ARG API_URL
ARG VERSION

ENV ENV=$ENV
ENV APP_NAME=$APP_NAME
ENV KINESIS_STREAM_NAME=$KINESIS_STREAM_NAME
ENV AWS_REGION=$AWS_REGION
ENV API_URL=$API_URL
ENV VERSION=$VERSION

COPY backend-app/ ./

COPY --from=frontend-builder /app/dist ./dist

EXPOSE 5000

CMD ["python", "main.py"]
