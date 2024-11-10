# Change this to your image name
IMAGE_TAG ?= latest
IMAGE_NAME ?= nadavtasher/toolchains

# Choose the image flavor
IMAGE_FLAVOR ?= online

# Export variables for usage in recipes
export IMAGE_TAG IMAGE_NAME

# Paths to sources
SOURCE_DIRECTORY := image

# Base repository branch
SOURCE_BRANCH := master

# If we are on the upstream branch, tag the image with a version
ifeq ($(shell git rev-parse --abbrev-ref HEAD),$(SOURCE_BRANCH))
IMAGE_TAG := $(shell git show --quiet --date=format:%Y.%m.%d --format=%cd)
else
IMAGE_TAG := develop
endif

.PHONY: all
all: image

# If the repository has uncommited changes, tag the image as dirty
ifneq ($(shell git status --porcelain),)
IMAGE_TAG := $(IMAGE_TAG)-dirty
endif

.PHONY: image
image:
	@docker buildx build $(SOURCE_DIRECTORY) --file $(SOURCE_DIRECTORY)/Dockerfile.$(IMAGE_FLAVOR) --load --tag $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: release
release:
	@docker buildx build $(SOURCE_DIRECTORY) --file $(SOURCE_DIRECTORY)/Dockerfile.$(IMAGE_FLAVOR) --push --platform linux/amd64 --tag $(IMAGE_NAME):$(IMAGE_TAG) --tag $(IMAGE_NAME):latest

.PHONY: run
run: image
	@docker run --rm -it -v $$PWD/build:/build -w /build -h builder --tmpfs /tmp $(IMAGE_NAME):$(IMAGE_TAG) bash

.PHONY: test
test: image
	$(MAKE) -C example container COMMAND="make"

.PHONY: bash
bash: image
	$(MAKE) -C example container COMMAND="bash"
