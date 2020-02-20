.PHONY: build tag-latest push-tag push-latest push
.PHONY: build-unsupported tag-latest-unsupported push-tag-unsupported push-latest-unsupported

ISO_DATE_TAG := $(shell date +%Y%m%d)

all: build push

build:
	docker build -t kingdonb/docker-rvm-support:$(ISO_DATE_TAG) .

build-unsupported:
	docker build -f Dockerfile.unsupported -t kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-unsupported .

tag-latest: build
	docker tag kingdonb/docker-rvm-support:$(ISO_DATE_TAG) kingdonb/docker-rvm-support:latest

tag-latest-unsupported: build-unsupported
	docker tag kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-unsupported kingdonb/docker-rvm-support:latest-unsupported

push-tag: build
	docker push kingdonb/docker-rvm-support:$(ISO_DATE_TAG)

push-tag-unsupported: build-unsupported
	docker push kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-unsupported

push-latest: tag-latest
	docker push kingdonb/docker-rvm-support:latest

push-latest-unsupported: tag-latest-unsupported
	docker push kingdonb/docker-rvm-support:latest-unsupported

push: push-tag push-latest push-tag-unsupported push-latest-unsupported
