FROM python:3.10-slim

WORKDIR /app
COPY requirements.txt .

RUN pip install -r requirements.txt
COPY . .

ARG ENV
ARG APP_NAME

ENV ENV=$ENV
ENV APP_NAME=$APP_NAME

EXPOSE 5000

CMD ["python", "main.py"]