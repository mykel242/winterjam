#!/bin/zsh
# cleanup_cockroach.sh
# This script stops the CockroachDB container, removes it along with its pod,
# removes the persistent volume, and then stops the Podman machine.

# 1. Stop the CockroachDB container if it's running.
echo "Stopping the CockroachDB container..."
podman stop cockroachdb 2>/dev/null

# 2. Remove the CockroachDB container.
echo "Removing the CockroachDB container..."
podman rm cockroachdb 2>/dev/null

# 3. Remove the pod named 'crdb-pod'.
echo "Removing the pod 'crdb-pod'..."
podman pod rm crdb-pod 2>/dev/null

# 4. Remove the persistent volume 'crdb_data' if it exists.
if podman volume exists crdb_data &>/dev/null; then
    echo "Removing persistent volume 'crdb_data'..."
    podman volume rm crdb_data 2>/dev/null
else
    echo "Persistent volume 'crdb_data' does not exist."
fi

# 5. Optionally, stop the Podman machine if you no longer need it running.
# echo "Stopping the Podman machine..."
# podman machine stop

echo "Cleanup complete!"
