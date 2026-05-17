---
name: new-game-page
description: 当用户要新建一个单文件 HTML 小游戏或课堂工具页面时使用。
  按本仓库约定生成样式与脚本全内联的 HTML 页面，并在 index.html 登记入口卡片。
---

# 新建游戏页面

本仓库所有页面都是单文件 HTML，样式和脚本内联，便于直接分发。新建页面时遵循以下步骤。

## 步骤

1. **创建页面文件**
   - 在仓库根目录创建 `<游戏名>.html`（中文文件名可接受，与现有文件保持风格一致）。
   - `<style>` 和 `<script>` 全部内联，不引用外部 JS/CSS 文件。
   - 加上 `<meta charset="UTF-8">` 和 `<meta name="viewport" content="width=device-width, initial-scale=1.0">`。

2. **复用视觉变量**
   - 从 `index.html` 的 `:root` 复制 CSS 变量（`--ink`、`--gold`、`--teal`、`--rose` 等），保持全站视觉统一。

3. **登记入口**
   - 在 `index.html` 的作品列表区域新增一张入口卡片，链接到新页面。

4. **同步资源**
   - 若页面用到图片，放入 `assets/`；如果该页面也要进 iPad 版，同时放入 `ipad_bundle/assets/`。

5. **本地验证**
   - 运行 `python3 -m http.server 8000`，打开 `http://localhost:8000/<游戏名>.html` 检查显示与交互。

## 注意

- 不要引入构建步骤、依赖或 `package.json`。
- 提交信息用简洁祈使句，中英文皆可。
