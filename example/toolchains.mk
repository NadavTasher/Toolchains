IMAGE_TAG ?= latest
IMAGE_NAME ?= nadavtasher/toolchains

# Hostname of builder
BUILDER_HOSTNAME := builder

# Command to execute in builder
BUILDER_COMMAND ?= bash

# If the repository has uncommited changes, tag the image as dirty
ifneq ($(shell hostname),$(BUILDER_HOSTNAME))

.PHONY: all
all:
	@echo "Must build in container."
	@echo "Please run 'make container'."
	@false

.PHONY: container
container:
	@docker run --rm -it -v $$PWD:/build:ro -v $$PWD/bin:/build/bin:rw -w /build -h builder --tmpfs /tmp $(IMAGE_NAME):$(IMAGE_TAG) $(BUILDER_COMMAND)
endif