FROM golang:1.23.8 AS builder

COPY . /src
WORKDIR /src

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager cmd/main.go

FROM debian:stable-slim
WORKDIR /
COPY --from=builder /src/manager .

ENTRYPOINT ["/manager"]
