FROM golang:1.12 as builder

WORKDIR /app

COPY . . 

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOARCH=amd64 \
    GOPATH=/app/go \
    GOOS=linux

RUN go test -v .  \
    && go build -o release/app

FROM alpine:3.10 as production

RUN apk add --no-cache tzdata ca-certificates shadow \
    && groupadd -r pleo \
    && useradd --no-log-init -r -m -g pleo pleo \
    && chown -R pleo. /home/pleo

WORKDIR /home/pleo

USER pleo

COPY --from=builder /app/release/app .

EXPOSE 9000

ENTRYPOINT ["./app"]

