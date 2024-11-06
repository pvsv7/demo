```bash
#!/bin/bash

# Configuration
FAILED_CONNECTORS_FILE="/path/to/failed_tasks_log.txt"
CSV_FILE_PATH="/path/to/kafka_connectors_status.csv"
EXCEL_FILE_PATH="/path/to/kafka_connectors_status.xlsx"
TARGET_FILE_PATH="/home/tenant/workspace/EPDM-Core/epdmappman/Int_Kafka_connector"
KAFKA_CONNECTOR_API_URL="http://localhost:8083/connectors"  # Adjust URL as needed
EMAIL_RECIPIENT="example@example.com"
EMAIL_SUBJECT="Kafka Connector Status for INT"

# Clean up previous files
rm -f "$FAILED_CONNECTORS_FILE" "$CSV_FILE_PATH" "$EXCEL_FILE_PATH"

# Step 1: Fetch Kafka connectors status
echo "Fetching Kafka connectors status..."
response=$(curl -s "$KAFKA_CONNECTOR_API_URL")

# Check if API call was successful
if [ $? -ne 0 ]; then
    echo "Failed to fetch Kafka connectors status."
    exit 1
fi

# Step 2: Parse the response to find failed connectors
echo "Parsing response..."
failed_connectors=()
while read -r connector; do
    status=$(curl -s "$KAFKA_CONNECTOR_API_URL/$connector/status" | jq -r '.connector.state')
    if [ "$status" != "RUNNING" ]; then
        failed_connectors+=("$connector")
        echo "$connector" >> "$FAILED_CONNECTORS_FILE"
    fi
done < <(echo "$response" | jq -r '.[]')

# Step 3: Create CSV and Excel files with connector statuses
echo "Creating CSV file..."
{
    echo "Connector,Status"
    for connector in $(echo "$response" | jq -r '.[]'); do
        status=$(curl -s "$KAFKA_CONNECTOR_API_URL/$connector/status" | jq -r '.connector.state')
        echo "$connector,$status"
    done
} > "$CSV_FILE_PATH"

# Convert CSV to Excel (optional)
if command -v ssconvert &> /dev/null; then
    echo "Converting CSV to Excel..."
    ssconvert "$CSV_FILE_PATH" "$EXCEL_FILE_PATH"
else
    echo "ssconvert not installed; CSV file created only."
fi

# Step 4: Copy Excel file to target directory (if it was created)
if [ -f "$EXCEL_FILE_PATH" ]; then
    echo "Copying Excel file to target directory..."
    cp "$EXCEL_FILE_PATH" "$TARGET_FILE_PATH"
else
    echo "Excel file was not created; using CSV only."
    cp "$CSV_FILE_PATH" "$TARGET_FILE_PATH"
fi

# Step 5: Send email if there are any failed connectors
if [ -f "$FAILED_CONNECTORS_FILE" ] && [ -s "$FAILED_CONNECTORS_FILE" ]; then
    echo "Sending email notification..."
    mail -s "$EMAIL_SUBJECT" "$EMAIL_RECIPIENT" <<EOF
Dear User,

The following Kafka connectors are not running:

$(cat "$FAILED_CONNECTORS_FILE")

Please review these connectors as needed.

Regards,
CI-CD Automation
EOF
else
    echo "All connectors are running. No email sent."
fi
```
