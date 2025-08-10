# Use a lightweight Nginx image
FROM nginx:alpine

# Copy the game files (HTML, CSS, JS) to the Nginx public directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]