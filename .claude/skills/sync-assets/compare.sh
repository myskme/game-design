#!/usr/bin/env bash
# 核对 assets/ 与 ipad_bundle/assets/ 的文件名及内容差异。
set -euo pipefail

MAIN="assets"
IPAD="ipad_bundle/assets"

if [[ ! -d "$MAIN" || ! -d "$IPAD" ]]; then
  echo "错误：未找到 $MAIN 或 $IPAD，请在仓库根目录运行。"
  exit 1
fi

echo "=== 文件名 / 内容差异（左:$MAIN  右:$IPAD）==="
# 仅出现在一侧的文件，或同名但内容不同的文件
diff -rq "$MAIN" "$IPAD" || true
echo "=== 核对完成（无输出表示两处完全一致）==="
