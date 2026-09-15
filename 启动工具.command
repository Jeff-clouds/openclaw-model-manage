#!/bin/zsh
set -euo pipefail

cd "$(dirname "$0")"
if [[ ! -f "node_modules/express/package.json" ]]; then
  osascript -e 'display alert "无法启动 OpenClaw Model Manager" message "缺少本地依赖，请先在项目目录运行 npm install。"'
  exit 1
fi

PORT=""
for candidate in {8765..8799}; do
  if ! lsof -nP -iTCP:"${candidate}" -sTCP:LISTEN >/dev/null 2>&1; then
    PORT="${candidate}"
    break
  fi
done

if [[ -z "${PORT}" ]]; then
  osascript -e 'display alert "无法启动 OpenClaw Model Manager" message "8765–8799 端口均被占用。"'
  exit 1
fi

URL="http://127.0.0.1:${PORT}/"
nohup env HOST=127.0.0.1 PORT="${PORT}" npm start >"/tmp/openclaw-model-manager-server-${PORT}.log" 2>&1 &
open "${URL}"
