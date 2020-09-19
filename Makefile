.PHONY: build tag-latest push-tag push-latest push support check

ISO_DATE_TAG := $(shell date +%Y%m%d)
SIGNATORY := yebyen

all: build push support

build:
	docker build --no-cache -t $(SIGNATORY)/docker-rvm:$(ISO_DATE_TAG) .

check:
	docker pull $(SIGNATORY)/docker-rvm:test
	docker build -f docker-rvm-test/Dockerfile.check -t $(SIGNATORY)/docker-rvm:check .

tag-latest: build
	docker tag $(SIGNATORY)/docker-rvm:$(ISO_DATE_TAG) $(SIGNATORY)/docker-rvm:latest

push-tag: build
	docker push $(SIGNATORY)/docker-rvm:$(ISO_DATE_TAG)

push-latest: tag-latest
	docker push $(SIGNATORY)/docker-rvm:latest

push: push-tag push-latest

support:
	$(MAKE) -C docker-rvm-support supported
