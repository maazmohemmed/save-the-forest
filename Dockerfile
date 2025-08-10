# Stage 1: Build the project
FROM node:18 AS builder

WORKDIR /app

COPY package*.json ./

# Corrected lines: Install gulp-cli globally and then install project dependencies
RUN npm install -g gulp-cli
RUN npm install

COPY . .

# Now the 'gulp' command is available
RUN gulp

# Stage 2: Serve the application with NGINX
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]