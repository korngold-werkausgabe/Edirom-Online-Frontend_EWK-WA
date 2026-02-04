FROM nginx:alpine

# Set default APP_PATH (can be overridden at runtime)
ENV APP_PATH=/
ENV BACKEND_PATH=/exist
ENV BACKEND_URL=http://127.0.0.1:8080/${BACKEND_PATH}

# Copy nginx configuration
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Copy entrypoint script
COPY docker/entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Copy build folder
COPY build/ /usr/share/nginx/html/

# Create config directory if needed
RUN mkdir -p /usr/share/nginx/html/config

EXPOSE 80

# Use custom entrypoint, then start nginx
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
