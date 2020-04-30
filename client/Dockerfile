FROM golang:1.13

ENV GOROOT=/usr/local/go
ENV GOPATH=/go

RUN apt update && \
    apt install -y git && \
    go get github.com/cespare/reflex

FROM openjdk:8u242-jdk-buster

WORKDIR /app

COPY --from=0 /go/bin/reflex /usr/local/bin/reflex

RUN chmod +x /usr/local/bin/reflex

RUN apt update && apt install -y netcat
