# Stage 1: Build the project
# Use a compatible Node.js version (e.g., 10 or 12)
FROM node:10 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy all the project files
COPY . .

# Run the build command
RUN ./node_modules/.bin/gulp

# Stage 2: Serve the application with NGINX
# This stage remains the same as it's not affected by the Node.js version.
FROM nginx:alpine

# Copy the built files from the 'builder' stage into NGINX's web root directory.
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# The default NGINX command will start the server
CMD ["nginx", "-g", "daemon off;"]