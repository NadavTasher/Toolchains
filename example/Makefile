# Include the toolchains makefile
include toolchains.mk

# Target compilation architecture
ARCH ?= x86_64
LIBC ?= musl

# Toolchain prefix
PREFIX ?= $(ARCH)-buildroot-linux-$(LIBC)-

# Output directory
OUTPUT := bin/$(ARCH)-$(LIBC)

.PHONY: all
all: $(OUTPUT)/main

.PHONY: clean
clean:
	@# Remove output directory
	rm -rf $(OUTPUT)

$(OUTPUT)/main: src/main.c
	@# Create output directory
	mkdir -p $(OUTPUT)

	@# Compile using the prefix
	$(PREFIX)gcc -o $@ $^ -static
