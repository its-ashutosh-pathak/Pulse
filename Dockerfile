# Use Node 20
FROM node:20-slim

# Install system dependencies (curl for yt-dlp download, python3 for yt-dlp runtime)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Download yt-dlp binary
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod a+rx /usr/local/bin/yt-dlp

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
