#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=${0:A:h}
REPO_DIR=${SCRIPT_DIR:h}
PUBLIC_URL=https://george-reply.tailbb125f.ts.net

cd "$REPO_DIR"
set -a
source .env.local
set +a

export NEXTAUTH_URL="$PUBLIC_URL"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

case "${1:-}" in
  web)
    exec /opt/homebrew/bin/npm run start
    ;;
  worker)
    exec /opt/homebrew/bin/npm run worker
    ;;
  cron)
    export CRON_BASE_URL=http://127.0.0.1:3000
    exec /bin/sh scripts/cron.sh
    ;;
  *)
    echo "usage: $0 {web|worker|cron}" >&2
    exit 64
    ;;
esac
