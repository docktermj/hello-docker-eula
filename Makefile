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
run: clean-container
	docker run -it \
	  --name $(DOCKER_CONTAINER) \
	  $(DOCKER_IMAGE)

# -----------------------------------------------------------------------------
# Positive tests - Mock program should run.
# -----------------------------------------------------------------------------

.PHONY: pos-test-1
pos-test-1: clean-container
	docker run \
	  --env ACCEPT_EULA=Y \
	  --name $(DOCKER_CONTAINER) \
	  $(DOCKER_IMAGE)

# -----------------------------------------------------------------------------
# Negative tests - Mock program should not run.
# -----------------------------------------------------------------------------

.PHONY: neg-test-1
neg-test-1: clean-container
	docker run \
	  --name $(DOCKER_CONTAINER) \
	  $(DOCKER_IMAGE)

.PHONY: neg-test-2
neg-test-2: clean-container
	docker run -it \
	  --name $(DOCKER_CONTAINER) \
	  $(DOCKER_IMAGE)

# -----------------------------------------------------------------------------
# Break-in test - User should not be able to access container.
# -----------------------------------------------------------------------------

.PHONY: break-test-1
break-test-1: clean-container
	docker run -it \
	  --env ACCEPT_EULA=Y \
	  --name $(DOCKER_CONTAINER) \
	  $(DOCKER_IMAGE) \
	  /bin/bash

.PHONY: break-test-2
break-test-2: clean-container
	docker run -it \
	  --name $(DOCKER_CONTAINER) \
	  $(DOCKER_IMAGE) \
	  /bin/bash
	  
.PHONY: break-test-3
break-test-3: clean-container
	docker run -it \
	  --env ACCEPT_EULA=Y \
	  --name $(DOCKER_CONTAINER) \
	  --entrypoint /bin/bash \
	  $(DOCKER_IMAGE)

# -----------------------------------------------------------------------------
# Utility targets
# -----------------------------------------------------------------------------

.PHONY: clean-container
clean-container:
	-docker rm $(DOCKER_CONTAINER)

.PHONY: clean
clean: clean-container
	-docker rmi --force $(DOCKER_IMAGE)
	-docker rm $(DOCKER_CONTAINER)

.PHONY: help
help:
	@echo "List of make targets:"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs
