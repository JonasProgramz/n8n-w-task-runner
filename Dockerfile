FROM n8nio/runners:latest

USER root

# Set matplotlib to non-interactive backend
ENV MPLBACKEND=Agg

# Install Python packages (binary wheels only to avoid needing build tools)
COPY requirements.txt /tmp/requirements.txt
RUN cd /opt/runners/task-runner-python && uv pip install --only-binary :all: -r /tmp/requirements.txt && rm /tmp/requirements.txt

# Install JS packages
RUN cd /opt/runners/task-runner-javascript && pnpm add moment uuid

# Copy runner config
COPY n8n-task-runners.json /etc/n8n-task-runners.json

USER runner
