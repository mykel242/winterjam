#!/bin/bash
# cleanup_pod.sh
# Stops and removes the Podman pod, containers, and associated volumes.
# Usage: ./cleanup_pod.sh [--remove-db]

POD_NAME="app-pod"
REMOVE_DB=false

# Check if the --remove-db flag is provided
if [[ "$1" == "--remove-db" ]]; then
    REMOVE_DB=true
fi

echo "Stopping all containers in ${POD_NAME}..."
podman pod stop ${POD_NAME}

echo "Removing all containers in ${POD_NAME}..."
podman pod rm ${POD_NAME} --force

echo "Removing backend and frontend volumes..."
podman volume rm backend_data frontend_data

# Conditionally remove the CockroachDB volume
if [[ "$REMOVE_DB" == true ]]; then
    echo "Removing CockroachDB volume..."
    podman volume rm crdb_data
else
    echo "Keeping CockroachDB volume (crdb_data) for persistence."
fi

echo "Cleanup complete! All services have been stopped and removed."
