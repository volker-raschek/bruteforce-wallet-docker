# BRUTEFORCE_WALLET_VERSION
# Only required to install a specifiy version
BRUTEFORCE_WALLET_VERSION?=1.5.4 # renovate: datasource=github-releases depName=glv2/bruteforce-wallet

# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to start and run a container image.
CONTAINER_RUNTIME?=$(shell which podman)

# BRUTEFORCE_WALLET_IMAGE_REGISTRY_NAME
# Defines the name of the new container to be built using several variables.
BRUTEFORCE_WALLET_IMAGE_REGISTRY_NAME:=git.cryptic.systems
BRUTEFORCE_WALLET_IMAGE_REGISTRY_USER:=volker.raschek

BRUTEFORCE_WALLET_IMAGE_NAMESPACE?=${BRUTEFORCE_WALLET_IMAGE_REGISTRY_USER}
BRUTEFORCE_WALLET_IMAGE_NAME:=bruteforce-wallet
BRUTEFORCE_WALLET_IMAGE_VERSION?=latest
BRUTEFORCE_WALLET_IMAGE_FULLY_QUALIFIED=${BRUTEFORCE_WALLET_IMAGE_REGISTRY_NAME}/${BRUTEFORCE_WALLET_IMAGE_NAMESPACE}/${BRUTEFORCE_WALLET_IMAGE_NAME}:${BRUTEFORCE_WALLET_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--build-arg BRUTEFORCE_WALLET_VERSION=${BRUTEFORCE_WALLET_VERSION} \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${BRUTEFORCE_WALLET_IMAGE_FULLY_QUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${CONTAINER_RUNTIME} image rm ${BRUTEFORCE_WALLET_IMAGE_FULLY_QUALIFIED}
	- ${CONTAINER_RUNTIME} image rm ${BASE_IMAGE_FULL}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${BRUTEFORCE_WALLET_IMAGE_REGISTRY_PASSWORD} | ${CONTAINER_RUNTIME} login ${BRUTEFORCE_WALLET_IMAGE_REGISTRY_NAME} --username ${BRUTEFORCE_WALLET_IMAGE_REGISTRY_USER} --password-stdin
	${CONTAINER_RUNTIME} push ${BRUTEFORCE_WALLET_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}
