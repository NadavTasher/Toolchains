# Use ubuntu as the base image
FROM ubuntu:22.04

# Install build essentials
RUN apt update && \
	apt install -y build-essential autoconf cmake libtool git qemu-user-static && \
	rm -r /var/lib/apt/lists

# Target directory for toolchains
ARG TOOLCHAINS_DIRECTORY=/toolchains

# Change to the toolchains directory
WORKDIR ${TOOLCHAINS_DIRECTORY}

# Mount toolchains and extract them
RUN --mount=type=bind,source=toolchains,target=/tmp/toolchains \
	for file in /tmp/toolchains/*; do \
		tar xf $file; \
	done

# Add environment variable of toolchains location
ENV TOOLCHAINS_DIRECTORY=${TOOLCHAINS_DIRECTORY}

# Copy the resources to the container
COPY --chmod=775 resources /bin

# Change the container entrypoint
ENTRYPOINT [ "entrypoint.sh" ]

# Change to the build working directory
WORKDIR /build