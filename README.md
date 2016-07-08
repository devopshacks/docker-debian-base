# Docker base image for Debian based containers

[![Build Status](https://travis-ci.org/opsidian/docker-debian-base.svg?branch=master)](https://travis-ci.org/opsidian/docker-debian-base)

A minimal [Debian](https://www.debian.org/) based Docker image with [confd](https://github.com/kelseyhightower/confd). It is the base image for most of the Opsidian Docker projects.

 * based on Debian 8 (Jessie)
 * creates the *app* user and group with uid 1000 and guid 1000
 * the entrypoint will run the Docker command with the *app* user by default (encourages to run the process with a non-root user), with PID 1

## Installed packages
 * make
 * curl
 * ca-certificates
 * gosu 1.9
 * confd 0.11.0

## Entrypoint

The Docker entrypoint can be found in /usr/local/bin/docker-entrypoint.

The entrypoint does the following steps:
 * checks if the entrypoint is running as root
 * loads /etc/profile which loads scripts from /etc/profile.d
 * runs confd to generate configuration files
 * runs a custom init script if it exists
 * runs the Docker command with the *app* user

### Run the Docker command with a custom user

Simply set the USER environment variable to the username

```
docker run -it --rm -e USER=root opsidian/debian-base:latest bash -l
```

### Add a custom init script

If you create a custom init script at /usr/local/bin/docker-init then the entrypoint will run it automatically.

### Logging

Confd's and the custom init script's output is redirected into /var/log/docker-init.log. If any error happens the error will also be written to stderr and the script will exit.

## Confd

It is used to generate files using environment variables or various data sources. It runs with the "-onetime" option.

Confd configuration variables:
 * CONFD_PREFIX: confd prefix, '/' by default
 * CONFD_OPTIONS: confd command line options, '-backend env' by default

For a simple use-case look into the spec/rsc/confd directory.

You can read more about Confd here: https://github.com/kelseyhightower/confd

## Debugging

For debugging purposes you can quickly install some additional tools in the image running the following command:

```
install-dev-tools
```

This will install the following extra packages:
 * strace
 * tcpflow
 * tcpdump

## Useful commands

Check out the Makefile if you want to see how these commands work.

### Get info about the image

```
make docker-info
```

This will return with the following info:

```
repository_url: https://github.com/opsidian/docker-debian-base
commit_hash: [git hash]
travis_build_url: [travis build url]
```

### Start a login shell in a new container

```
# This will open a login shell with root
make run-bash

# You can go in with the default app user like this:
docker run -it --rm opsidian/debian-base:latest bash -l
```

## Building the image

The build process is written for Travis CI, but you can run it manually without any problems.

```
make build

# You can define which tag you want to build:
make build DOCKER_IMAGE_TAG=test
```

## Testing

[Serverspec](http://serverspec.org/) is used for testing. To run the tests you need Ruby 2 installed.

```
make test-deps
make test
```

The test suites are found in the spec/tests directory. Every suite is a separate spec file. You can run a specific test suite (for the suite file: spec/tests/app_spec.rb) like this:

```
make test TEST_SUITE=app
```

## Uploading the image

```
make upload
```
