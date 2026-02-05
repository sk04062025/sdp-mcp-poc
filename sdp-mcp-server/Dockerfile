# Use Node.js 20 Alpine as base
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY tsconfig*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:20-alpine AS production

WORKDIR /app

# Install production dependencies only
COPY package*.json ./
RUN npm ci --only=production

# Copy built artifacts from builder
COPY --from=builder /app/dist ./dist
# Copy scripts folder which contains setup scripts
COPY --from=builder /app/scripts ./scripts
# Copy database migrations
COPY --from=builder /app/src/database/migrations ./src/database/migrations

# Create logs directory
RUN mkdir -p logs && chown node:node logs

# Switch to non-root user
USER node

# Expose port
EXPOSE 3000

# Start server
CMD ["node", "dist/index.js"]
