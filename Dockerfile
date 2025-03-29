FROM python:3.9-slim

WORKDIR /app

# Install required dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    chromium \
    && rm -rf /var/lib/apt/lists/*

# Fetch the latest stable ChromeDriver version
RUN LATEST_VERSION=$(curl -s https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE) && \
    echo "Latest ChromeDriver version: $LATEST_VERSION" && \
    wget -q "https://storage.googleapis.com/chrome-for-testing-public/${LATEST_VERSION}/linux64/chromedriver-linux64.zip" -O chromedriver.zip && \
    echo "Downloaded ChromeDriver, checking file size..." && \
    ls -lh chromedriver.zip && \
    echo "Extracting ChromeDriver..." && \
    unzip chromedriver.zip -d /usr/local/bin/ && \
    rm chromedriver.zip


# Set environment variable for ChromeDriver
ENV PATH="/usr/local/bin/chromedriver:${PATH}"

# Copy application code
COPY code /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirement.txt

CMD ["python", "main.py"]
