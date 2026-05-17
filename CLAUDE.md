# CLAUDE.md

本文件为 AI 协作会话提供项目上下文。

## 项目概述

MYSKME 游戏设计 —— 一个静态网页小游戏 / 课堂工具仓库。纯 HTML/CSS/JavaScript，
**无构建步骤、无依赖、无 package.json**。所有文件可直接在浏览器打开。

## 文件结构

- `index.html` —— 作品入口页（GitHub Pages 和本地打开时的首页）。
- `梦幻城堡课堂积分器.html` —— 桌面浏览器版课堂积分器。
- `MYSKME_命运左轮.html` —— 1 至 5 人派对转盘游戏。
- `ipad_bundle/index.html` —— iPad 版打包入口。
- `assets/` —— 主版本共用图片资源；`assets/memories/` 为照片素材。
- `ipad_bundle/assets/` —— iPad 版独立资源副本。
- 根目录 `*.zip` —— 可分发成品包（后续建议改放 GitHub Releases）。

## 本地预览

```bash
python3 -m http.server 8000
# 打开 http://localhost:8000/
```

## 约定

- 所有页面为单文件 HTML，样式和脚本内联，便于直接分发。
- 修改资源时注意 `assets/` 与 `ipad_bundle/assets/` 两处可能需要同步。
- 中文文件名是有意为之，保持不变。
- 提交信息使用简洁的祈使句，可中英文。

## 发布

`main` 分支通过 `.github/workflows/pages.yml` 自动部署到 GitHub Pages：
https://myskme.github.io/game-design/
