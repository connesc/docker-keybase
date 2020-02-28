FROM arm64v8/golang:1.12-alpine3.9 AS build
COPY qemu-aarch64-static /usr/bin/
RUN apk add --no-cache curl gcc musl-dev xz
WORKDIR /go/src/github.com/keybase
ARG KEYBASE_VERSION=5.2.1
RUN curl -L "https://github.com/keybase/client/releases/download/v${KEYBASE_VERSION}/keybase-v${KEYBASE_VERSION}.tar.xz" | tar xJ && mv "client-v${KEYBASE_VERSION}" client
WORKDIR ./client/go
RUN go build -tags production -o /keybase ./keybase
RUN go build -tags production -o /kbfsfuse ./kbfs/kbfsfuse

FROM arm64v8/alpine:3.9
COPY qemu-aarch64-static /usr/bin/
RUN apk add --no-cache fuse
COPY --from=build /keybase /kbfsfuse /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]
CMD ["kbfsfuse"]
