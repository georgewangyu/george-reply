#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=${0:A:h}
REPO_DIR=${SCRIPT_DIR:h}
LOCAL_SERVICE_ENV_FILE=${GEORGE_REPLY_LOCAL_SERVICE_ENV_FILE:-$REPO_DIR/.env.local-service}

cd "$REPO_DIR"
set -a
source .env.local
if [[ ! -r "$LOCAL_SERVICE_ENV_FILE" ]]; then
  echo "missing local service environment: $LOCAL_SERVICE_ENV_FILE" >&2
  exit 78
fi
source "$LOCAL_SERVICE_ENV_FILE"
set +a

: "${LOCAL_SERVICE_PUBLIC_URL:?Set LOCAL_SERVICE_PUBLIC_URL in $LOCAL_SERVICE_ENV_FILE}"
export NEXTAUTH_URL="$LOCAL_SERVICE_PUBLIC_URL"
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
