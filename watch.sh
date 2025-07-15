#!/bin/bash

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃      🔄 Watchdog Auto-Update Script      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
#
# ➤ Purpose:
#   - Monitors the GitHub repository of the bot GLOBAL-XMD
#   - Auto-updates the codebase using `git fetch` + `git reset`
#   - Restarts the bot automatically if updates are found
#
# ➤ How it works:
#   - Every 60 seconds, it checks for new commits on the `origin/master` branch
#   - If new updates are found:
#       • Pulls the latest code
#       • Installs new dependencies (npm or yarn)
#       • Kills the running bot and restarts it
#
# ➤ Usage:
#   - Automatically invoked by `docker-compose.yml` when the container starts
#   - No manual setup needed
#
# ➤ Notes:
#   - Ensure that you **do not delete the `.git` folder** if using this script
#   - If you are removing `.git` (for security or image size), you'll need to use a different update mechanis

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
