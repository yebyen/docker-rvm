.PHONY: build tag-latest push-tag push-latest push
.PHONY: build-release push-release release push-unsupported-release build-oci8
.PHONY: build-unsupported tag-latest-unsupported push-tag-unsupported push-latest-unsupported
.PHONY: build-release-oci8 build-unsupported-oci8 push-all-oci8
.PHONY: build-release-all push-all release-all

ISO_DATE_TAG := $(shell date +%Y%m%d)

all: build build-release build-release-oci8 push-latest release-all

release-all: build-release-all push-all

build-release-all: build build-release build-release-oci8 build-unsupported build-unsupported-oci8 tag-latest tag-latest-unsupported

push-all: push-tag push-all-oci8 push-tag-unsupported push-latest push-latest-unsupported

release: build-release push-tag push-latest

build-oci8: build-release-oci8 build-unsupported-oci8

push-release: push-tag push-latest

push-unsupported-release: push-tag-unsupported push-latest-unsupported

build:
	docker build -t kingdonb/docker-rvm-support:latest .

build-release:
	docker build -t kingdonb/docker-rvm-support:$(ISO_DATE_TAG) .

build-release-oci8:
	docker build -f Dockerfile.oci8 -t kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-oci8 .

build-unsupported:
	docker build -f Dockerfile.unsupported -t kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-unsupported .

build-unsupported-oci8:
	docker build -f Dockerfile.unsupported.oci8 -t kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-oci8-unsupported .

push-all-oci8:
	docker push kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-oci8
	docker push kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-oci8-unsupported

tag-latest: build
	docker tag kingdonb/docker-rvm-support:$(ISO_DATE_TAG) kingdonb/docker-rvm-support:latest
	docker tag kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-oci8 kingdonb/docker-rvm-support:latest-oci8

tag-latest-unsupported: build-unsupported
	docker tag kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-unsupported kingdonb/docker-rvm-support:latest-unsupported
	docker tag kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-oci8-unsupported kingdonb/docker-rvm-support:latest-oci8-unsupported

push-tag: build
	docker push kingdonb/docker-rvm-support:$(ISO_DATE_TAG)

push-tag-unsupported: build-unsupported
	docker push kingdonb/docker-rvm-support:$(ISO_DATE_TAG)-unsupported

push-latest: tag-latest
	docker push kingdonb/docker-rvm-support:latest
	docker push kingdonb/docker-rvm-support:latest-oci8

push-latest-unsupported: tag-latest-unsupported
	docker push kingdonb/docker-rvm-support:latest-unsupported
	docker push kingdonb/docker-rvm-support:latest-oci8-unsupported

# push: push-tag push-latest push-tag-unsupported push-latest-unsupported
