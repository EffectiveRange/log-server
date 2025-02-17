colon := :
$(colon) := :
IMG_TAG=latest
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: arm64 amd64 build-image log-server-arm64-image log-server-amd64-image

arm64:
	$(eval ARCH=arm64)
	$(eval DOCKER_ARCH=arm64v8)

amd64:
	$(eval ARCH=amd64)
	$(eval DOCKER_ARCH=$(ARCH))

build-image:
	docker buildx build $(ROOT_DIR) --file Dockerfile --tag effectiverange/log-server-$(ARCH)$(:)$(IMG_TAG) --build-arg ARCH=$(DOCKER_ARCH)

log-server-arm64-image: arm64 build-image

log-server-amd64-image: amd64 build-image
