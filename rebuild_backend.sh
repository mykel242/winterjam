# 1️⃣ Rebuild the backend image
podman build -t express-backend ./backend

# 2️⃣ Stop and remove the old backend container
podman stop backend
podman rm backend

# 3️⃣ Start a new backend container in the pod
podman run -d --name backend --pod app-pod express-backend

# 4️⃣ Verify everything is running
podman ps --pod

# 5️⃣ Check backend logs
podman logs backend | tail -20
