#!/bin/zsh
# setup_pod.sh
# This script sets up a Podman pod with CockroachDB, Express.js, and Vite on macOS.

# 1. Install Podman if not already installed
if ! command -v podman &>/dev/null; then
  echo "Podman not found. Installing via Homebrew..."
  brew install podman
fi

# 2. Initialize and start Podman machine
echo "Initializing Podman machine (if needed)..."
podman machine init 2>/dev/null || echo "Podman machine already initialized."
echo "Starting Podman machine..."
podman machine start

# 3. Create a Pod for the application
echo "Creating Pod with required port mappings..."
podman pod create --name app-pod -p 26257:26257 -p 8080:8080 -p 3000:3000 -p 5173:5173

# 4. Setup persistent volumes
echo "Creating volumes for persistent storage..."
podman volume create crdb_data
podman volume create backend_data
podman volume create frontend_data

# 5. Start CockroachDB
echo "Starting CockroachDB..."
podman run -d --pod app-pod --name cockroachdb \
  -v crdb_data:/cockroach/cockroach-data \
  cockroachdb/cockroach:v23.1.11 start-single-node \
  --insecure

# 6. Start Express.js Backend
echo "Starting Express.js backend..."
podman build -t express-backend -f backend/Dockerfile backend/
podman run -d --pod app-pod --name backend -v backend_data:/app express-backend

# 7. Start Vite Frontend
echo "Starting Vite frontend..."
podman build -t vite-frontend -f frontend/Dockerfile frontend/
podman run -d --pod app-pod --name frontend -v frontend_data:/app vite-frontend

# 8. Confirm all services are running
echo "Listing running containers in app-pod..."
podman ps --pod

echo "Setup complete. CockroachDB, Express backend, and Vite frontend are running in app-pod."
