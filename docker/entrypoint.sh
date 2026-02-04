#!/bin/sh
set -e

# Default to root path if not set
APP_PATH="${APP_PATH:-/}"

# Normalize: ensure it starts with / and doesn't end with / (unless it's just "/")
case "$APP_PATH" in
  ""|"/") NORMALIZED_PATH="/" ;;
  /*)     NORMALIZED_PATH="${APP_PATH%/}" ;;
  *)      NORMALIZED_PATH="/${APP_PATH%/}" ;;
esac

echo "====================================="
echo "Edirom Online Frontend Configuration"
echo "====================================="
echo "APP_PATH environment variable: '${APP_PATH}'"
echo "Normalized path: '${NORMALIZED_PATH}'"
echo "====================================="

PLACEHOLDER="/APP_PATH"

# Replace placeholder in build files
echo "Replacing placeholder '${PLACEHOLDER}' with '${NORMALIZED_PATH}' in built files..."

find /usr/share/nginx/html \
  -type f \( -name "*.html" -o -name "*.js" -o -name "*.css" \) -print0 \
| while IFS= read -r -d '' f; do
  sed -i "s|${PLACEHOLDER}/|${NORMALIZED_PATH%/}/|g" "$f" # %/ removes trailing slash for correct replacement
  sed -i "s|${PLACEHOLDER}|${NORMALIZED_PATH}|g" "$f"
done

# replace placeholder in nginx configuration
sed -i "s|${PLACEHOLDER}/|${NORMALIZED_PATH%/}/|g" /etc/nginx/nginx.conf # %/ removes trailing slash for correct replacement
sed -i "s|${PLACEHOLDER}|${NORMALIZED_PATH}|g" /etc/nginx/nginx.conf

echo "Placeholder replacement completed."
echo "====================================="
echo "Starting Nginx..."
echo "====================================="

# Execute the CMD from Dockerfile (nginx)
exec "$@"
