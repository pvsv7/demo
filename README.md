## 🌟 **Dockerfile:**

- A **text document** containing commands to assemble a **Docker image**.
- Contains **instructions** and **arguments** for building the image.

---

### 🖼️ **Image:**
- A **template** that contains a set of instructions for creating a container.

---

### 🐳 **Container:**
- A **runnable instance** of an image.
- It's **just a process**.
- It lives as long as the **process** lives.
- To keep it alive, it should run a **command** for an infinite time.

---
# 🐳 **Dockerfile Guide**

## 🚀 **Dockerfile:**
- A text document containing commands to assemble a Docker image.
- **Image:** Template that contains instructions for creating a container.
- **Container:** A runnable instance of an image (just a process).

---

## 🛠️ **Instructions**

### 🏗️ **1. FROM:**
- **Purpose:** Specifies the base image.
- **Example:** 
    ```bash
    FROM alpine:latest
    ```
- **Details:** This initializes the build process. The base image can be any Docker image from Docker Hub or other repositories.

---

### 🏷️ **2. LABEL:**
- **Purpose:** Adds metadata to the image (author, version, description, etc.)
- **Example:**
    ```bash
    FROM almalinux:8
    LABEL TRAINING="DEVOPS" \
          TRAINER="Venkat" \
          DURATION="120HRS"
    ```

---

### ⚙️ **3. RUN:**
- **Purpose:** Executes commands inside the container during the build.
- **Example:**
    ```bash
    FROM almalinux:8
    RUN yum install nginx -y
    ```

---

### 📂 **4. COPY:**
- **Purpose:** Copies files from the host machine to the container.
- **Example:**
    ```bash
    COPY index.html /usr/share/nginx/html/
    ```

---

### ➕ **5. ADD:**
- **Purpose:** Similar to `COPY`, but also supports downloading files from remote URLs or extracting tar archives.
- **Example:**
    ```bash
    ADD <https://example.com/file.tar.gz> /usr/src/app/
    ```

---

### 🔌 **6. EXPOSE:**
- **Purpose:** Documents the port the container will listen on.
- **Example:**
    ```bash
    EXPOSE 80/tcp
    ```

---

### 📂 **7. WORKDIR:**
- **Purpose:** Sets the working directory inside the container.
- **Example:**
    ```bash
    WORKDIR /tmp
    ```

---

### 👤 **8. USER:**
- **Purpose:** Defines the user to execute subsequent commands, improving security.
- **Example:**
    ```bash
    USER venkat
    ```

---

### 🏃‍♂️ **9. CMD and ENTRYPOINT:**
- **CMD:** Sets the default command for the container.
- **ENTRYPOINT:** Defines the command that always runs.
- **Best Practice:** Use `ENTRYPOINT` for the main command and `CMD` for default arguments.
    ```bash
    FROM almalinux:8
    ENTRYPOINT ["ping"]
    CMD ["google.com"]
    ```

---

### 🌍 **10. ENV:**
- **Purpose:** Sets environment variables.
- **Example:**
    ```bash
    ENV TRAINING="DEVOPS" TRAINER="Venkat" DURATION="120HRS"
    ```

---

### 🛠️ **11. ARG:**
- **Purpose:** Defines build-time variables.
- **Example:**
    ```bash
    ARG version
    FROM almalinux:${version:-8}
    ARG username
    RUN adduser $username
    ```

---

### 🔥 **12. ONBUILD:**
- **Purpose:** Adds a trigger instruction for future use when the image is used as a base for another Dockerfile.
- **Example:**
    ```bash
    ONBUILD ADD index.html /usr/share/nginx/html/
    ```

---

### 🛑 **13. STOPSIGNAL:**
- **Purpose:** Defines the signal to stop the container.
- **Example:**
    ```bash
    STOPSIGNAL SIGTERM
    ```

---

## ✨ **Bonus Tips:**
- Use lightweight images like `alpine` for smaller image sizes.
- Combine commands with `&&` to minimize the number of layers.
- Use multi-stage builds to reduce the final image size.

  ```
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






