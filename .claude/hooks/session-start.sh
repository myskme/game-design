#!/usr/bin/env bash
# SessionStart 钩子：校验静态站点的预览环境是否就绪。
set -euo pipefail

echo "=== MYSKME game-design 环境校验 ==="

if command -v python3 >/dev/null 2>&1; then
  echo "python3: $(python3 --version 2>&1) — 可用于本地预览 (python3 -m http.server)"
else
  echo "警告: 未找到 python3，本地预览需另选静态服务器。"
fi

html_count=$(find . -maxdepth 2 -name '*.html' -not -path './.git/*' | wc -l | tr -d ' ')
echo "HTML 页面数量: ${html_count}"

echo "=== 校验完成 ==="
