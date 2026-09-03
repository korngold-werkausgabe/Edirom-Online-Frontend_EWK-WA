#!/bin/sh
set -e

# Default to root path if not set
APP_PATH="${APP_PATH:-/}"
APP_LOCATION="${APP_LOCATION:-/}"
BACKEND_PATH="${BACKEND_PATH:-/exist}"
BACKEND_URL="${BACKEND_URL:-http://localhost:8080/exist}"

# Normalize: ensure it starts with / and doesn't end with / (unless it's just "/")
case "$APP_PATH" in
  ""|"/") APP_PATH="/" ;;
  /*)     APP_PATH="${APP_PATH%/}" ;;
  *)      APP_PATH="/${APP_PATH%/}" ;;
esac
case "$APP_LOCATION" in
  ""|"/"|"." ) APP_LOCATION="/" ;;
  /*)     APP_LOCATION="${APP_LOCATION%/}" ;;
  *)      APP_LOCATION="/${APP_LOCATION%/}" ;;
esac
case "$APP_LOCATION" in
  "/")    APP_LOCATION_ALIAS="" ;;
  *)      APP_LOCATION_ALIAS="$APP_LOCATION" ;;
esac
case "$BACKEND_PATH" in
  ""|"/") BACKEND_PATH="/" ;;
  /*)     BACKEND_PATH="${BACKEND_PATH%/}" ;;
  *)      BACKEND_PATH="/${BACKEND_PATH%/}" ;;
esac
case "$BACKEND_URL" in
  */)     BACKEND_URL="${BACKEND_URL%/}" ;;
esac

echo "====================================="
echo "Edirom Online Frontend Configuration"
echo "====================================="

APP_PATH_PLACEHOLDER="/APP_PATH"
APP_LOCATION_PLACEHOLDER="/APP_LOCATION"
APP_LOCATION_ALIAS_PLACEHOLDER="APP_LOCATION_ALIAS"
BACKEND_PATH_PLACEHOLDER="/BACKEND_PATH"
BACKEND_URL_PLACEHOLDER="/BACKEND_URL"

echo "Replacing placeholder '${APP_PATH_PLACEHOLDER}' with '${APP_PATH}' in nginx configuration..."
echo "Replacing placeholder '${APP_LOCATION_PLACEHOLDER}' with '${APP_LOCATION}' in nginx configuration..."
echo "Replacing placeholder '${APP_LOCATION_ALIAS_PLACEHOLDER}' with '${APP_LOCATION_ALIAS}' in nginx configuration..."
echo "Replacing placeholder '${BACKEND_PATH_PLACEHOLDER}' with '${BACKEND_PATH}' in nginx configuration..."
echo "Replacing placeholder '${BACKEND_URL_PLACEHOLDER}' with '${BACKEND_URL%/}/' in nginx configuration..."

# replace placeholder in nginx configuration
sed -i "s|${APP_PATH_PLACEHOLDER}|${APP_PATH}|g" /etc/nginx/nginx.conf
sed -i "s|${APP_LOCATION_PLACEHOLDER}|${APP_LOCATION}|g" /etc/nginx/nginx.conf
sed -i "s|${APP_LOCATION_ALIAS_PLACEHOLDER}|${APP_LOCATION_ALIAS}|g" /etc/nginx/nginx.conf
sed -i "s|${BACKEND_PATH_PLACEHOLDER}|${BACKEND_PATH}|g" /etc/nginx/nginx.conf
sed -i "s|${BACKEND_URL_PLACEHOLDER}|${BACKEND_URL}|g" /etc/nginx/nginx.conf

# remove root redirect when APP_PATH = /
if [ "${APP_PATH:-/}" = "/" ]; then
  ROOT_APP_DIR="/usr/share/nginx/html"
  if [ "${APP_LOCATION}" != "/" ]; then
    ROOT_APP_DIR="${ROOT_APP_DIR}/${APP_LOCATION#/}"
  fi

  sed -i '/APP_PATH_REDIRECT_BLOCK_START/,/APP_PATH_REDIRECT_BLOCK_END/d' /etc/nginx/nginx.conf
    sed -i '/REDIRECT_BLOCK_START/,/REDIRECT_BLOCK_END/d' /etc/nginx/nginx.conf
  sed -i 's|location // {|location / {|g' /etc/nginx/nginx.conf
  sed -i 's|//index.html|/index.html|g' /etc/nginx/nginx.conf
  sed -i 's|alias /usr/share/nginx/html[^;]*;|root '"${ROOT_APP_DIR}"';|g' /etc/nginx/nginx.conf
fi

echo "Placeholder replacement completed."
echo "====================================="
echo "Starting Nginx..."
echo "====================================="

# Execute the CMD from Dockerfile (nginx)
exec "$@"