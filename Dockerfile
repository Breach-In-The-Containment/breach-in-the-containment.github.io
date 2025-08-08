# Stage 1: Base build
FROM node:18 AS builder

# Install rsync
RUN apt-get update && apt-get install -y rsync git && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy repo
COPY . .

# Clone dev branch into a folder
RUN git clone --branch dev --single-branch $(git remote get-url origin) /app/dev-branch

# Create output folder
RUN mkdir -p /app/out /app/out/dev

# Copy main branch site into root (excluding out & dev-branch folders)
RUN rsync -av --exclude out --exclude dev-branch . /app/out/

# Copy dev branch site into /dev
RUN rsync -av --exclude out /app/dev-branch/ /app/out/dev/

# Stage 2: Web server
FROM nginx:stable-alpine

# Copy built site to nginx html folder
COPY --from=builder /app/out /usr/share/nginx/html

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
