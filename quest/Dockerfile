# Use the official lightweight Node.js image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy dependency files and install
COPY package.json ./
RUN npm install

# Copy bin scripts and src folder
COPY bin/ ./bin/
COPY src/ ./src/

# Make all bin scripts executable
RUN chmod +x bin/*

# Expose the port used by the app
EXPOSE 3000

# Start the Node.js application
CMD ["npm", "start"]
