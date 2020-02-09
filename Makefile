.PHONY: build tag push-tag push-latest push

ISO_DATE_TAG := $(shell date +%Y%m%d)

all: build push

build:
	docker build -t kingdonb/docker-rvm:$(ISO_DATE_TAG) .

tag-latest: build
	docker tag kingdonb/docker-rvm:$(ISO_DATE_TAG) kingdonb/docker-rvm:latest

push-tag: build
	docker push kingdonb/docker-rvm:$(ISO_DATE_TAG)

push-latest: tag-latest
	docker push kingdonb/docker-rvm:latest

push: push-tag push-latest
