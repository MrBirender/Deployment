# 1️⃣ Build Stage: Build the React App using Vite
FROM node:18-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first (for better caching)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy all files (source code, public folder, etc.)
COPY . .

# Build the project using Vite
RUN npm run build

# 2️⃣ Serve Stage: Serve the built app using Nginx
FROM nginx:alpine

# Remove the default Nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy the built files from the build stage to Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for the container
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
