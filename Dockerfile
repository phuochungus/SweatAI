# Use Python 3.12 slim image
FROM python:3.12-slim

# Copy uv binary
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /app

# Create cache directory and set permissions
RUN mkdir -p /.cache/uv && chmod 777 /.cache/uv

# Copy application files
COPY . .

# Install dependencies
RUN uv sync

# Expose port
EXPOSE 5000

# Run the application
CMD ["uv", "run", "app.py"]