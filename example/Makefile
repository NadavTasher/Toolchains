# Include the toolchains makefile
include toolchains.mk

OUTPUT := bin/$(ARCH)

.PHONY: all
all: $(OUTPUT)/main

$(OUTPUT)/main: src/main.c
	mkdir -p $(OUTPUT)
	$(ARCH)-buildroot-linux-musl-gcc -o $@ $^ -static