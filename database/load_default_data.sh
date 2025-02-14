#!/bin/zsh
# load_default_data.sh
# This script loads default data into CockroachDB by executing the SQL commands in default_data.sql.
# It assumes that the CockroachDB container is running as "cockroachdb" in the crdb-pod.

# Enable debugging output
# set -x

DEFAULT_DATA_FILE="default_data.sql"

# Check if the default data file exists
if [ ! -f "$DEFAULT_DATA_FILE" ]; then
  echo "Error: ${DEFAULT_DATA_FILE} not found. Please create the file with your default SQL data."
  exit 1
fi

echo "Default data file found: ${DEFAULT_DATA_FILE}"

echo "Waiting for CockroachDB to be ready..."

# Wait until CockroachDB is accepting connections. Increase the timeout if necessary.
TIMEOUT=60  # seconds
elapsed=0
while ! podman exec cockroachdb cockroach sql --insecure -e "SELECT 1" &>/dev/null; do
    sleep 1
    elapsed=$((elapsed + 1))
    if [ $elapsed -ge $TIMEOUT ]; then
        echo "Error: CockroachDB did not become ready within ${TIMEOUT} seconds."
        exit 1
    fi
done

echo "CockroachDB is up. Loading default data from ${DEFAULT_DATA_FILE}..."

# Load the default data into CockroachDB
podman exec -i cockroachdb cockroach sql --insecure < "${DEFAULT_DATA_FILE}"

if [ $? -eq 0 ]; then
    echo "Default data loaded successfully!"
else
    echo "Error: Failed to load default data."
    exit 1
fi

# Run a test query to verify that data was loaded.
# This example assumes that your default_data.sql creates a database named `mydb`
# and a table named `users`. Adjust the query as needed.
echo "Running test query to verify data..."
TEST_QUERY_RESULT=$(podman exec cockroachdb cockroach sql --insecure -e "USE mydb; SELECT count(*) AS count FROM users;" 2>&1)
echo "Test query result: ${TEST_QUERY_RESULT}"

# Parse the count from the result (assuming it prints a numeric value).
COUNT=$(echo "$TEST_QUERY_RESULT" | grep -Eo '[0-9]+' | head -1)
if [[ -z "$COUNT" || "$COUNT" -eq 0 ]]; then
    echo "Error: Test query returned a count of 0. Default data may not have been loaded correctly."
    exit 1
else
    echo "Test query successful! Found ${COUNT} record(s) in mydb.users."
fi


# Disable debugging output
# set +x
