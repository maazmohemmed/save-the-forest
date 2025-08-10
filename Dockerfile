# Stage 1: Build the project
# This stage uses a Node.js image to install dependencies and run build tasks.
FROM node:18 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy all the project files
COPY . .

# Run the build command (assuming your build process generates the 'dist' folder)
# 'gulp' is the common command based on your gulpfile.js
RUN gulp

# Stage 2: Serve the application with NGINX
# This stage uses a minimal NGINX image to serve the static files.
FROM nginx:alpine

# Copy the built files from the 'builder' stage into NGINX's web root directory.
COPY --from=builder /app/dist /usr/share/nginx/html


# Expose port 80 to the outside world
EXPOSE 80

# The default NGINX command will start the server
CMD ["nginx", "-g", "daemon off;"]