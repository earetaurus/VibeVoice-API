# Builder stage: build wheels from the pyproject-based package
FROM python:3.11-slim AS builder
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential gcc curl libpq-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package metadata first (speeds up rebuilds)
COPY pyproject.toml poetry.lock* /app/

# Upgrade pip and install packaging tools
RUN python -m pip install --upgrade pip wheel build setuptools

# Copy project and build wheel(s)
COPY . /app
RUN python -m pip wheel --no-deps --wheel-dir /wheels .

# Final stage: small runtime image
FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000

# Install runtime dependencies (e.g., libpq for psycopg2)
RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq5 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install built wheels
COPY --from=builder /wheels /wheels
RUN python -m pip install --no-cache-dir /wheels/*

# Copy app source (if your package includes scripts/exposed modules)
COPY . /app

# Use a non-root user
RUN adduser --disabled-password --gecos "" appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# DEFAULT CMD: replace "vibevoice_api.main:app" with your app entrypoint if different
CMD ["uvicorn", "vibevoice_api.main:app", "--host", "0.0.0.0", "--port", "8000"]