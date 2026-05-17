# Obsidian 第二大脑 · 接入 Claude + GitHub 自动同步

把你的 Obsidian 笔记库变成一个跨设备同步、可被 Claude 自动读写整理的「第二大脑」。

## 这套方案做什么

```
  iPhone ─┐
  iPad   ─┼──► 私有 GitHub 仓库(vault) ──► Claude Code 读写整理
  MacBook ┤         ▲                          (本地 + 网页端)
  MacBook ┘         └── Obsidian Git 插件自动提交/拉取
```

- **同步**:vault 是一个私有 GitHub 仓库,iPhone / iPad / 两台 MacBook 都用
  Obsidian 的 Git 插件自动提交、拉取,改动几分钟内全设备一致。
- **AI 读写**:在 MacBook 上用 Claude Code 直接打开 vault 整理笔记;
  也可把 vault 仓库接入 Claude Code 网页端做自动化。
- **自动化**:可选地用定时会话 / GitHub Actions 让 Claude 每天自动整理收件箱、
  写当日摘要。

> ⚠️ **重要**:vault 仓库必须设为 **Private(私有)**。笔记是私人内容,
> 绝不要放进当前这个 `game-design` 公开仓库(它会被 GitHub Pages 公开发布)。

## 文件清单

| 文件 | 用途 |
|---|---|
| `scripts/setup-vault.sh` | 在 MacBook 上一键把 vault 接入 Git + Claude |
| `templates/vault-CLAUDE.md` | 放进 vault 根目录,告诉 Claude 如何整理笔记 |
| `templates/gitignore` | vault 的 `.gitignore` |
| `templates/settings.json` | vault 的 `.claude/settings.json`(含启动 hook) |
| `templates/session-start-hook.sh` | vault 的 SessionStart hook,启动时报告概况 |
| `templates/daily-digest.yml` | 可选:GitHub Actions 每日自动整理 |

`setup-vault.sh` 会自动把上述模板写入 vault,无需手动复制。

---

## 第 1 步 · 为 vault 建私有 GitHub 仓库

1. 打开 https://github.com/new
2. 仓库名建议 `brain` 或 `obsidian-vault`(下面以 `myskme/brain` 为例)。
3. **务必选 Private**。不要勾选「Add a README」(留空仓库更省事)。
4. 创建后记下地址,例如 `git@github.com:myskme/brain.git`(SSH)
   或 `https://github.com/myskme/brain.git`(HTTPS)。

## 第 2 步 · 主力 MacBook:接入 Git

把本文件夹(`obsidian-second-brain/`)下载到 MacBook,然后在终端运行:

```bash
bash obsidian-second-brain/scripts/setup-vault.sh \
  ~/路径/到你的vault \
  git@github.com:myskme/brain.git
```

脚本会初始化 Git、写入 `.gitignore` / `CLAUDE.md` / `.claude/` 配置、
建好建议的目录骨架(`00-inbox/` 等)、做首次提交。最后按提示推送:

```bash
cd ~/路径/到你的vault
git push -u origin main
```

> vault 很大(几百 MB 图片)时首次推送会慢,属正常。

## 第 3 步 · MacBook:装 Obsidian Git 插件(自动同步)

在 Obsidian 里:

1. 设置 → 第三方插件 → 关闭「安全模式」。
2. 浏览社区插件,搜索并安装 **Obsidian Git**,启用它。
3. 进入 Obsidian Git 设置,推荐配置:
   - **Vault backup interval (minutes)**: `10`(每 10 分钟自动提交推送)
   - **Auto pull interval (minutes)**: `10`(每 10 分钟自动拉取)
   - **Pull updates on startup**: 开
   - **Push on backup**: 开

这样这台 MacBook 的改动会自动进 GitHub。

## 第 4 步 · 第二台 MacBook

不需要再跑 setup 脚本(配置已在仓库里)。直接克隆:

```bash
git clone git@github.com:myskme/brain.git ~/路径/到你的vault
```

然后在 Obsidian 里「打开文件夹作为 vault」选中它,同样装好 Obsidian Git 插件
(配置同第 3 步)。

## 第 5 步 · iPhone / iPad 接入

iOS 上的 Obsidian 也支持 Obsidian Git 插件:

1. 在 iPhone/iPad 的 Obsidian 里新建一个空 vault。
2. 安装并启用 **Obsidian Git** 插件。
3. 在插件设置里填仓库地址和认证信息(HTTPS + GitHub
   [Personal Access Token](https://github.com/settings/tokens) 最省心,
   token 勾选 `repo` 权限)。
4. 执行一次 Clone,把仓库拉到设备上。
5. 同样设置自动 backup / pull 间隔。

> 移动端 Git 对超大 vault(大量图片)可能偏慢或偶尔出错。如果体验不好,
> 可考虑官方付费的 **Obsidian Sync** 专门负责移动端同步,GitHub 仍作为
> MacBook 侧的备份与 Claude 接入点 —— 两者不冲突。

## 第 6 步 · Claude Code 本地读写 vault

在 MacBook 上,直接在 vault 目录里启动 Claude Code:

```bash
cd ~/路径/到你的vault
claude
```

vault 根目录的 `CLAUDE.md` 会告诉 Claude 目录约定和整理规则。
启动时 SessionStart hook 会报告笔记数、收件箱待办数。常用指令例如:

- 「整理一下收件箱」
- 「把这周的笔记写一份摘要」
- 「给『教学』主题建一个 MOC 索引页」

改完让它 `git commit` 并 `git push`,其他设备会自动拉到。

## 第 7 步 · Claude Code on web 自动化

让云端的 Claude 也能整理 vault:

1. 打开 https://claude.com/code,连接 GitHub,授权 `myskme/brain` 仓库。
2. 为该仓库创建一个环境(Environment)。仓库里已有的
   `.claude/settings.json` + SessionStart hook 会自动生效。
3. 之后你可以从手机 / 网页发起会话,例如「整理收件箱并写今日摘要」,
   Claude 在云端容器里改完直接提交推送,设备端自动同步。
4. 想要「定时」自动跑:用 Claude Code on web 的**计划/定时会话**功能,
   设一个每天固定时间触发的会话,提示词写「按 CLAUDE.md 整理收件箱、
   写今日摘要」。

文档参考:https://code.claude.com/docs/en/claude-code-on-the-web

## 第 8 步(可选) · GitHub Actions 每日自动整理

如果想完全无人值守,把 `templates/daily-digest.yml` 复制到 vault 仓库的
`.github/workflows/daily-digest.yml`,并按文件顶部注释:

- 在 vault 仓库添加 `ANTHROPIC_API_KEY`(会按 API 用量计费)。
- 开启 Actions 的写权限。

不想计费就跳过这步,用第 7 步的定时会话即可。

---

## 关于 Codex

如果你也用 OpenAI Codex CLI,可以在 vault 目录里直接运行 `codex`,
它会读取同一个 `CLAUDE.md` 作为上下文(或另建 `AGENTS.md`),
玩法与第 6 步一致 —— 两个工具共用同一个 Git 仓库,互不干扰。

## 日常习惯建议

- 想到什么先丢 `00-inbox/`,不纠结分类。
- 每隔几天让 Claude「整理收件箱」。
- 每台设备打开 Obsidian 时等一下,让 Git 插件先拉取最新再编辑。
- 同一时间尽量只在一台设备上大改,减少冲突。

## 故障排查

| 现象 | 处理 |
|---|---|
| 同步冲突 / merge conflict | 在 MacBook 上 `git status` 看冲突文件,手动保留两边内容后提交 |
| 移动端推送失败 | 多为认证过期,重新生成 PAT 并在插件里更新 |
| 设备间内容不一致 | 确认每台都开了 Obsidian Git 的 auto pull;手动「Pull」一次 |
| 不想同步工作区状态 | 已由 `.gitignore` 排除 `workspace.json`,无需处理 |
