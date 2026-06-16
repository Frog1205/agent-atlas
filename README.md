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

## 安装

```bash
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
