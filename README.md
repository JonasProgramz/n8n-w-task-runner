# n8n with External Task Runners

This repository contains a Docker Compose setup for n8n with external task runners for JavaScript and Python code execution.

## What's Included

- **n8n**: Main n8n instance configured to use external task runners
- **Custom Task Runners**: Extended runner image with additional packages
  - Python: pillow, piexif, exifread, numpy, pandas, fpdf2
  - JavaScript: moment, uuid

## Files

- `docker-compose.yml`: Docker Compose configuration
- `Dockerfile`: Custom runner image with additional packages
- `n8n-task-runners.json`: Task runner configuration with allowed packages

## Deployment

### Using Docker Compose

```bash
docker compose up -d
```

n8n will be available at `http://localhost:5678`

### Using Coolify

1. Create a new resource in Coolify
2. Select "Docker Compose"
3. Connect this Git repository
4. Deploy

Coolify will automatically build the custom runner image and start both services.

## Configuration

### Task Runner Authentication

The runners authenticate using the token defined in both services:
- `N8N_RUNNERS_AUTH_TOKEN=runner-secret`

**Important**: Change this token in production!

### Allowed Packages

Packages are whitelisted in `n8n-task-runners.json`. To add more packages:

1. Add them to the Dockerfile install commands
2. Add them to the allowlist in n8n-task-runners.json
3. Rebuild the runner image

## Architecture

```
n8n (port 5678) <--> Task Runner Broker (port 5679) <--> Runners Container
```

The runners connect to n8n's broker to receive and execute code tasks in isolated environments.
