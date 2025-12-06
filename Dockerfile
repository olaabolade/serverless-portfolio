# Optimized Dockerfile for static portfolio
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy only essential static files
COPY index.html .
# Copy CSS/JS if they exist (silently ignore if not)
COPY *.css . 2>/dev/null || true
COPY *.js . 2>/dev/null || true

# Expose port 80
EXPOSE 80

# Health check (good practice)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
