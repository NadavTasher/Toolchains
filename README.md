# Toolchains

![Builds](https://github.com/NadavTasher/Toolchains/actions/workflows/build.yml/badge.svg)

A docker image containing ready-to-use toolchains from [bootlin.com](https://toolchains.bootlin.com/).

The image also contains an [`entrypoint.sh`](https://github.com/NadavTasher/Toolchains/blob/master/image/resources/entrypoint.sh) file to add the toolchains to the `PATH`.

## Usage

You can use the image simply by pulling it from the container registry:

```bash
docker pull nadavtasher/toolchains:latest
```

Then use `docker run` to run a shell / compiler inside of the container:

```bash
docker run --rm -it -v $PWD:/build:ro -v $PWD/bin:/build/bin:rw -w /build -h builder --tmpfs /tmp nadavtasher/toolchains:latest bash
```

You can also use the [`example`](https://github.com/NadavTasher/Toolchains/tree/master/example) directory to create a project that uses this image to compile your sources.
