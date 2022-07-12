FROM golang:alpine AS webdav-builder

WORKDIR /src
COPY . .

RUN apk add --no-cache git && \
    go mod download && \
    CGO_ENABLED=0 go build -ldflags="-s -w" -o "webdav-server"

FROM alpine:3 AS ossfs-builder
RUN apk --update add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev && \
    git clone -b v1.80.6 https://github.com/aliyun/ossfs.git && \
    cd ossfs && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

FROM nginx:alpine

WORKDIR /
COPY --from=webdav-builder /src/webdav-server /usr/local/bin/webdav-server
COPY --from=ossfs-builder /usr/local/bin/ossfs /usr/local/bin/ossfs
COPY ./docker-entrypoint.sh docker-entrypoint.sh
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN apk --update add fuse curl libxml2 openssl libstdc++ libgcc && \
    rm -rf /var/cache/apk/*

ENV BucketName=your-bucket-name
ENV AccessKeyId=your-access-key-id
ENV AccessKeySecret=your-access-key-secret
ENV EndPoint=your-end-point
ENV MountPoint=/dav/data

ENV OWNER_USER=root
ENV OWNER_GROUP=root

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
