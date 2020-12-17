FROM ubuntu:latest
RUN apt-get update
WORKDIR /app
COPY app/ ./
