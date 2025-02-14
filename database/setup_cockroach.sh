#!/bin/zsh
# setup_cockroach.sh
# This script sets up CockroachDB with Podman on macOS.
# This script will install Podman if necessary, initialize and start the Podman machine,
# pull the CockroachDB image, create a Pod with the appropriate port mappings,
# and finally run the CockroachDB container with the --advertise-addr set to the IP address of your en0 interface.

# 1. Install Podman if not already installed
if ! command -v podman &>/dev/null; then
  echo "Podman not found. Installing via Homebrew..."
  brew install podman
fi

# 2. Initialize the Podman machine if it hasn't been initialized
echo "Initializing Podman machine (if needed)..."
podman machine init 2>/dev/null || echo "Podman machine already initialized."

# 3. Start the Podman machine
echo "Starting Podman machine..."
podman machine start

# 4. Pull the CockroachDB image
echo "Pulling CockroachDB image..."
podman pull cockroachdb/cockroach

# 5. Create a Pod with port mappings for CockroachDB
echo "Creating Pod with required port mappings..."
podman pod create --name crdb-pod -p 26257:26257 -p 8080:8080

# 6. Get the current external IP address (using the en0 interface)
IP=$(ipconfig getifaddr en0)
echo "Using advertise address: ${IP}"

# 7. Run the CockroachDB container with the updated advertise address
echo "Starting CockroachDB container..."
podman run -d --pod crdb-pod --name cockroachdb \
  cockroachdb/cockroach:v23.1.11 start-single-node \
  --insecure --advertise-addr=${IP}

echo "CockroachDB setup complete!"
