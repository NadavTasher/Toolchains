# Command to execute in builder
COMMAND ?= bash

# Toolchains container image
IMAGE_TAG ?= latest
IMAGE_NAME ?= nadavtasher/toolchains

# Hostname of builder
BUILDER_HOSTNAME := builder

# If the hostname does not match the builder hostname, abort
ifneq ($(shell hostname),$(BUILDER_HOSTNAME))

.PHONY: all
all:
	@echo "Must build in container."
	@echo "Please run 'make container'."
	@false

.PHONY: binfmt
binfmt:
	@docker run --rm --privileged $(IMAGE_NAME):$(IMAGE_TAG) qemu-binfmt-conf.sh

.PHONY: container
container:
	@docker run --rm -it -v $$PWD:/build:ro -v $$PWD/bin:/build/bin:rw -w /build -h builder --tmpfs /tmp $(IMAGE_NAME):$(IMAGE_TAG) $(COMMAND)
endif