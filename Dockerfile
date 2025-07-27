FROM python:3.11-slim

# Avoids buffering issues
ENV PYTHONUNBUFFERED=1

# Create a non-root user
ARG UID=10001
RUN adduser --disabled-password --gecos "" --uid "${UID}" appuser

# Install build tools
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/appuser

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app
COPY . .

# Set ownership and switch user
RUN chown -R appuser:appuser /home/appuser
USER appuser

# Optionally preload files or models here
# RUN python src/agent.py download-files

# Health port
EXPOSE 8081

# Start agent
CMD ["python", "src/agent.py", "start"]
