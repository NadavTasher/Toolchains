# Ubuntu base version
ARG UBUNTU_BASE_VERSION=24.04

# Use scratch as fetching image
FROM ubuntu:${UBUNTU_BASE_VERSION} AS build

# Install build dependencies
RUN apt update && \
	apt install -y gcc g++ gperf bison flex texinfo help2man make libncurses-dev python3-dev autoconf automake libtool libtool-bin gawk wget bzip2 xz-utils unzip patch libstdc++6 rsync && \
	rm -r /var/lib/apt/lists

# Enter build directory
WORKDIR /tmp/ct-ng

# Default crosstool-ng version
ARG CROSSTOOL_NG_VERSION=1.27.0

# Download crosstool-ng
RUN wget -O - https://github.com/crosstool-ng/crosstool-ng/releases/download/crosstool-ng-${CROSSTOOL_NG_VERSION}/crosstool-ng-${CROSSTOOL_NG_VERSION}.tar.bz2 | tar --strip-components=1 -xj

# Install ct-ng globally
RUN ./configure && make install

# Copy the build configurations
COPY configurations /tmp/configurations

# Change to build user
USER 1000:1000

# Loop over configuration files and compile toolchains
RUN mkdir -p /tmp/tarballs; \
	for configuration in /tmp/configurations/*.conf; do \
		mkdir -p /tmp/build_$configuration; \
		cp $configuration /tmp/build_$configuration/.config; \
		ct-ng build -C /tmp/build_$configuration; \
		rm -rf /tmp/build_$configuration; \
	done;

# Use ubuntu as the base image
FROM ubuntu:${UBUNTU_BASE_VERSION}

# Install build essentials
RUN apt update && \
	apt install -y build-essential autoconf cmake libtool git qemu-user-static && \
	rm -r /var/lib/apt/lists

# Target directory for toolchains
ARG TOOLCHAINS_DIRECTORY=/toolchains

# Change to the toolchains directory
WORKDIR ${TOOLCHAINS_DIRECTORY}

# Mount toolchains and extract them, then create a checksums file for all toolchains
RUN --mount=type=bind,from=build,source=/tmp/tarballs,target=/tmp/tarballs \
	for file in /tmp/tarballs/*; do \
		tar xf $file; \
	done; \
	sha256sum /tmp/tarballs/* > checksums

# Add environment variable of toolchains location
ENV TOOLCHAINS_DIRECTORY=${TOOLCHAINS_DIRECTORY}

# Copy the resources to the container
COPY --chmod=775 resources /bin

# Change the container entrypoint
ENTRYPOINT [ "entrypoint.sh" ]

# Change to the build working directory
WORKDIR /build