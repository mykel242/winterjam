#!/bin/zsh
# cleanup.sh
# This script stops and removes the container and, optionally, stops the Podman machine.

CONTAINER_NAME="my-backend-container"

echo "Stopping container '${CONTAINER_NAME}'..."
podman stop ${CONTAINER_NAME} 2>/dev/null

echo "Removing container '${CONTAINER_NAME}'..."
podman rm ${CONTAINER_NAME} 2>/dev/null

# echo "Optionally, stopping the Podman machine..."
# podman machine stop

echo "Cleanup complete."
