# Information from git

GIT_REPOSITORY_NAME := $(shell basename `git rev-parse --show-toplevel`)
GIT_VERSION := $(shell git describe --always --tags --long --dirty | sed -e 's/\-0//' -e 's/\-g.......//')

# Docker

DOCKER_IMAGE := $(GIT_REPOSITORY_NAME):$(GIT_VERSION)
DOCKER_CONTAINER := $(GIT_REPOSITORY_NAME)-$(GIT_VERSION)-container

# -----------------------------------------------------------------------------
# The first "make" target runs as default.
# -----------------------------------------------------------------------------

.PHONY: default
default: help

# -----------------------------------------------------------------------------
# Docker-based builds
# -----------------------------------------------------------------------------

.PHONY: build
build:
	docker rmi --force $(DOCKER_IMAGE)
	docker build \
		--tag $(DOCKER_IMAGE) \
		.

.PHONY: run
run:
	-docker rm $(DOCKER_CONTAINER)
	docker run -it \
	  --name $(DOCKER_CONTAINER) \
	  $(DOCKER_IMAGE)

.PHONY: test1
test1:
	-docker rm $(DOCKER_CONTAINER)
	docker run \
	  --name $(DOCKER_CONTAINER) \
	  $(DOCKER_IMAGE)

.PHONY: test2
test2:
	-docker rm $(DOCKER_CONTAINER)
	docker run \
	  --env ACCEPT_EULA=Y \
	  --name $(DOCKER_CONTAINER) \
	  $(DOCKER_IMAGE)

# -----------------------------------------------------------------------------
# Utility targets
# -----------------------------------------------------------------------------

.PHONY: clean
clean:
	-docker rmi --force $(DOCKER_IMAGE)
	-docker rm $(DOCKER_CONTAINER)

.PHONY: help
help:
	@echo "List of make targets:"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs
