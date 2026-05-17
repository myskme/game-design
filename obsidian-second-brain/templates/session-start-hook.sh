#!/usr/bin/env bash
# SessionStart hook —— vault 环境校验
# 复制到 vault 的 .claude/hooks/session-start.sh 并加可执行权限。
# Claude Code(本地或网页端)启动时运行,把 vault 概况注入上下文。
set -euo pipefail

echo "=== 第二大脑 vault 环境校验 ==="

total=$(find . -name '*.md' -not -path './.obsidian/*' -not -path './.git/*' 2>/dev/null | wc -l | tr -d ' ')
echo "Markdown 笔记总数: ${total}"

if [ -d "00-inbox" ]; then
  inbox=$(find 00-inbox -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
  echo "收件箱待整理: ${inbox} 条"
fi

if [ -d "10-daily" ]; then
  latest=$(find 10-daily -name '*.md' 2>/dev/null | sort | tail -n 1)
  [ -n "${latest}" ] && echo "最近的每日笔记: ${latest##*/}"
fi

echo "=== 校验完成 ==="
