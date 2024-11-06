```bash
#!/bin/bash

# Define variables
FAILED_CONNECTORS_FILE="/path/to/failed_tasks_log.txt"
ORIGINAL_FILE_PATH="/home/tenant/connector/Kafka_connectors/kafkaStatus_13-08-24.xlsx"
TARGET_FILE_PATH="/home/tenant/workspace/EPDM-Core/epdmappman/Int_Kafka_connector"
SCRIPT_PATH="/path/to/connector_script.py"  # Path to the Python script

# Create necessary directories if they don't exist
mkdir -p "$(dirname "$FAILED_CONNECTORS_FILE")"
mkdir -p "$(dirname "$ORIGINAL_FILE_PATH")"
mkdir -p "$TARGET_FILE_PATH"

# Run the Python script
echo "Running Kafka connector status Python script..."
python3 "$SCRIPT_PATH"

# Check if the script ran successfully
if [ $? -ne 0 ]; then
    echo "Python script failed to execute."
    exit 1
fi

# Copy the Excel file to the target location
echo "Copying Excel file to the target directory..."
cp "$ORIGINAL_FILE_PATH" "$TARGET_FILE_PATH"

if [ $? -eq 0 ]; then
    echo "File copied successfully."
else
    echo "File copy failed."
    exit 1
fi
```






