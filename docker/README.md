# Edirom Online Frontend - Docker Configuration

This Docker configuration enables flexible deployment of the Edirom Online Frontend with configurable path handling at runtime.

## Overview

The solution consists of three main components:

1. **nginx.conf** - Nginx configuration with placeholders for dynamic paths
2. **entrypoint.sh** - Entrypoint script that injects path configuration at runtime
3. **Dockerfile** - Docker image definition based on nginx:alpine

## Path Variables

### APP_PATH
**URL path** - The path under which the app is accessible in the browser.
- Default: `/`

### APP_LOCATION
**Physical location** - The path where the app files are located in the filesystem (`/usr/share/nginx/html`).
- Default: `/`

These two variables work together to support different deployment scenarios:

| Scenario | APP_PATH | APP_LOCATION | Description |
|----------|----------|--------------|-------------|
| Root path | `/` | `/` | App at root, no subpath |
| Built subpath | `/build` | `/build` | Development with build folder |
| Behind load balancer | `/edition/c7-robin-hood` | `/` | Production: app at root, accessed via loadbalancer path |

## How It Works

At container startup, the **entrypoint.sh** script:
1. Reads the environment variables `APP_PATH`, `APP_LOCATION`, `BACKEND_PATH`, and `BACKEND_URL`
2. Normalizes paths (ensure `/` prefix, remove trailing `/` unless it's just `/`)
3. Replaces placeholders in nginx.conf using `sed`
4. Replaces placeholders in built HTML/JS/CSS files
5. Starts nginx with the configured paths

The **nginx.conf** then:
- Rewrites incoming requests from `APP_PATH` to `APP_LOCATION` internally
- Serves files from the physical location without exposing it to the browser
- Proxies backend requests with proper headers

## Usage

### Building the Image

```bash
# Build from repository root
docker build -t eof_ewk-wa:latest -f docker/Dockerfile .
```

### Running the Container

#### Scenario 1: Root path (default)
```bash
docker run --rm -p 8080:80 eof_ewk-wa:latest
```
Access: http://localhost:8080/

#### Scenario 2: Development with build subdirectory
```bash
docker run --rm -p 8080:80 \
  -e APP_PATH=/build \
  -e APP_LOCATION=/build \
  eof_ewk-wa:latest
```
Access: http://localhost:8080/build
- App files physically at `/usr/share/nginx/html/build/`

#### Scenario 3: Behind load balancer (production)
```bash
docker run --rm -p 8080:80 \
  -e APP_PATH=/edition/c7-robin-hood \
  -e APP_LOCATION=/ \
  eof_ewk-wa:latest
```
- Loadbalancer routes requests from `/edition/c7-robin-hood/...` to container
- App files physically at `/usr/share/nginx/html/` (root)
- Nginx rewrites `/edition/c7-robin-hood/app.js` → `/app.js` internally

#### With custom backend path
```bash
docker run --rm -p 8080:80 \
  -e APP_PATH=/build \
  -e APP_LOCATION=/build \
  -e BACKEND_PATH=/exist \
  -e BACKEND_URL=http://backend-host:8080/exist \
  eof_ewk-wa:latest
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `APP_PATH` | `/` | URL path for the frontend |
| `APP_LOCATION` | `/` | Physical filesystem location in `/usr/share/nginx/html` |
| `BACKEND_PATH` | `/exist` | URL path for backend requests |
| `BACKEND_URL` | `http://localhost:8080/exist` | Full backend URL for proxying |