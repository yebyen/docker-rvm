.PHONY: test tag-latest push-tag push-latest push buildkit

ISO_DATE_TAG := $(shell date +%Y%m%d)

all: test push

test:
	docker build --no-cache --target test-base -t kingdonb/docker-rvm:$(ISO_DATE_TAG)-test-base .
	docker build --target test -t kingdonb/docker-rvm:$(ISO_DATE_TAG)-test .

buildkit:
	DOCKER_BUILDKIT=1 docker build --target test -t kingdonb/docker-rvm:20200816-test \
		--build-arg BUILDKIT_INLINE_CACHE=1 .

tag-latest: test
	docker tag kingdonb/docker-rvm:$(ISO_DATE_TAG)-test-base kingdonb/docker-rvm:test-base
	docker tag kingdonb/docker-rvm:$(ISO_DATE_TAG)-test kingdonb/docker-rvm:test

push-tag: test
	docker push kingdonb/docker-rvm:$(ISO_DATE_TAG)-test-base
	docker push kingdonb/docker-rvm:$(ISO_DATE_TAG)-test

push-latest: tag-latest
	docker push kingdonb/docker-rvm:test-base
	docker push kingdonb/docker-rvm:test

push: push-tag push-latest
