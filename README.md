# Agent Atlas

> AI Agent 水平评测器 — 自托管版。Fork 自 DAMC,去掉所有第三方上传,报告完全托管在你自己的 GitHub Pages。

## 它做什么

扫描你机器上的 AI Agent 环境(Claude Code、Codex、Cursor、Windsurf、Continue、Aider、Trae、通义灵码、MarsCode、CodeGeeX、Comate、DevChat、WorkBuddy),量化评估四个维度:

| 维度 | 全称 | 核心问题 |
|------|------|---------|
| **D** | Distillation Value | 你的经验值得被蒸馏成 AI Skill 吗? |
| **A** | Anti-Distillation | 你的哪些能力是 AI 拿不走的? |
| **M** | AI Mastery | 你驾驭 AI 工具的水平如何? |
| **C** | Career Compass | 基于以上三维,你该往哪走? |

输出可视化 HTML 报告,可选推送到你自己的 GitHub Pages 获得分享链接。

## 和原版 DAMC 的区别

| | DAMC 原版 | Agent Atlas |
|---|----------|-------------|
| 数据上传 | 评分数字上传到 damc.ai | **不上传任何第三方** |
| 在线报告 | damc.space/r/{token} | 你自己的 `<gh_user>.github.io/<repo>/r/{token}.html` |
| 完整分析 | 网页端付费解锁 | 本地报告已含全部内容 |
| Skills 上架 | 提交到 damc 商城 | 移除该功能 |
| 数据所有权 | 平台方 | 你 |

## 🤖 给 AI Agent 用（推荐）

把下面这段话**直接复制粘贴**给你的 Claude Code / Codex / Cursor / 其他 Agent，它会自己装好并跑评估：

```
请帮我安装并运行 Agent Atlas (AI Agent 水平自评测器,自托管版)。

执行步骤:
1. 从 https://github.com/Frog1205/agent-atlas clone 到你所在 Agent 的 skills 目录
   (Claude Code: ~/.claude/skills/agent-atlas/
    Codex: ~/.codex/skills/agent-atlas/
    其他: 找你自己的 skills/ 目录)
2. clone 完成后,读取 SKILL.md 并严格按里面的 Phase 0~5 执行评估
3. 生成可视化 HTML 报告,推送到我自己的 GitHub Pages
   (首次运行会问我 GitHub 用户名/仓库名,然后存到 ~/.config/agent-atlas/config.json)
4. 在终端汇总展示 D/A/M/C 四个维度分数 + 本地报告路径 + 在线链接

SKILL.md 是给你(Agent)看的操作手册,不是给人看的文档,请完整阅读后再执行。
```

任何能跑 shell + 读本地文件的 Agent 都能消化这段。Skill 本身就是 Markdown,是给 Agent 看的指令+流程,不是给人看的代码。

## 🧑‍💻 给人类用（手动安装）

```bash
# 一键脚本(检测所有 Agent 并安装到对应目录)
curl -fsSL https://raw.githubusercontent.com/Frog1205/agent-atlas/main/install.sh | bash

# 或手动 clone(单 Agent)
git clone https://github.com/Frog1205/agent-atlas.git ~/.claude/skills/agent-atlas
```

## 前置依赖

- [GitHub CLI](https://cli.github.com/) (`gh`),已登录: `gh auth login`
- 一个用来托管报告的 GitHub 仓库(脚本会引导你创建)
- Claude Code / Codex / 任意 Anthropic-compatible Agent

## 使用

在 Claude Code 里说:

```
评估下我的 Agent 水平
```

首次运行会问你:
1. GitHub 用户名和仓库名(写入 `~/.config/agent-atlas/config.json`,下次不再问)
2. 是否同意推送报告到该仓库(选"本地模式"则只生成本地 HTML)

## GitHub Pages 设置

报告仓库需要启用 Pages:

1. `gh repo create <user>/<repo> --public`(或自己手动建)
2. 仓库 Settings → Pages → Source 选 `main` 分支 root
3. 等几分钟,`https://<user>.github.io/<repo>/` 可访问后即可

## 隐私

- 所有扫描结果只在你本地处理
- 推送时只推 HTML 文件本身(就是你的报告)
- 仓库可以设 private(链接只你能看)或 public(评测信息公开)
- 不调任何第三方 API,代码全开源可审计

## License

MIT(继承自原版 DAMC)。

## Credits

- 评测模型(DAMC)、扫描逻辑、UI 模板来自原版 DAMC
- 自托管改造由 [@Frog1205](https://github.com/Frog1205) 完成
