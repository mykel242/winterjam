#!/bin/zsh
# start_crdb_pod.sh
# This script starts the Podman pod "crdb-pod".
# If the pod doesn't exist, it creates it with the required port mappings.

POD_NAME="crdb-pod"

# Initialize the Podman machine if it hasn't been initialized
echo "Initializing Podman machine (if needed)..."
podman machine init 2>/dev/null || echo "Podman machine already initialized."

# Start the Podman machine
echo "Starting Podman machine..."
podman machine start

# Check if the pod exists; if not, create it.
if ! podman pod exists "$POD_NAME"; then
    echo "Pod '$POD_NAME' does not exist. Creating it..."
    podman pod create --name "$POD_NAME" -p 26257:26257 -p 8080:8080
else
    echo "Pod '$POD_NAME' already exists."
fi

# Start the pod (this will start any containers inside it as well).
echo "Starting pod '$POD_NAME'..."
podman pod start "$POD_NAME"
echo "Pod '$POD_NAME' started."
