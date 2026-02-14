FROM n8nio/runners:latest

USER root

# Install system dependencies for matplotlib, lxml, and PDF libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    libxml2-dev \
    libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

# Set matplotlib to non-interactive backend
ENV MPLBACKEND=Agg

# Install Python packages from requirements.txt
COPY requirements.txt /tmp/requirements.txt
RUN cd /opt/runners/task-runner-python && uv pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt

# Install JS packages
RUN cd /opt/runners/task-runner-javascript && pnpm add moment uuid

# Copy runner config
COPY n8n-task-runners.json /etc/n8n-task-runners.json

USER runner
