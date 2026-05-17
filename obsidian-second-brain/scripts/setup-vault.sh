#!/usr/bin/env bash
# setup-vault.sh —— 把现有 Obsidian vault 一键接入 Git + Claude
#
# 用法(在 MacBook 上):
#   bash setup-vault.sh <vault 路径> <GitHub 仓库地址>
# 例:
#   bash setup-vault.sh ~/Documents/MyBrain git@github.com:myskme/brain.git
#
# 脚本会:初始化 Git、写入 .gitignore / CLAUDE.md / .claude 配置、
# 关联远程仓库、做首次提交。它不会删除你的任何笔记。
set -euo pipefail

VAULT="${1:-}"
REMOTE="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES="${SCRIPT_DIR}/../templates"

if [ -z "${VAULT}" ] || [ -z "${REMOTE}" ]; then
  echo "用法: bash setup-vault.sh <vault 路径> <GitHub 仓库地址>"
  exit 1
fi
if [ ! -d "${VAULT}" ]; then
  echo "错误:找不到目录 ${VAULT}"
  exit 1
fi
if [ ! -d "${TEMPLATES}" ]; then
  echo "错误:找不到 templates 目录,请连同整个 obsidian-second-brain 文件夹一起下载。"
  exit 1
fi

cd "${VAULT}"
echo "→ 处理 vault: $(pwd)"

# 1. 初始化 Git
if [ ! -d .git ]; then
  git init -b main
  echo "  已初始化 Git 仓库"
else
  echo "  已是 Git 仓库,跳过 init"
fi

# 2. 写入配置文件(不覆盖已存在的,避免冲掉你已有内容)
copy_if_absent () {
  local src="$1" dst="$2"
  if [ -e "${dst}" ]; then
    echo "  已存在,跳过: ${dst}"
  else
    mkdir -p "$(dirname "${dst}")"
    cp "${src}" "${dst}"
    echo "  写入: ${dst}"
  fi
}
copy_if_absent "${TEMPLATES}/gitignore"            ".gitignore"
copy_if_absent "${TEMPLATES}/vault-CLAUDE.md"      "CLAUDE.md"
copy_if_absent "${TEMPLATES}/settings.json"        ".claude/settings.json"
copy_if_absent "${TEMPLATES}/session-start-hook.sh" ".claude/hooks/session-start.sh"
chmod +x ".claude/hooks/session-start.sh"

# 3. 建议的目录骨架(只建空目录,已存在则不动)
for d in 00-inbox 10-daily 20-notes 30-projects 40-areas 90-archive _moc; do
  if [ ! -d "${d}" ]; then
    mkdir -p "${d}"
    printf '# %s\n\n占位文件,可删。\n' "${d}" > "${d}/.keep.md"
    echo "  建目录: ${d}/"
  fi
done

# 4. 关联远程仓库
if git remote get-url origin >/dev/null 2>&1; then
  echo "  remote origin 已存在: $(git remote get-url origin)"
else
  git remote add origin "${REMOTE}"
  echo "  关联 remote: ${REMOTE}"
fi

# 5. 首次提交
git add -A
if [ -n "$(git diff --cached --name-only)" ]; then
  git commit -m "chore: 接入 Git 与 Claude 配置"
  echo "  已提交"
fi

echo ""
echo "完成。下一步手动执行:"
echo "  cd \"${VAULT}\" && git push -u origin main"
echo "(首次推送可能需要在 GitHub 完成身份认证)"
