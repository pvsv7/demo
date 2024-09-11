#!/bin/bash

# Define API endpoints and credentials
USER="em"
PASSWORD="random"
AUTH_URL="https://a.c.net/api/v2/login/credentials"
INT_ENDPOINTS=(
    "https://a.c.net/api/proxy-connect/INT/connectors/em.api.acm.bundle_qa/status"
    "https://a.c.net/api/proxy-connect/INT/connectors/em.api.acm.bundle_ti/status"
)

# Get authentication token
TOKEN=$(curl -s -X POST $AUTH_URL -H "Content-Type: application/json" -d "{\"user\":\"$USER\", \"password\":\"$PASSWORD\"}" | jq -r '.token')

# Check if token was obtained
if [[ -z "$TOKEN" || "$TOKEN" == "null" ]]; then
    echo "Failed to authenticate"
    exit 1
fi

# Directory to store logs
LOG_DIR="/tmp/connectorlog"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/failed_tasks_log.txt"
> "$LOG_FILE"

# Check Kafka connector status
for ENDPOINT in "${INT_ENDPOINTS[@]}"; do
    RESPONSE=$(curl -s -H "X-Kafka-Lenses-Token: $TOKEN" "$ENDPOINT")
    CONNECTOR_NAME=$(echo "$RESPONSE" | jq -r '.name')
    CONNECTOR_STATE=$(echo "$RESPONSE" | jq -r '.connector.state')
    TASK_IDS=$(echo "$RESPONSE" | jq -r '.tasks[].id')
    TASK_STATES=$(echo "$RESPONSE" | jq -r '.tasks[].state')

    if [[ "$CONNECTOR_STATE" == "FAILED" || "$TASK_STATES" == *"FAILED"* ]]; then
        echo "CONNECTOR_NAME: $CONNECTOR_NAME" >> "$LOG_FILE"
        echo "CONNECTOR_STATE: $CONNECTOR_STATE" >> "$LOG_FILE"
        echo "TASK_IDS: $TASK_IDS" >> "$LOG_FILE"
        echo "TASK_STATE: $TASK_STATES" >> "$LOG_FILE"
        echo "------------------------" >> "$LOG_FILE"
    fi
done

# Check if failed connectors were found and send email alert
if [[ -s "$LOG_FILE" ]]; then
    # Send email (assuming `mail` is configured on your system)
    mail -s "Failed Kafka Connectors Detected" example@domain.com < "$LOG_FILE"
else
    echo "No failed connectors found"
fi
