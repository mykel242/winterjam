#!/bin/zsh
# stop_crdb_pod.sh
# This script stops the Podman pod "crdb-pod", which stops all containers within it.

POD_NAME="crdb-pod"

# Check if the pod exists before trying to stop it.
if podman pod exists "$POD_NAME"; then
    echo "Stopping pod '$POD_NAME'..."
    podman pod stop "$POD_NAME"
    echo "Pod '$POD_NAME' stopped."
else
    echo "Pod '$POD_NAME' does not exist."
fi
