#!/bin/bash
# list_users.sh - Retrieves all users from CockroachDB running in a Podman pod

POD_NAME="app-pod"
DB_CONTAINER="cockroachdb"
DB_NAME="mydb"  # Change this if your database has a different name

echo "🔍 Checking if CockroachDB is running in pod '$POD_NAME'..."
if ! podman ps --filter "name=$DB_CONTAINER" --format "{{.Names}}" | grep -q "$DB_CONTAINER"; then
    echo "❌ Error: CockroachDB container is not running inside the pod."
    exit 1
fi

echo "✅ CockroachDB is running. Retrieving users from database '$DB_NAME'..."

# Run the SQL query inside the CockroachDB container
podman exec "$DB_CONTAINER" cockroach sql --insecure -d "$DB_NAME" -e "SELECT * FROM users;"

if [[ $? -eq 0 ]]; then
    echo "🎉 Successfully retrieved users from CockroachDB!"
else
    echo "❌ Error: Failed to fetch users. Check if the 'users' table exists."
    exit 1
fi
