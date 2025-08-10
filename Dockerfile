# Use the official Nginx image as a base
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy HTML files
COPY *.html .

# Copy CSS files
COPY css/ ./css/

# Copy JavaScript files
COPY js/ ./js/

# Copy PNG images only (since that's what your project uses)
COPY images/*.png ./images/

# Copy fonts
COPY fonts/ ./fonts/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]