FROM ubuntu:21.04
RUN apt-get update
WORKDIR /app
COPY app/ ./
