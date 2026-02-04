#!/bin/sh
set -e

# Default to root path if not set
APP_PATH="${APP_PATH:-/}"
BACKEND_PATH="${BACKEND_PATH:-/exist}"
BACKEND_URL="${BACKEND_URL:-http://localhost:8000/exist}"

# Normalize: ensure it starts with / and doesn't end with / (unless it's just "/")
case "$APP_PATH" in
  ""|"/") NORMALIZED_PATH="/" ;;
  /*)     NORMALIZED_PATH="${APP_PATH%/}" ;;
  *)      NORMALIZED_PATH="/${APP_PATH%/}" ;;
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

APP_PATH_PACEHOLDER="/APP_PATH"
BACKEND_PATH_PACEHOLDER="/BACKEND_PATH"
BACKEND_URL_PACEHOLDER="/BACKEND_URL"

# Replace placeholder in build files
echo "Replacing placeholder '${APP_PATH_PACEHOLDER}' with '${NORMALIZED_PATH}' in built files..."
echo "Replacing placeholder '${BACKEND_PATH_PACEHOLDER}' with '${BACKEND_PATH}' in built files..."
echo "Replacing placeholder '${BACKEND_URL_PACEHOLDER}' with '${BACKEND_URL}' in built files..."

find /usr/share/nginx/html \
  -type f \( -name "*.html" -o -name "*.js" -o -name "*.css" \) -print0 \
| while IFS= read -r -d '' f; do
  sed -i "s|${APP_PATH_PACEHOLDER}/|${NORMALIZED_PATH%/}/|g" "$f" # %/ removes trailing slash for correct replacement
  sed -i "s|${APP_PATH_PACEHOLDER}|${NORMALIZED_PATH}|g" "$f"
  sed -i "s|${BACKEND_PATH_PACEHOLDER}/|${BACKEND_PATH%/}/|g" "$f" # %/ removes trailing slash for correct replacement
  sed -i "s|${BACKEND_PATH_PACEHOLDER}|${BACKEND_PATH}|g" "$f"
  sed -i "s|${BACKEND_URL_PACEHOLDER}|${BACKEND_URL%/}/|g" "$f" # Add trailing slash if not present
done

# replace placeholder in nginx configuration
sed -i "s|${APP_PATH_PACEHOLDER}/|${NORMALIZED_PATH%/}/|g" /etc/nginx/nginx.conf # %/ removes trailing slash for correct replacement
sed -i "s|${APP_PATH_PACEHOLDER}|${NORMALIZED_PATH}|g" /etc/nginx/nginx.conf
sed -i "s|${BACKEND_PATH_PACEHOLDER}/|${BACKEND_PATH%/}/|g" /etc/nginx/nginx.conf # %/ removes trailing slash for correct replacement
sed -i "s|${BACKEND_PATH_PACEHOLDER}|${BACKEND_PATH}|g" /etc/nginx/nginx.conf
sed -i "s|${BACKEND_URL_PACEHOLDER}/|${BACKEND_URL%/}/|g" /etc/nginx/nginx.conf # %/ removes trailing slash for correct replacement
sed -i "s|${BACKEND_URL_PACEHOLDER}|${BACKEND_URL%/}/|g" /etc/nginx/nginx.conf # Add trailing slash if not present

echo "Placeholder replacement completed."
echo "====================================="
echo "Starting Nginx..."
echo "====================================="

# Execute the CMD from Dockerfile (nginx)
exec "$@"
