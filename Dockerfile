ARG ALPINE_VERSION=3.22
ARG GO_VERSION=1.24.4
ARG DOCKER_VERSION=28-dind

FROM golang:${GO_VERSION}-alpine as builder

ARG BUILDX_VERSION=0.25.0
ARG TARGETOS
ARG TARGETARCH

ARG path=https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.${TARGETOS}-${TARGETARCH}
RUN echo == Downloading: $path

RUN apk update && apk add --no-cache curl
RUN curl -L --output /docker-buildx $path

FROM docker:${DOCKER_VERSION} as final

COPY --from=builder /docker-buildx /usr/lib/docker/cli-plugins/docker-buildx
COPY --from=builder /usr/local/go/ /usr/local/go/

LABEL org.opencontainers.image.source="https://github.com/kimbeejay/go-buildx"
LABEL org.opencontainers.image.authors="i@beejay.kim"
LABEL version=$GO_VERSION
LABEL description="Docker CE client with BuildKit and Golang support"

ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=/go/bin:/usr/local/go/bin:$PATH

RUN set -eux; \
	apk add --no-cache \
		git \
	;

RUN chmod a+x /usr/lib/docker/cli-plugins/docker-buildx
RUN chmod a+x /usr/local/go/bin/go
RUN mkdir -p /usr/local/go
