# Build stage
FROM oven/bun:1.3-alpine AS base

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

# Copy source code
COPY . .

# Build application
RUN bun run build

# Production stage
FROM oven/bun:1.3-alpine AS runner

WORKDIR /app

# Set environment to production
ENV NODE_ENV=production
ENV PORT=3000

# Copy built files from base
COPY --from=base /app/.next ./.next
COPY --from=base /app/public ./public
COPY --from=base /app/package.json ./package.json

# Install dependencies
COPY --from=base /app/node_modules ./node_modules

# Install Prisma CLI globally
RUN bun install -g prisma

# Generate Prisma Client
RUN bun prisma generate

# Expose port
EXPOSE 3000

# Start server
CMD ["bun", "run", "start"]
