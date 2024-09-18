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






