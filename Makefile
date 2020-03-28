#import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= env.mk
include $(cnf)
IMG = "$(REGISTRY)/$(IMAGE):$(TAG)"

# get the version of the latest stable release for build
BUILDX_VERSION:= $(shell ./version.sh "docker/buildx")
OCTOPRINT_VERSION:= $(shell ./version.sh "foosel/OctoPrint")
.DEFAULT_GOAL := build

prepare: 
	@docker buildx create --use

build:
	@echo '[default]: building local octoprint image with all default options'
	@docker build -t octoprint .

buildctl: 
	@echo '[buildctl]: building image: ${IMG} for architecture: $(PLATFORM)'
	@buildctl build --frontend dockerfile.v0 \
		--opt platform=linux/$(PLATFORM) \
		--opt filename=./$(DOCKERFILE_LOCATION) \
		--output type=image,name=${IMG}-$(PLATFORM),push=false \
		--local dockerfile=. \
		--local context=.

buildx:
	@echo '[buildx]: building image: ${IMG} for all architectures'
	@docker buildx build --platform linux/amd64,linux/arm64/v8 \
		--build-arg $(PYTHON_BASE_IMAGE) -t ${IMG}:$(TAG) .

buildx-push:
	@echo '[buildx]: building and pushing images:\n ${IMG}:$(TAG) for all supported architectures\n'
	docker buildx build --push --platform linux/arm64,linux/amd64 \
	--progress plain --build-arg $(PYTHON_BASE_IMAGE) -t ${IMG} .
