# Use Node 20
FROM node:20-slim

# Create app directory
WORKDIR /app

# Copy backend package files first for better caching
COPY backend/package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the backend source code
COPY backend/ .

# Expose the port your backend uses (5000)
EXPOSE 5000

# Start the server
CMD ["node", "index.js"]
