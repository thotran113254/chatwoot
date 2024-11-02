FROM chatwoot:development

# Cài đặt các package cần thiết sử dụng apk
RUN apk add --no-cache \
    curl \
    shadow

# Tạo user node
RUN groupadd -r node && useradd -r -g node node

# Cài đặt pnpm globally
RUN curl -f https://get.pnpm.io/v6.js | node - add --global pnpm

# Cấp quyền thực thi cho entrypoint script
RUN chmod +x docker/entrypoints/vite.sh

# Tạo và set quyền cho các thư mục
RUN mkdir -p /app/node_modules && \
    mkdir -p /app/tmp/cache && \
    mkdir -p /app/tmp/pids && \
    chown -R node:node /app/node_modules && \
    chown -R node:node /app/tmp

EXPOSE 5173

USER node

CMD ["pnpm", "run", "dev"]
