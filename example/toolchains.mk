# Target compilation architecture
ARCH ?= x86_64
LIBC ?= MUSL

# Toolchain prefixes
MUSL_PREFIX := $(ARCH)-buildroot-linux-musl-
UCLIBC_PREFIX := $(ARCH)-buildroot-linux-uclibc-

# Toolchain prefix
PREFIX ?= $(LIBC)_PREFIX

# Toolchains container image
IMAGE_TAG ?= latest
IMAGE_NAME ?= nadavtasher/toolchains

# Hostname of builder
BUILDER_HOSTNAME := builder

# Command to execute in builder
BUILDER_COMMAND ?= bash

# Check whether binfmt should be used
ifneq ($(shell uname -m),$(ARCH))
PREREQUISITES := binfmt
endif

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
container: $(PREREQUISITES)
	@docker run --rm -it -v $$PWD:/build:ro -v $$PWD/bin:/build/bin:rw -w /build -h builder --tmpfs /tmp $(IMAGE_NAME):$(IMAGE_TAG) $(BUILDER_COMMAND)
endif