.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

include .env
export

.PHONY: all
all: build

.PHONY: build
build:
	-@echo "-> $@"
	@echo "${GITHUB_TOKEN}" | docker login ghcr.io -u kimbeejay --password-stdin
	@docker buildx create --use
	@docker buildx build --platform linux/amd64,linux/arm64 --push --tag ghcr.io/kimbeejay/go-buildx:${VERSION} .
