# Use Python 3.12 slim image
FROM python:3.12-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set up a new user named "user" with user ID 1000 and sudo privileges
RUN useradd -m -u 1000 user && \
    apt-get update && \
    apt-get install -y sudo && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    rm -rf /var/lib/apt/lists/*

# Switch to the "user" user
USER user

# Set home to the user's home directory
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# Set the working directory to the user's home directory
WORKDIR $HOME/app

# Copy the rest of the application
COPY --chown=user . .

# Expose the port the app runs on
EXPOSE 5000

RUN uv sync 
# Command to run the application
CMD ["uv", "run", "app.py"] 