# DAMC 评分框架

## 多 Agent 评分原则

DAMC 支持扫描多个 AI Agent。M 维度评分采用 **合并取最高** 策略：
- 每个 Agent 独立计算各子维度得分
- 同一子维度取所有 Agent 中的最高分
- 最终 M 维度分数 = 各子维度最高分之和
- 每多安装一个 Agent，在 M5（高级功能）中额外加分

---

## M 维度：AI 驾驭指数（100% 自动检测）

### M1: 环境配置深度（满分 20）

**Claude Code 信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| Global CLAUDE.md 存在 | +3 | 检查 ~/.claude/CLAUDE.md |
| CLAUDE.md > 50 行 | +2 | wc -l |
| CLAUDE.md > 200 行 | +3 | wc -l（与上条累加） |
| 有自定义规则/工作流定义 | +4 | grep 关键词：规则、workflow、hook、规范 |
| 项目级 CLAUDE.md 存在 | +3 | 检查 ~/.claude/projects/ 下的文件 |
| keybindings.json 有自定义 | +3 | 文件存在且非空 |
| settings.json 有自定义权限 | +2 | 检查 permissions 配置 |

**Codex 等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| codex CLI 已安装 | +3 | command -v codex |
| 有自定义 agent instructions | +4 | 检查 AGENTS.md 或 codex 配置 |
| 有模型偏好配置 | +3 | 检查是否配置了非默认模型 |
| 项目级 Codex 配置存在 | +3 | 检查项目中的 codex 相关文件 |
| codex 使用频率（session 数）| +4 | 统计 ~/.codex/ 下的 session 数量 |
| 有沙箱策略配置 | +3 | 检查 sandbox 设置 |

**Cursor 等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| .cursorrules 文件存在 | +3 | 检查项目根目录 |
| .cursorrules > 50 行 | +3 | wc -l |
| .cursor/rules/ 多文件规则 | +4 | 检查 rules 目录文件数 |
| Cursor settings 有 AI 配置 | +3 | 检查 ~/.cursor/ 下配置 |
| 自定义模型配置 | +3 | 检查是否配了非默认模型 |
| 有项目级指令文件 | +4 | 检查 .cursor/rules/ |

**Windsurf 等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| .windsurfrules 文件存在 | +3 | 检查项目根目录 |
| .windsurfrules > 50 行 | +3 | wc -l |
| Cascade 模式使用 | +4 | 检查 cascade 相关配置 |
| 自定义 memory/context | +4 | 检查配置深度 |
| Windsurf 配置目录深度 | +3 | ~/.codeium/windsurf/ 文件数 |

**Continue 等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| config.json 存在 | +3 | 检查 ~/.continue/config.json |
| 多模型配置（≥2） | +4 | 检查 models 数组长度 |
| 自定义 context providers | +4 | 检查 contextProviders 配置 |
| .continuerules 存在 | +3 | 检查自定义规则 |
| config.ts 高级配置 | +4 | TypeScript 配置比 JSON 更高级 |

**Aider 等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| aider 已安装 | +3 | command -v aider |
| .aider.conf.yml 存在 | +3 | 检查配置文件 |
| 配置了非默认模型 | +4 | 检查 model 配置 |
| 有 lint/test 命令配置 | +4 | 检查 lint-cmd, test-cmd |
| 有 .aiderignore | +3 | 文件存在说明有深度使用 |

**GitHub Copilot 等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| Copilot 配置目录存在 | +3 | ~/.config/github-copilot/ |
| .github/copilot-instructions.md | +5 | 项目级指令 |
| copilot-instructions > 50 行 | +3 | wc -l |

**WorkBuddy 等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| WorkBuddy 目录存在 | +3 | ~/.workbuddy/ |
| 有 skills/插件 | +4 | 检查 skills 或 plugins 目录 |
| 自定义配置深度 | +4 | 检查配置文件行数/复杂度 |

**Trae（字节跳动）等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| Trae 配置目录存在 | +3 | ~/.trae/ |
| 有自定义规则 | +4 | 检查 rules 目录 |
| 规则 > 50 行 | +3 | wc -l |
| 有项目级配置 | +4 | 检查 .trae/rules/ |
| 已安装扩展数量 | +3 | 统计 extensions |
| 自定义模型配置 | +3 | 检查模型偏好 |

**通义灵码等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| 灵码配置目录存在 | +3 | ~/.lingma/ |
| 有自定义补全偏好 | +4 | 检查配置文件 |
| 有项目级定制 | +4 | 检查项目中 .lingma 配置 |
| 配置文件复杂度 | +3 | 检查行数和字段数 |

**MarsCode（豆包）等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| MarsCode 配置目录存在 | +3 | ~/.marscode/ |
| 有自定义规则/指令 | +4 | 检查 rules 或 config |
| 有项目级配置 | +4 | 检查项目中 .marscode/ |
| 已安装扩展数量 | +3 | 统计 extensions |

**CodeGeeX / Comate / DevChat 等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| 配置目录存在 | +3 | ~/.codegeex/ / ~/.comate/ / ~/.chat/ |
| 有自定义配置 | +4 | 检查 config 文件 |
| 有对话历史/使用记录 | +4 | 检查 history 文件 |
| 有项目级定制 | +3 | 检查项目中相关配置 |

### M2: Skill / 扩展生态（满分 25）

**Claude Code：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| skills 目录存在 | +2 | ls ~/.claude/skills/ |
| 1-10 个 skills | +3 | count |
| 11-30 个 skills | +5 | count（取代上条） |
| 31-60 个 skills | +8 | count（取代上条） |
| 60+ 个 skills | +10 | count（取代上条） |
| 有自建 skill（非 symlink） | +5 | readlink 检查 |
| 自建 skill ≥ 3 | +8 | 取代上条 |
| 自建 skill ≥ 5 | +10 | 取代上条 |
| skill 类别覆盖 ≥ 3 类 | +5 | 分类统计 |

**Codex 等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| 有自定义 agents | +5 | 检查 agents 配置 |
| 自定义 agents ≥ 3 | +10 | count |
| 使用了图片生成 | +3 | ~/.codex/generated_images/ 存在 |
| session 数量 ≥ 10 | +5 | 统计 sessions |
| session 数量 ≥ 50 | +8 | 取代上条 |

**Cursor 等效信号：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| 安装扩展 1-20 | +3 | count |
| 安装扩展 21-50 | +5 | 取代上条 |
| 安装扩展 50+ | +8 | 取代上条 |
| 多规则文件管理 | +7 | .cursor/rules/ 下文件数 ≥ 3 |
| Composer 使用深度 | +5 | 检查 composer 历史/配置 |

**其他 Agent 通用信号：**

| 信号 | 分值 | 适用 Agent |
|------|------|-----------|
| 有自定义规则/指令 | +5 | Windsurf, Continue, Aider, Copilot |
| 规则超过 100 行 | +8 | 所有 |
| 多模型配置（≥3） | +5 | Continue, Aider |
| 有项目级定制 | +5 | 所有 |

**Skill 类别分类参考（Claude Code）：**
- 开发工具类（codex, review, ship, investigate 等）
- 内容创作类（article-rewriter, style-jd, xiaohongshu 等）
- SEO/营销类（seo-audit, programmatic-seo, geo-* 等）
- 浏览器/测试类（browse, qa, gstack 等）
- 数据/抓取类（firecrawl-*, agent-reach, apify 等）
- 设计/UI类（frontend-design, design-*, baoyu-image-gen 等）
- 媒体/音视频类（youtube-clipper, ai-podcast-*, text-to-speech 等）
- 自动化/工作流类（autoplan, ship, land-and-deploy 等）
- 社交媒体类（reddit-*, x-*, write-xiaohongshu 等）
- 安全/审计类（cso, careful, skill-vetter 等）

### M3: 自动化与集成（满分 20）

**Claude Code：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| 有 hooks 配置 | +5 | settings.json 中 hooks 字段 |
| hooks ≥ 3 个 | +3 | count |
| 有 MCP servers 配置 | +3 | settings.json 中 mcpServers |
| MCP servers ≥ 3 | +3 | count |
| MCP servers ≥ 5 | +3 | count（与上条累加） |
| MCP servers ≥ 8 | +3 | count（与上条累加） |

**通用自动化信号（所有 Agent）：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| CI/CD 中有 AI 集成 | +5 | 检查 .github/workflows/ 中是否调用 AI |
| Shell alias/function 调用 AI | +5 | 检查 .zshrc/.bashrc |
| 多 Agent 协作使用 | +5 | 检测到 ≥ 2 个 Agent |
| API key 配置（非 Agent 内） | +5 | 检查环境变量中的 AI API key |

### M4: 记忆/上下文系统（满分 15）

**Claude Code：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| MEMORY.md 存在 | +3 | 检查文件 |
| memory 文件 1-5 个 | +3 | count |
| memory 文件 6-15 个 | +5 | 取代上条 |
| memory 文件 > 15 个 | +7 | 取代上条 |
| memory 类型 ≥ 2 种 | +3 | 检查 frontmatter type |
| memory 类型 ≥ 4 种 | +5 | 取代上条 |

**其他 Agent 等效信号：**

| 信号 | 分值 | 适用 Agent |
|------|------|-----------|
| 有持久化上下文配置 | +5 | Cursor (notepads), Continue, WorkBuddy |
| 项目级指令文件跨多个项目 | +5 | Copilot, Cursor, Windsurf |
| .aider.chat.history 有持续对话 | +5 | Aider |
| 有 context providers 配置 | +5 | Continue |

### M5: 高级功能使用（满分 20）

**Claude Code：**

| 信号 | 分值 | 检测方式 |
|------|------|---------|
| 多项目配置（≥ 2） | +4 | ls ~/.claude/projects/ |
| 多项目配置（≥ 5） | +6 | 取代上条 |
| 有 cron/schedule 配置 | +4 | 检查相关配置 |
| 有 agent team 配置 | +4 | 检查 team 相关文件 |
| git 中有 AI 协作提交 | +3 | grep Co-Authored-By |
| AI 协作提交占比 > 30% | +3 | 计算比例 |

**多 Agent 加分（适用所有 Agent）：**

| 信号 | 分值 |
|------|------|
| 安装了 2 个 AI Agent | +3 |
| 安装了 3 个 AI Agent | +5 |
| 安装了 4+ 个 AI Agent | +8 |
| Agent 覆盖不同类型（IDE + CLI + 独立）| +4 |

---

## D 维度：蒸馏价值指数

### 自动检测信号（满分 70）

| 信号 | 子维度 | 分值 | 逻辑 |
|------|--------|------|------|
| 自建 skill / 自定义 agent 数量 | 知识可编码性 | 0-15 | Claude: 自建 skill; Codex: 自定义 agent; Cursor: 自定义 rules |
| 指令文件中有工作流定义 | 方法论独特性 | 0-10 | CLAUDE.md / .cursorrules / AGENTS.md 中有结构化工作流 |
| Skill/规则领域集中度 | 领域专精度 | 0-15 | 安装的 skill / 规则是否集中在 1-2 个领域 |
| 项目级配置深度 | 输出标准化度 | 0-10 | 项目级指令文件越详细 = 输出越标准化 |
| Git 提交持续性 | 领域专精度 | 0-10 | 长期稳定提交 = 深耕某领域 |
| Memory/上下文中的领域知识 | 方法论独特性 | 0-10 | memory / context 中记录了领域特定知识 |

### 角色推断信号（满分 30）

基于用户回答的"职业角色"和"核心产出"：

| 角色类型 | 领域专精度 | 方法论独特性 | 知识可编码性 | 输出标准化度 | 市场需求度 |
|----------|-----------|-------------|-------------|-------------|-----------|
| 技术开发 | 高 | 中 | 高 | 高 | 高 |
| 产品管理 | 中 | 中 | 中 | 低 | 高 |
| 设计 | 中 | 高 | 低 | 中 | 中 |
| 内容创作 | 中 | 高 | 中 | 中 | 高 |
| 运营/营销 | 中 | 中 | 高 | 高 | 高 |
| 管理/领导 | 低 | 中 | 低 | 低 | 中 |
| 咨询 | 高 | 高 | 中 | 低 | 高 |
| 研究/学术 | 高 | 高 | 低 | 低 | 中 |

每项映射为 0-6 分：低=2, 中=4, 高=6

---

## A 维度：抗蒸馏指数

### 自动检测信号（满分 40）

| 信号 | 子维度 | 分值 | 逻辑 |
|------|--------|------|------|
| Skill/工具类别覆盖广度 | 跨域综合力 | 0-15 | 覆盖类别越多 = 跨域能力越强（所有 Agent 合并） |
| 创意类工具占比 | 创造力 | 0-10 | 设计/内容/媒体类 skill 或扩展占比 |
| 社交/沟通类工具 | 情商/影响力 | 0-8 | 社交相关 skill/扩展/集成 |
| 安全/审计类工具 | 模糊决策力 | 0-7 | 需要判断力的工具 |

### 角色推断信号（满分 60）

| 角色类型 | 创造力 | 情商 | 跨域综合 | 模糊决策 | 身体在场 | 信任资产 |
|----------|--------|------|---------|---------|---------|---------|
| 技术开发 | 5 | 3 | 5 | 4 | 2 | 4 |
| 产品管理 | 6 | 8 | 8 | 8 | 3 | 7 |
| 设计 | 9 | 5 | 6 | 6 | 2 | 5 |
| 内容创作 | 8 | 5 | 7 | 5 | 2 | 7 |
| 运营/营销 | 5 | 7 | 7 | 6 | 4 | 6 |
| 管理/领导 | 5 | 9 | 7 | 9 | 6 | 9 |
| 咨询 | 6 | 8 | 9 | 8 | 5 | 9 |
| 研究/学术 | 8 | 4 | 8 | 7 | 3 | 6 |

每项为 0-10 分，乘以权重后归一化到 60 分满分。
权重：创造力×2, 情商×1.5, 跨域×1.5, 模糊决策×2, 身体×1, 信任×2

---

## C 维度：职业适配

C = f(D, A, M) + MBTI 调整

### 基础计算

```
C_base = (D + A + M) / 3
```

### MBTI 调整

MBTI 类型影响 C 维度的具体职业推荐方向，不直接影响分数。

| MBTI 维度 | 对 C 的影响 |
|-----------|-----------|
| E vs I | E 推荐更多协作/沟通型路径，I 推荐更多深度/独立型路径 |
| N vs S | N 推荐更多战略/创新型路径，S 推荐更多执行/优化型路径 |
| T vs F | T 推荐更多技术/分析型路径，F 推荐更多人文/关怀型路径 |
| J vs P | J 推荐更多管理/系统化路径，P 推荐更多探索/灵活型路径 |

---

## 整体评分

```
Overall = D × 0.25 + A × 0.30 + M × 0.25 + C × 0.20
```

A 维度权重最高（0.30），因为在 AI 时代，不可替代性是最核心的价值。

---

## 等级划分

| 分数段 | 等级 | 含义 |
|--------|------|------|
| 90-100 | S | AI 时代的超级个体 |
| 75-89 | A | 高价值 AI 协作者 |
| 60-74 | B | 有潜力，需要针对性提升 |
| 45-59 | C | 中等水平，有较大提升空间 |
| 30-44 | D | 需要警惕，尽快行动 |
| 0-29 | F | 紧急：需要重新定位 |
