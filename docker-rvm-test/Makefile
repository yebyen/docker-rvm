.PHONY: test tag-latest push-tag push-latest push buildkit all old-all okteto-build buildkit-nocache fresh
.PHONY: bundle-install bundle-update

ISO_DATE_TAG := $(shell date +%Y%m%d)

all: buildkit

fresh: buildkit-nocache

old-all: test push

test:
	docker build --no-cache --target test-base -t kingdonb/docker-rvm:$(ISO_DATE_TAG)-test-base .
	docker build --target test -t kingdonb/docker-rvm:$(ISO_DATE_TAG)-test .

okteto-build:
	okteto build -t okteto.dev/docker-rvm:$(ISO_DATE_TAG)-test .

buildkit:
	docker buildx build -t kingdonb/docker-rvm:$(ISO_DATE_TAG)-test .

buildkit-nocache:
	docker buildx build --no-cache -t kingdonb/docker-rvm:$(ISO_DATE_TAG)-test .

bundle-install:
	docker run -it --name bundle-install \
	  -v $(shell pwd)/Gemfile:/home/rvm/app/Gemfile \
	  -v $(shell pwd)/Gemfile.lock:/home/rvm/app/Gemfile.lock \
	  --rm kingdonb/docker-rvm:$(ISO_DATE_TAG)-test bash --login -c 'rvm 2.7.1 do bundle install'

bundle-update:
	docker run -it --name bundle-install \
	  -v $(shell pwd)/Gemfile:/home/rvm/app/Gemfile \
          -v $(shell pwd)/Gemfile.lock:/home/rvm/app/Gemfile.lock \
	  --rm kingdonb/docker-rvm:$(ISO_DATE_TAG)-test bash --login -c 'rvm 2.7.1 do bundle update'

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
