# Build stage
FROM python:3.12-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY app/requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir flask flask-sqlalchemy pymysql cryptography pytest pytest-cov pytest-mock


# Test stage
FROM builder AS test

# Copy test files
COPY app/test_app.py .
COPY app/app.py .

# Run tests
RUN pytest test_app.py

# Production stage
FROM builder AS build
#---
# FROM python:3.12-slim
# Copy only necessary files from builder
#COPY --from=builder /usr/local/lib/python3.12/site-packages/ /usr/local/lib/python3.12/site-packages/
#---

WORKDIR /app

COPY app/app.py .

# Add non-root user
RUN useradd -m appuser && \
    chown -R appuser:appuser /app
USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
