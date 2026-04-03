## syntax=docker/dockerfile:1.7

ARG PYTHON_VERSION=3.12.2
FROM python:${PYTHON_VERSION}-alpine3.19 AS base

# Security & runtime settings
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Create non-root user
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Install system dependencies if needed (example: gcc for builds)
# Remove if not required
RUN apk add --no-cache \
    build-base \
    libffi-dev

# Copy dependency file first (better caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY counter-service.py .

# Fix ownership
RUN mkdir -p /app/data && chown -R appuser:appuser /app

# Drop privileges
USER appuser

# Expose application port
EXPOSE 8080

# Optional: healthcheck (recommended for production)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

# Run application
CMD ["gunicorn", "counter-service:app", \
     "--bind", "0.0.0.0:8080", \
     "--workers", "2", \
     "--threads", "4", \
     "--access-logfile", "-", \
     "--error-logfile", "-"]