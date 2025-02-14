#!/bin/zsh
# build_and_run.sh
# This script builds a Podman image from your Dockerfile and runs a container.
# Adjust the image name, container name, and port mappings as needed.

IMAGE_NAME="my-backend"
CONTAINER_NAME="my-backend-container"
PUBLIC_PORT="8888"  # Host port that will forward to the container's port
PRIVATE_PORT="3000"

# Ensure the Podman machine is running
echo "Starting Podman machine (if not already running)..."
podman machine start

# Build the image from the Dockerfile in the current directory.
echo "Building image ${IMAGE_NAME}..."
podman build -t ${IMAGE_NAME} .

# Run a container from the image.
echo "Running container ${CONTAINER_NAME}..."

# Get the current external IP address from the en0 interface.
DB_IP=$(ipconfig getifaddr en0)
DB_PORT=26257

echo "Using database address: ${DB_IP}"

# The host port (PUBLIC_PORT) is mapped to the container's (PRIVATE_PORT).
podman run -d --name ${CONTAINER_NAME} \
-e DB_IP=${DB_IP} \
-e DB_PORT=${DB_PORT} \
-p ${PUBLIC_PORT}:${PRIVATE_PORT} \
${IMAGE_NAME}

echo "Deployment complete. Your app should be accessible on localhost:${PUBLIC_PORT}."
