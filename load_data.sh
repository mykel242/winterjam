#!/bin/zsh
# load_data.sh
# Loads default data into CockroachDB.

DEFAULT_DATA_FILE="default_data.sql"

# Ensure the file exists
if [ ! -f "$DEFAULT_DATA_FILE" ]; then
  echo "Error: ${DEFAULT_DATA_FILE} not found."
  exit 1
fi

echo "Waiting for CockroachDB to be ready..."
TIMEOUT=60
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
TEST_QUERY=$(podman exec cockroachdb cockroach sql --insecure -e "USE mydb; SELECT count(*) FROM users;")
echo "Test query result: ${TEST_QUERY}"
