# MYSKME 游戏设计

这是一个静态网页小游戏/课堂工具仓库，当前包含：

- `梦幻城堡课堂积分器.html`：桌面浏览器版本的课堂积分器。
- `ipad_bundle/index.html`：适合 iPad 打开的打包版本。
- `MYSKME_命运左轮.html`：1 至 5 人派对转盘游戏。
- `index.html`：GitHub Pages 和本地打开时的作品入口。

## 在线访问

GitHub Pages 发布后可通过以下地址访问：

https://myskme.github.io/game-design/

## 本地打开

可以直接双击 `index.html`，也可以在终端进入本目录后启动本地服务：

```bash
python3 -m http.server 8000
```

然后打开：

```text
http://localhost:8000/
```

## 仓库说明

- 源文件以纯 HTML/CSS/JavaScript 为主，不需要安装依赖。
- `assets/` 存放主版本共用图片资源。
- `ipad_bundle/` 存放 iPad 版本入口和资源。
- 根目录的 zip 文件是可分发成品包；后续更推荐放到 GitHub Releases。

## 推荐发布方式

GitHub Pages 建议配置为：

- Source：`Deploy from a branch`
- Branch：`main`
- Folder：`/root`
