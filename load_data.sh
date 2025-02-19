#!/bin/bash
# load_data.sh
# Loads default data into CockroachDB.

DEFAULT_DATA_FILE="default_data.sql"
DB_NAME=${DB_NAME:-mydb}

# Ensure the file exists
if [ ! -f "$DEFAULT_DATA_FILE" ]; then
  echo "Error: ${DEFAULT_DATA_FILE} not found. Ensure it is included in the repository or copied into the CI environment."
  exit 1
fi

echo "Waiting for CockroachDB to be ready..."
TIMEOUT=120
elapsed=0

while ! podman exec cockroachdb cockroach sql --insecure -e "SELECT 1" &>/dev/null; do
    sleep 1
    elapsed=$((elapsed + 1))
    if [ $elapsed -ge $TIMEOUT ]; then
        echo "Error: CockroachDB did not become ready within ${TIMEOUT} seconds."
        exit 1
    fi
done

echo "CockroachDB is up. Loading data..."
podman exec -i cockroachdb cockroach sql --insecure < "${DEFAULT_DATA_FILE}"

if [ $? -eq 0 ]; then
    echo "Data loaded successfully!"
else
    echo "Error: Data load failed."
    exit 1
fi

# Test query to verify data
echo "Verifying data..."
TEST_QUERY=$(podman exec cockroachdb cockroach sql --insecure -e "USE $DB_NAME; SELECT count(*) FROM users;")
echo "Test query result: ${TEST_QUERY}"
