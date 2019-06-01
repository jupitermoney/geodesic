export DOCKER_ORG ?= asia.gcr.io/niki-ai
export DOCKER_IMAGE ?= $(DOCKER_ORG)/geodesic
export DOCKER_TAG ?= latest
export DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE):$(DOCKER_TAG)
export DOCKER_BUILD_FLAGS = 
export INSTALL_PATH ?= /usr/local/bin

-include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

all: init deps lint bash/fmt build

lint:
	@LINT=true \
	 find rootfs/usr/local/include -type f '!' -name '*.sample' -exec \
			 /bin/sh -c 'echo "==> {}">/dev/stderr; make --include-dir=rootfs/usr/local/include/ --just-print --dry-run --recon --no-print-directory --quiet --silent -f {}' \; > /dev/null
	@make bash:lint

deps:
	@exit 0

build:
	@make --no-print-directory docker:build

bash/fmt:
	shfmt -l -w $(PWD)

bash/fmt/check:
	shfmt -d $(PWD)/rootfs

base:
	docker build $(DOCKER_BUILD_FLAGS) $$BUILD_ARGS -t ${DOCKER_IMAGE}-base:debian -f $(DOCKER_FILE).base $(DOCKER_BUILD_PATH)
	#docker push $(DOCKER_IMAGE)-base:debian

push:
	@make --no-print-directory docker:push