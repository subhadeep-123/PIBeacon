FROM ubuntu:21.04
RUN apt-get update
RUN mkdir -p app/
WORKDIR /app
COPY app/ ./
