FROM n8nio/runners:1.121.0

USER root

# Python Pakete hinzufügen
RUN cd /opt/runners/task-runner-python && uv pip install pillow piexif exifread numpy pandas fpdf2

# JS Pakete hinzufügen
RUN cd /opt/runners/task-runner-javascript && pnpm add moment uuid

# Runner-Konfig kopieren
COPY n8n-task-runners.json /etc/n8n-task-runners.json

USER runner