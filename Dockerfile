# FROM ubuntu:latest
FROM raspbian/jessie
RUN apt-get update
RUN apt-get install -y systemctl
WORKDIR /app
COPY app/ ./

