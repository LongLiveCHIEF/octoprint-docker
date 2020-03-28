#import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= env.mk
include $(cnf)
IMG = "$(REGISTRY)/$(DOCKER_USER)/$(IMAGE):$(TAG)"

# get the version of the latest stable release for build
VERSION:= $(shell ./version.sh)
.DEFAULT_GOAL := build

build:
	@echo '[default]: building local octoprint image with all default options'
	@docker build -t octoprint .

buildctl: 
	@echo '[buildctl]: building image: $(IMG) for architecture: $(PLATFORM)'
	@buildctl build --frontend dockerfile.v0 \
		--opt platform=linux/$(PLATFORM) \
		--opt filename=./$(DOCKERFILE_LOCATION) \
		--output type=image,name=${IMG}-$(PLATFORM),push=false \
		--local dockerfile=. \
		--local context=.

buildx:
	@echo '[buildx]: building image: $(REGISTRY)/$(DOCKER_USER)/$(IMAGE):$(TAG) for all architectures'
	@docker buildx build --platform linux/amd64,linux/arm64 \
		--build-arg $(PYTHON_IMAGE_TAG) -t $(DOCKER_USER)/$(IMAGE):$(TAG) .

validate:
	@echo latest stable tag: ${VERSION}
