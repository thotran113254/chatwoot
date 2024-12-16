#!/bin/sh
set -x

# Sử dụng sudo để xóa cache với quyền root
if [ -d "/app/tmp/pids/server.pid" ]; then
    sudo rm -rf /app/tmp/pids/server.pid
fi

if [ -d "/app/tmp/cache" ]; then
    sudo rm -rf /app/tmp/cache/*
fi

# Đảm bảo quyền truy cập
sudo chown -R node:node /app/tmp
sudo chown -R node:node /app/node_modules

pnpm store prune
pnpm install --force

echo "Ready to run Vite development server."

exec "$@"
