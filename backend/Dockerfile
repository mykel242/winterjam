# Use official Node.js image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy application source
COPY . .

# Set environment variables
ENV DB_HOST=cockroachdb
ENV DB_PORT=26257
ENV DB_USER=root
ENV DB_NAME=mydb

# Start the server
CMD ["node", "server.js"]
