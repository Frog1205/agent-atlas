---
name: agent-atlas
description: |
  Agent Atlas — AI Agent 水平评测器（基于 DAMC 模型，自托管版）。
  自动扫描用户的 AI Agent 环境（Claude Code、Codex、Cursor、Windsurf、Continue、Aider 等），
  量化评估四个维度：蒸馏价值(D)、抗蒸馏指数(A)、AI驾驭能力(M)、职业适配(C)，生成可分享的可视化 HTML 报告。
  **报告托管在评测者自己的 GitHub Pages，不上传任何第三方平台。**
  兼容所有能运行 Shell 命令的 AI Agent。
  触发条件：用户提到"评估我的 Agent 水平"、"agent-atlas"、"DAMC 自托管版"、"AI 能力评测"、
  "我的 Agent 水平怎么样"、"蒸馏评估"、"测一下我的 AI 水平"。
---

# Agent Atlas — AI Agent 水平评测器（自托管版）

> Fork 自 DAMC,去掉所有第三方上传,报告完全托管在你自己的 GitHub Pages。
> 不是恐吓你会被取代,而是帮你看清自己在 AI 时代的真实坐标。

## 兼容 Agent

DAMC 支持扫描以下 AI Agent 环境（自动检测，无需配置）：

| Agent | 配置目录 | 检测信号 |
|-------|---------|---------|
| Claude Code | `~/.claude/` | skills, hooks, MCP, memory |
| OpenAI Codex | `~/.codex/` | agents, config, sessions |
| Cursor | `~/.cursor/` | rules, extensions, settings |
| Windsurf | `~/.codeium/windsurf/` | rules, cascade config |
| Continue | `~/.continue/` | config, models, rules |
| Aider | `~/.aider*` | config, model settings |
| GitHub Copilot | `~/.config/github-copilot/` | settings, instructions |
| WorkBuddy | `~/.workbuddy/` | config, skills |
| Trae (ByteDance) | `~/.trae/` | rules, extensions, settings |
| 通义灵码 (Lingma) | `~/.lingma/` | config, rules, extensions |
| 豆包 MarsCode | `~/.marscode/` | config, rules, extensions |
| CodeGeeX (智谱) | `~/.codegeex/` | config, chat history |
| Baidu Comate | `~/.comate/` | config, extensions |
| DevChat | `~/.chat/` | config, workflows |

如果用户环境中安装了多个 Agent，则合并扫描，取最高分。

## DAMC 模型

| 维度 | 全称 | 核心问题 |
|------|------|---------|
| **D** | Distillation Value | 你的经验值得被蒸馏成 AI Skill 吗？ |
| **A** | Anti-Distillation | 你的哪些能力是 AI 拿不走的？ |
| **M** | AI Mastery | 你驾驭 AI 工具的水平如何？ |
| **C** | Career Compass | 基于以上三维，你该往哪走？ |

## 执行流程

### Phase 0: 隐私告知（必须，第一步）

**触发后立刻显示，等用户确认后才能扫描：**

```
🔒 Agent Atlas 隐私承诺（请阅读）

我即将扫描你的本地环境来生成 Agent 体检报告，包括：
  ~/.claude/ 配置 · git 历史 · 已安装开发工具

数据流向（自托管,完全透明）：
  ✅ 所有扫描结果只在你本地处理
  ✅ 本地生成可视化 HTML 报告 → 保存到 ~/Desktop/
  ✅ 如果你启用"在线分享":通过 gh CLI 推送 HTML 到你自己的
     GitHub 仓库 (默认 <YOUR_GH_USER>/<YOUR_REPO>),
     报告 URL = https://<YOUR_GH_USER>.github.io/<YOUR_REPO>/r/<token>.html
  ❌ 不调用任何第三方 API,不上传任何数据到外部平台
  ❌ GitHub 仓库可以是 private (链接只你自己能访问)
     也可以是 public (评测信息公开但你拥有数据)

→ 输入 "同意" 继续(本地评估 + 推送到你的 GitHub Pages)
→ 输入 "本地模式" 只生成本地 HTML,不推任何远端
→ 输入 "取消" 退出
```

**用户回答后路由：**
- "同意" / "yes" / "ok" → Phase 1-5 扫描评估 + 推送到用户 GitHub Pages + 显示完整汇总
- "本地模式" / "local" → Phase 1-4 扫描评估,仅生成 ~/Desktop/HTML,跳过 Phase 5
- "取消" / "no" → 直接退出

**Phase 0.5: 读取用户的 GitHub 仓库配置**

在 Phase 5 之前,需要知道推送目标。按以下优先级查找:
1. `~/.config/agent-atlas/config.json` 里的 `{ "gh_user": "...", "gh_repo": "..." }`
2. 如果不存在,询问用户 GitHub 用户名和仓库名,然后写入上述 config.json 持久化
3. 验证 `gh auth status` 已登录,否则提示用户先 `gh auth login`

### Phase 1: 自动扫描（核心 — 不依赖问卷）

**扫描所有检测到的 AI Agent 环境，静默执行，不需要用户参与。**

#### 1.0 Agent 环境检测

```bash
echo "=== DAMC Agent Detection ==="
[ -d "$HOME/.claude" ] && echo "DETECTED: Claude Code"
[ -d "$HOME/.codex" ] || command -v codex >/dev/null 2>&1 && echo "DETECTED: Codex"
[ -d "$HOME/.cursor" ] && echo "DETECTED: Cursor"
[ -d "$HOME/.codeium/windsurf" ] && echo "DETECTED: Windsurf"
[ -d "$HOME/.continue" ] && echo "DETECTED: Continue"
[ -f "$HOME/.aider.conf.yml" ] || [ -d "$HOME/.aider" ] && echo "DETECTED: Aider"
[ -d "$HOME/.config/github-copilot" ] && echo "DETECTED: GitHub Copilot"
[ -d "$HOME/.workbuddy" ] && echo "DETECTED: WorkBuddy"
[ -d "$HOME/.trae" ] && echo "DETECTED: Trae"
[ -d "$HOME/.lingma" ] && echo "DETECTED: 通义灵码"
[ -d "$HOME/.marscode" ] && echo "DETECTED: MarsCode"
[ -d "$HOME/.codegeex" ] && echo "DETECTED: CodeGeeX"
[ -d "$HOME/.comate" ] && echo "DETECTED: Comate"
[ -d "$HOME/.chat" ] && echo "DETECTED: DevChat"
```

将检测结果记录下来，用于 Phase 3 多 Agent 合并评分。

#### 1.1 Claude Code 环境扫描（如果检测到 `~/.claude/`）

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.claude/CLAUDE.md
  → 文件是否存在、行数、自定义规则数量、是否有工作流定义

~/.claude/settings.json
  → hooks 配置数量和类型、权限模式、MCP servers 列表

~/.claude/skills/
  → skill 总数、自建 vs 安装(检查是否为 symlink)、类别分布

~/.claude/memory/
  → MEMORY.md 是否存在、memory 文件数量、类型分布

~/.claude/keybindings.json
  → 是否存在、自定义快捷键数量

~/.claude/projects/
  → 项目数量、项目级 CLAUDE.md 深度
```

#### 1.2 Codex 环境扫描（如果检测到 `~/.codex/` 或 codex CLI）

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.codex/
  → 目录结构和文件数量

~/.codex/generated_images/
  → session 数量（代表使用频率）、图片生成总数

项目级 AGENTS.md 或 codex 配置
  → 是否为 Codex 定制了项目指令

codex --version
  → 版本号
```

#### 1.3 Cursor 环境扫描（如果检测到 `~/.cursor/`）

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.cursor/rules/
  → 自定义规则文件数量和大小

项目级 .cursorrules 或 .cursor/rules/
  → 规则复杂度（行数、是否分文件）

~/.cursor/extensions/
  → 已安装扩展数量
```

#### 1.4 Windsurf 环境扫描（如果检测到 `~/.codeium/windsurf/`）

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.codeium/windsurf/
  → 配置深度

项目级 .windsurfrules
  → 是否自定义了 Windsurf 规则

Cascade 配置
  → 是否使用了 Cascade agentic 模式
```

#### 1.5 Continue 环境扫描（如果检测到 `~/.continue/`）

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.continue/config.json
  → 模型配置数量、自定义 provider、context providers

~/.continue/config.ts
  → 是否有高级 TypeScript 配置

~/.continue/.continuerules
  → 自定义规则
```

#### 1.6 Aider 环境扫描（如果检测到）

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.aider.conf.yml
  → 配置复杂度

.aider* 项目级配置
  → 是否自定义了模型、lint 命令等

aider --version
  → 版本号
```

#### 1.7 GitHub Copilot 扫描

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.config/github-copilot/
  → 配置是否存在

.github/copilot-instructions.md
  → 项目级指令文件
```

#### 1.8 WorkBuddy 环境扫描（如果检测到 `~/.workbuddy/`）

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.workbuddy/
  → 目录结构、配置文件数量、skill/插件数量
```

#### 1.9 Trae 环境扫描（如果检测到 `~/.trae/`）

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.trae/
  → 目录结构、配置文件

~/.trae/rules/ 或项目级 .trae/rules/
  → 自定义规则数量和复杂度

~/.trae/extensions/
  → 已安装扩展数量
```

#### 1.10 通义灵码环境扫描（如果检测到 `~/.lingma/`）

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.lingma/
  → 配置目录结构

~/.lingma/config 或 settings
  → 自定义配置深度（模型选择、代码补全偏好等）

项目级 .lingma 配置
  → 是否有项目级定制
```

#### 1.11 MarsCode 环境扫描（如果检测到 `~/.marscode/`）

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.marscode/
  → 配置目录结构

项目级 .marscode/ 或自定义规则
  → 是否有项目定制

MarsCode IDE 扩展
  → 已安装扩展数量和类型
```

#### 1.12 CodeGeeX / Comate / DevChat 环境扫描

```
扫描目标 → 评估信号
──────────────────────────────────────────
~/.codegeex/ / ~/.comate/ / ~/.chat/
  → 目录存在 = 使用过该工具
  → 配置文件复杂度
  → 对话历史数量（如果有）
  → 项目级配置存在
```

#### 1.13 Git 历史扫描（通用）

```
git log --oneline -100
  → AI 协作提交数（含 Co-Authored-By / Cursor / Copilot / Codex 标记）
  → 总提交频率

git log --all --author 过滤
  → 用户活跃度
```

#### 1.10 工作环境信号（通用）

```
检查已安装的开发工具
  → node/python/go 等（技术栈广度）
  → docker/k8s（DevOps 能力信号）

检查 AI Agent 总数
  → 安装的 Agent 数量本身就是 M 维度信号（多 Agent 加分）
```

### Phase 2: 快速画像（仅问 3 个问题）

扫描完成后，**只问用户 3 个问题**（不是问卷，是对话）：

1. **你的职业角色是什么？**（如：前端开发、产品经理、SEO专家、设计师、运营）
2. **你最核心的工作产出是什么？**（如：代码、文档、设计稿、决策、沟通协调）
3. **你的 MBTI 类型？**（可选，输入"跳过"则不纳入分析）

### Phase 3: 评分计算

读取 `references/scoring-framework.md` 获取详细评分算法。

**核心原则：**
- M 维度（AI 驾驭）100% 基于自动扫描数据，客观量化
- D 维度（蒸馏价值）70% 自动扫描 + 30% 用户画像推断
- A 维度（抗蒸馏）40% 自动扫描 + 60% 基于角色/产出类型推断
- C 维度（职业适配）= f(D, A, M) + MBTI 调整

**读取 `references/career-archetypes.md` 匹配用户的 8 种画像之一。**

### Phase 4: 生成可视化报告（本地 LITE 版）

1. 读取 `templates/report.html` 模板
2. 将评分数据填入模板中的 `window.DAMC_DATA` 对象
3. 将 LITE 版 HTML 保存到 `~/Desktop/DAMC-Report-{YYYY-MM-DD}.html`
   - LITE 版只含 4 维总分和画像，不含子维度详情、可蒸馏清单、护城河识别、行动建议
4. 完整版（含洞察、行动建议）默认就在本地报告里 — 这个自托管版没有"付费解锁"。在线版仅是把同一份 HTML 推到你自己的 GitHub Pages,方便分享链接

### Phase 5: 推送报告到用户的 GitHub Pages（仅同意时）

**核心规则：不调用任何第三方 API。完整 HTML 报告通过 gh CLI 推到用户自己的仓库。**

#### 5.1 生成 token 和文件名

```
token = 6 位随机字符串 (a-z0-9),如 "x7k2pq"
filename = "r/<token>.html"
```

#### 5.2 推送流程

```bash
# 已通过 Phase 0.5 获取到 GH_USER 和 GH_REPO
TMP=$(mktemp -d)
gh repo clone "$GH_USER/$GH_REPO" "$TMP" -- --depth=1
mkdir -p "$TMP/r"
cp ~/Desktop/AgentAtlas-Report-{date}.html "$TMP/r/<token>.html"
cd "$TMP"
git add "r/<token>.html"
git -c user.email="agent-atlas@local" -c user.name="Agent Atlas" \
  commit -m "report: <token> ($(date +%Y-%m-%d))"
git push origin HEAD
```

#### 5.3 返回 URL

报告 URL = `https://<GH_USER>.github.io/<GH_REPO>/r/<token>.html`

(前提:用户已在该仓库 Settings → Pages 启用 GitHub Pages,source = main branch root)

#### 5.4 推送失败的降级处理

可能的失败:
- 仓库不存在 → 提示用户先创建,或自动 `gh repo create <user>/<repo> --public`
- 未登录 → 提示 `gh auth login`
- 网络问题 → 保留本地 HTML,告知用户稍后手动推送
- 仓库未开 GitHub Pages → 推送成功但 URL 暂时 404,提示用户去仓库 Settings 开启

任何失败情况下,本地 HTML 都已生成,功能不受影响。

#### 5.5 终端显示

```
📊 你的 Agent 体检完成

  检测到 AI Agent: Claude Code, Codex, Cursor

  D ████████░░ 78  M █████████░ 85
  A ██████░░░░ 62  C ██████░░░░ 65

  画像：🏆 AI 架构师

  📄 本地报告：~/Desktop/AgentAtlas-Report-{date}.html
  🔗 在线报告：https://<GH_USER>.github.io/<GH_REPO>/r/<token>.html
```


**`window.DAMC_DATA` 结构：**

```javascript
window.DAMC_DATA = {
  userName: "用户角色",
  date: "2026-04-08",
  mbti: "INTJ", // 或 null
  agents: ["Claude Code", "Codex", "Cursor"], // 检测到的 Agent 列表
  archetype: { name: "AI架构师", emoji: "🏆", tagline: "一句话定位" },
  overall: 72,
  scores: {
    D: { total: 78, subs: { expertise: 82, methodology: 65, codifiability: 88, standardization: 72, demand: 83 } },
    A: { total: 62, subs: { creativity: 70, eq: 55, crossDomain: 68, ambiguity: 60, physical: 40, trust: 75 } },
    M: { total: 85, subs: { environment: 18, skills: 22, automation: 16, memory: 12, advanced: 17 } },
    C: { total: 65, fit: "AI-Augmented Expert", paths: ["推荐路径1", "推荐路径2"] }
  },
  insights: {
    distillTargets: ["值得蒸馏的能力1", "值得蒸馏的能力2"],
    moats: ["护城河1", "护城河2"],
    risks: ["风险点1"],
    actions: ["行动建议1", "行动建议2", "行动建议3"]
  },
  scanSummary: {
    totalSkills: 83,
    customSkills: 5,
    hooksCount: 3,
    mcpServers: 8,
    memoryFiles: 12,
    claudeMdLines: 150,
    aiCommits: 45,
    totalCommits: 200
  }
};
```

## 输出规范

### 在终端显示的摘要

**所有 Phase 执行完毕后，统一输出最终汇总（覆盖此前的中间输出）：**

```
📊 Agent Atlas 评估完成

  D 蒸馏价值  ████████░░  78
  A 抗蒸馏    ██████░░░░  62
  M AI驾驭   █████████░  85
  C 职业适配  ██████░░░░  65

  画像：🏆 AI架构师
  "你有值得蒸馏的深度经验，且善用 AI 放大自己的价值"

---
报告输出汇总：

  📄 完整报告：~/Desktop/AgentAtlas-Report-2026-04-08.html
  🔗 在线报告：https://<GH_USER>.github.io/<GH_REPO>/r/{token}.html

  💡 完整 22 子维度详情、可蒸馏清单、护城河识别、行动路径
     都已经在本地 HTML 报告里 — 这个自托管版没有付费墙
```

**如果用户选择了"本地模式"，则不显示在线报告那一行。**

### 报告输出路径

- 默认保存到 `~/Desktop/AgentAtlas-Report-{YYYY-MM-DD}.html`
- 如果用户指定路径则按用户指定

## 评分时的注意事项

- M 维度的评分必须基于实际扫描到的数据，不要凭感觉打分
- D 和 A 维度中基于推断的部分，要在报告中标注"基于角色推断"
- 整体评分 = D×0.25 + A×0.30 + M×0.25 + C×0.20
- A 维度权重最高，因为抗蒸馏能力是 AI 时代最核心的竞争力
