#!/bin/bash

echo "🔄 [GLOBAL-XMD] Watchdog started..."

while true; do
  git fetch origin
  if ! git diff --quiet HEAD origin/master; then
    echo "🆕 [GLOBAL-XMD] Update detected!"
    git reset --hard origin/master
    npm install || yarn install
    pkill -f "node" || true
    echo "🔁 [GLOBAL-XMD] Restarting..."
    npm start &
  fi
  sleep 60
done
