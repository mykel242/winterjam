#!/bin/zsh
# build_and_run.sh
# This script builds a Podman image from your Dockerfile and runs a container.
# Adjust the image name, container name, and port mappings as needed.

IMAGE_NAME="my-backend"
CONTAINER_NAME="my-backend-container"
PUBLIC_PORT="8888"  # Host port that will forward to the container's port

# Ensure the Podman machine is running
echo "Starting Podman machine (if not already running)..."
podman machine start

# Build the image from the Dockerfile in the current directory.
echo "Building image ${IMAGE_NAME}..."
podman build -t ${IMAGE_NAME} .

# Run a container from the image.
echo "Running container ${CONTAINER_NAME}..."
# Here, the container is assumed to expose port 8080.
# The host port (PUBLIC_PORT) is mapped to the container's 8080.
podman run -d --name ${CONTAINER_NAME} -p ${PUBLIC_PORT}:8080 ${IMAGE_NAME}

echo "Deployment complete. Your app should be accessible on localhost:${PUBLIC_PORT}."
