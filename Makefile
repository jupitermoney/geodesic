export DOCKER_ORG ?= gcr.io/niki-ai
export DOCKER_IMAGE ?= $(DOCKER_ORG)/geodesic
export DOCKER_TAG ?= latest
export DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE):$(DOCKER_TAG)
export DOCKER_BUILD_FLAGS = --cache-from $(DOCKER_IMAGE_NAME)
export INSTALL_PATH ?= /usr/local/bin

-include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

all: init deps lint bash/fmt build

lint:
	@LINT=true \
	 find rootfs/usr/local/include -type f '!' -name '*.sample' -exec \
			 /bin/sh -c 'echo "==> {}">/dev/stderr; make --include-dir=rootfs/usr/local/include/ --just-print --dry-run --recon --no-print-directory --quiet --silent -f {}' \; > /dev/null
	@make bash:lint

deps:
	@make packages/reinstall/shfmt
	@exit 0

build:
	@docker pull $(DOCKER_IMAGE_NAME)
	@make --no-print-directory docker:build

bash/fmt:
	shfmt -l -w $(PWD)

bash/fmt/check:
	shfmt -d $(PWD)/rootfs

base:
	docker build --cache-from nikiai/geodesic-base:debian  $$BUILD_ARGS -t nikiai/geodesic-base:debian -f $(DOCKER_FILE).base $(DOCKER_BUILD_PATH)
	docker push nikiai/geodesic-base:debian

push:
	@docker push $(DOCKER_IMAGE_NAME)