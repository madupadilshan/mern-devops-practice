# Use a small Node.js base image.
FROM node:18-alpine

# Set the working directory inside the container.
WORKDIR /app

# Copy package files first and install dependencies.
COPY package*.json ./
RUN npm install

# Copy the rest of the backend source code.
COPY . .

# Expose backend port.
EXPOSE 5000

# Start the backend server.
CMD ["npm", "start"]
