FROM node:alpine as builder

WORKDIR /app
COPY package.json .
COPY gulpfile.js .
COPY src/ ./src/

# Install dependencies and build
RUN npm install && npm run build

FROM nginx:alpine

# Copy built files from builder stage
COPY --from=builder /app/dist/ /usr/share/nginx/html/
COPY js13kgames-logo/ /usr/share/nginx/html/js13kgames-logo/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]