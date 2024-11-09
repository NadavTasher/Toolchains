# Change this to your image name
IMAGE_TAG ?= latest
IMAGE_NAME ?= nadavtasher/toolchains

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

.PHONY: push
push:
	@echo "There are unstaged changes in the repository, refusing push"
	@false
else

.PHONY: push
push: image
	@docker push $(IMAGE_NAME):$(IMAGE_TAG)
endif

.PHONY: image
image:
	@docker buildx build $(SOURCE_DIRECTORY) --load --tag $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: run
run: image
	@docker run --rm -it -v $$PWD/build:/build -w /build -h builder --tmpfs /tmp $(IMAGE_NAME):$(IMAGE_TAG) bash

.PHONY: test
test: image
	$(MAKE) -C example container BUILDER_COMMAND="make"

.PHONY: bash
bash: image
	$(MAKE) -C example container BUILDER_COMMAND="bash"

.PHONY: clean
clean:
	@docker compose down --volumes --remove-orphans
