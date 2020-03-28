#import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= env.mk
include $(cnf)
IMG = "$(REGISTRY)/$(DOCKER_USER)/$(IMAGE):$(TAG)"

# get the version of the latest stable release for build
VERSION:= $(shell ./version.sh)
.DEFAULT_GOAL := build

build: 
	@echo '[buildctl]: building image: $(IMG) for architecture: $(PLATFORM)'
	@buildctl build --frontend dockerfile.v0 \
		--frontend-opt platform=linux/$(PLATFORM) \
		--frontend-opt filename=./$(DOCKERFILE_LOCATION) \
		--exporter image \
		--exporter-opt name=$(REGISTRY)/$(DOCKER_USER)/$(IMAGE):$(TAG)-$(PLATFORM) \
		--exporter-opt push=false \
		--local dockerfile=. \
		--local context=.

buildx:
	@echo '[buildx]: building image: $(REGISTRY)/$(DOCKER_USER)/$(IMAGE):$(TAG) for all architectures'
	@docker build --platform linux/amd64,linux/arm64 \
		--build-arg $(PYTHON_IMAGE_TAG) -t $(DOCKER_USER)/$(IMAGE):$(TAG) .

validate:
	@echo latest stable tag: ${VERSION}
