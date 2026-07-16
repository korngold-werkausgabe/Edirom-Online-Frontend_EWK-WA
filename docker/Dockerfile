#######################################
# Multi-stage Dockerfile
# 1. Set up the build environment
# 2. Build Edirom-Online packages
# 3. Run the nginx and deploy frontend
#######################################


#########################
# 1. Build Environment
#########################

FROM eclipse-temurin:8-jdk-focal AS builder

ARG ANT_VERSION=1.10.12
ARG BE_PORT=8080
ARG SENCHA_BUILD_ENV=production


# Install wget and unzip and ruby and other dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        sudo \
        wget \
        git \
        unzip \
		libfreetype6 \
		fontconfig \
        ruby-full \
	&& rm -rf /var/lib/apt/lists/*

# Download and extract Apache Ant to opt folder
RUN wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
    wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz.sha512 && \
    echo "$(cat apache-ant-${ANT_VERSION}-bin.tar.gz.sha512) apache-ant-${ANT_VERSION}-bin.tar.gz" | sha512sum -c && \
    tar -zvxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ && \
    ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant && \
    unlink apache-ant-${ANT_VERSION}-bin.tar.gz && \
    unlink apache-ant-${ANT_VERSION}-bin.tar.gz.sha512

# Download and install SenchaCmd Community Edition
RUN curl --silent http://cdn.sencha.com/cmd/7.0.0.40/no-jre/SenchaCmd-7.0.0.40-linux-amd64.sh.zip -o /tmp/senchaCmd.zip && \
    unzip /tmp/senchaCmd.zip -d /tmp  && \
    unlink /tmp/senchaCmd.zip  && \
    chmod o+x /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh && \
    /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh -Dall=true -q -dir /opt/Sencha/Cmd/7.0.0.40 && \
    unlink /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh

# Put ant and sencha in the path
ENV PATH="/opt/ant/bin:/opt/Sencha/Cmd:${PATH}"


############################
# 2. Edirom-Online Frontend
############################

# Get build for Edirom-Online Frontend
WORKDIR /opt/eo-frontend

COPY . .
RUN git submodule update --init --recursive

RUN echo "Writing backend.port=$BE_PORT to local.properties…"; \
    if [ -f "./local.properties" ]; then \
        sed -i '/^backend\.port=/d' local.properties; \
        echo "backend.port=$BE_PORT" >> local.properties; \
    else \
        echo "backend.port=$BE_PORT" >> local.properties; \
    fi && \
    echo "Building Frontend XAR..." && \
    sencha app build ${SENCHA_BUILD_ENV}

FROM nginx:alpine

# Set default APP_PATH (can be overridden at runtime)
ENV APP_PATH=/
ENV BACKEND_PATH=/exist
ENV BACKEND_URL=http://127.0.0.1:8080/exist

# Copy nginx configuration
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Copy entrypoint script
COPY docker/entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

COPY --from=builder /opt/eo-frontend/build/ /usr/share/nginx/html/

# Create config directory if needed
RUN mkdir -p /usr/share/nginx/html/config

EXPOSE 80

# Use custom entrypoint, then start nginx
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]