# Stage 1: Base build - responsible for preparing the content
FROM node:18 AS builder

# Install rsync and git, which are needed for copying and manipulating files
# Cleaning apt cache afterwards to keep the image size down
RUN apt-get update && apt-get install -y rsync git && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the entire local project directory into the /app directory in the container
# This includes the content of the branch you are currently building from (e.g., main or dev)
COPY . .

# Create a temporary directory for the dev branch content
RUN mkdir /app/dev_content_temp

# Checkout the 'dev' branch into the temporary directory
# This assumes the current build context (COPY . .) is from the 'main' branch,
# and you want to pull 'dev' branch's content into a separate folder.
# If you are building this Dockerfile from the 'dev' branch, you would adjust this logic.
# For a scenario where Dockerfile is built from 'main' and needs to fetch 'dev':
RUN git clone --branch dev --single-branch . /app/dev_content_temp

# Create the final output folders for Nginx
RUN mkdir -p /app/out /app/out/dev

# Copy the main branch content (from the initial COPY .) to the root of the /app/out directory
# Exclude the temporary dev_content_temp folder and the 'out' folder itself
RUN rsync -av --exclude 'dev_content_temp/' --exclude 'out/' . /app/out/

# Copy the dev branch content (from dev_content_temp) to the /app/out/dev directory
RUN rsync -av /app/dev_content_temp/ /app/out/dev/

# Stage 2: Web server - using Nginx to serve the prepared content
FROM nginx:stable-alpine

# Copy the prepared site from the 'builder' stage to Nginx's default HTML directory
COPY --from=builder /app/out /usr/share/nginx/html

# Expose port 80 for web access
EXPOSE 80

# Command to start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
