FROM golang:1.23.8 AS builder

COPY . /src
WORKDIR /src

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" -o manager cmd/main.go

FROM debian:stable-slim
WORKDIR /
COPY --from=builder /src/manager .

ENTRYPOINT ["/manager"]
