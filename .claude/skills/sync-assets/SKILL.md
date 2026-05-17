---
name: sync-assets
description: 当用户修改、新增或删除 assets/ 下的图片资源，或怀疑 assets/ 与
  ipad_bundle/assets/ 两处资源不一致时使用。核对并同步两处目录。
---

# 同步资源目录

本仓库有两份资源目录，修改时容易漏改一处：

- `assets/` —— 主版本（桌面版、index.html）共用资源。
- `ipad_bundle/assets/` —— iPad 打包版的独立资源副本。

## 步骤

1. **核对差异** —— 运行同目录下的 `compare.sh`，列出两处目录的文件名与内容差异。

   ```bash
   .claude/skills/sync-assets/compare.sh
   ```

2. **判断同步方向**
   - 一般以 `assets/` 为准，把新增/修改的文件同步到 `ipad_bundle/assets/`。
   - 如果某资源只属于某一版本，向用户确认后再决定是否保留差异。

3. **执行同步** —— 用 `cp` 复制需要对齐的文件，保持子目录结构（如 `memories/`）。

4. **复核** —— 再次运行 `compare.sh`，确认差异已消除或为预期内的差异。

## 注意

- 不要盲目删除某一侧的文件；先确认它是否为该版本专属。
- 同步后在提交信息里说明同步了哪些资源。
