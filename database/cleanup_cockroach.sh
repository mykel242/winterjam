#!/bin/zsh
# cleanup_cockroach.sh
# This script stops the CockroachDB container, removes it along with its pod,
# and then stops the Podman machine.

# Stop the CockroachDB container if it's running
echo "Stopping the CockroachDB container..."
podman stop cockroachdb 2>/dev/null

# Remove the CockroachDB container
echo "Removing the CockroachDB container..."
podman rm cockroachdb 2>/dev/null

# Remove the pod named 'crdb-pod'
echo "Removing the pod 'crdb-pod'..."
podman pod rm crdb-pod 2>/dev/null

# Optionally, stop the Podman machine if you no longer need it running
echo "Stopping the Podman machine..."
podman machine stop

echo "Cleanup complete!"
