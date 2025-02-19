#!/bin/zsh
# Automated test script for Backend & CockroachDB Pods

BACKEND_PORT=3000  # Change if your backend runs on a different port

echo "🚀 Testing Backend & CockroachDB Pods..."

# 1️⃣ Check if pods are running
echo "🔍 Checking running pods..."
podman ps --pod
if [[ $? -ne 0 ]]; then
  echo "❌ Error: No running pods found!"
  exit 1
fi

# 2️⃣ Check if CockroachDB is responding
echo "🔍 Checking CockroachDB..."
podman exec cockroachdb cockroach sql --insecure -e "SELECT 1;" &>/dev/null
if [[ $? -ne 0 ]]; then
  echo "❌ Error: CockroachDB is NOT responding!"
  exit 1
else
  echo "✅ CockroachDB is running!"
fi

# 3️⃣ Test Backend API
echo "🔍 Testing API endpoints..."

# Test GET /api/users
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$BACKEND_PORT/api/users)
if [[ "$RESPONSE" -eq 200 ]]; then
  echo "✅ GET /api/users is working!"
else
  echo "❌ GET /api/users failed! HTTP Code: $RESPONSE"
  exit 1
fi

# Test POST /api/users
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:$BACKEND_PORT/api/users \
  -H "Content-Type: application/json" \
  -d '{ "name": "Test User", "email": "test@example.com" }')
if [[ "$RESPONSE" -eq 201 ]]; then
  echo "✅ POST /api/users is working!"
else
  echo "❌ POST /api/users failed! HTTP Code: $RESPONSE"
  exit 1
fi

# Test DELETE /api/users/:id
USER_ID=$(curl -s http://localhost:$BACKEND_PORT/api/users | jq -r '.[-1].id')
if [[ -n "$USER_ID" && "$USER_ID" != "null" ]]; then
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE http://localhost:$BACKEND_PORT/api/users/$USER_ID)
  if [[ "$RESPONSE" -eq 200 ]]; then
    echo "✅ DELETE /api/users/$USER_ID is working!"
  else
    echo "❌ DELETE /api/users/$USER_ID failed! HTTP Code: $RESPONSE"
    exit 1
  fi
else
  echo "⚠️ No users found to delete, skipping DELETE test."
fi

echo "🎉 All tests passed!"
exit 0
