#!/bin/sh
set -e

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

pnpm install --frozen-lockfile

echo "Waiting for pnpm and bundle integrity to match lockfiles...."
PNPM="pnpm list --json | grep -q 'Missing dependencies'"
BUNDLE="bundle check"

until ! $PNPM && $BUNDLE
do
  sleep 2;
done

echo "Ready to run Vite development server."

exec "$@"
