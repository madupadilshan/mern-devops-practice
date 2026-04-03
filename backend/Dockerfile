# Base image for the backend service.
FROM node:20-alpine3.22

# Set the working directory.
WORKDIR /app

# Apply latest OS security patches.
RUN apk upgrade --no-cache

# Copy dependency manifests first for better layer caching.
COPY package*.json ./

# Install dependencies.
RUN npm install

# Copy application source.
COPY . .

# Expose API port.
EXPOSE 5000

# Start the backend server.
CMD ["npm", "start"]
