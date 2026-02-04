# Edirom Online Frontend - Docker Configuration

This Docker configuration enables flexible deployment of the Edirom Online Frontend with configurable path handling at runtime.

## Overview

The solution consists of three main components:

1. **nginx.conf** - Nginx configuration with placeholders for dynamic paths
2. **entrypoint.sh** - Entrypoint script that injects path configuration at runtime
3. **Dockerfile** - Docker image definition based on nginx:alpine

## Usage

### Building the Image

```bash
# Build from repository root
docker build -t edirom-online-frontend_ewk-wa:latest -f docker/Dockerfile .
```

### Running the Container

```bash
# Run with root path (default)
docker run --rm -p 8080:80 edirom-online-frontend:latest

# Run with custom subpath
docker run --rm -p 8080:80 -e APP_PATH=/edirom edirom-online-frontend:latest

# Run with nested path
docker run --rm -p 8080:80 -e APP_PATH=/korngold/edirom edirom-online-frontend:latest
```

Access in browser:
- Root path: http://localhost:8080/
- Subpath: http://localhost:8080/edirom
- Nested path: http://localhost:8080/korngold/edirom
