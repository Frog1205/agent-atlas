#!/usr/bin/env bash
# Agent Atlas Skill Installer — multi-agent support, fully self-hosted
# Usage: curl -fsSL https://raw.githubusercontent.com/Frog1205/agent-atlas/main/install.sh | bash

set -euo pipefail

REPO_URL="https://github.com/Frog1205/agent-atlas.git"
SKILL_NAME="agent-atlas"
TEMP_DIR=$(mktemp -d)

cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║  Agent Atlas — AI Agent 水平评测器   ║"
echo "  ║  Self-hosted edition                 ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

if ! command -v git &>/dev/null; then
  echo "  [!] 需要 git，请先安装"; exit 1
fi
if ! command -v gh &>/dev/null; then
  echo "  [!] 建议安装 GitHub CLI (gh) 以启用在线报告功能"
fi

AGENTS_FOUND=0
INSTALL_TARGETS=""

echo "  [*] 检测 AI Agent 环境..."
echo ""

declare -a CHECKS=(
  "claude:$HOME/.claude:Claude Code"
  "codex:$HOME/.codex:OpenAI Codex"
  "cursor:$HOME/.cursor:Cursor"
  "windsurf:$HOME/.codeium/windsurf:Windsurf"
  "continue:$HOME/.continue:Continue"
  "workbuddy:$HOME/.workbuddy:WorkBuddy"
  "trae:$HOME/.trae:Trae"
  "lingma:$HOME/.lingma:通义灵码"
  "marscode:$HOME/.marscode:MarsCode"
  "codegeex:$HOME/.codegeex:CodeGeeX"
  "comate:$HOME/.comate:Comate"
  "devchat:$HOME/.chat:DevChat"
)

for entry in "${CHECKS[@]}"; do
  IFS=':' read -r key path label <<< "$entry"
  if [ -d "$path" ]; then
    echo "  ✓ $label  ($path)"
    AGENTS_FOUND=$((AGENTS_FOUND + 1))
    INSTALL_TARGETS="$INSTALL_TARGETS $key"
  fi
done

if [ -f "$HOME/.aider.conf.yml" ] || command -v aider &>/dev/null 2>&1; then
  echo "  ✓ Aider"
  AGENTS_FOUND=$((AGENTS_FOUND + 1))
  INSTALL_TARGETS="$INSTALL_TARGETS aider"
fi

echo ""

if [ "$AGENTS_FOUND" -eq 0 ]; then
  echo "  [!] 未检测到任何 AI Agent 环境"
  exit 1
fi

echo "  [*] 检测到 $AGENTS_FOUND 个 AI Agent，下载中..."
git clone --quiet --depth 1 "$REPO_URL" "$TEMP_DIR/src"

install_skill() {
  local target_dir="$1" agent_name="$2"
  mkdir -p "$target_dir/references" "$target_dir/templates"
  cp "$TEMP_DIR/src/SKILL.md" "$target_dir/"
  cp "$TEMP_DIR/src/references/"* "$target_dir/references/" 2>/dev/null || true
  cp "$TEMP_DIR/src/templates/"* "$target_dir/templates/" 2>/dev/null || true
  echo "  [OK] $agent_name → $target_dir"
}

for agent in $INSTALL_TARGETS; do
  case "$agent" in
    claude)   mkdir -p "$HOME/.claude/skills";           install_skill "$HOME/.claude/skills/$SKILL_NAME" "Claude Code" ;;
    codex)    mkdir -p "$HOME/.codex/skills";            install_skill "$HOME/.codex/skills/$SKILL_NAME" "Codex" ;;
    cursor)   mkdir -p "$HOME/.cursor/skills";           install_skill "$HOME/.cursor/skills/$SKILL_NAME" "Cursor" ;;
    windsurf) mkdir -p "$HOME/.codeium/windsurf/skills"; install_skill "$HOME/.codeium/windsurf/skills/$SKILL_NAME" "Windsurf" ;;
    continue) mkdir -p "$HOME/.continue/skills";         install_skill "$HOME/.continue/skills/$SKILL_NAME" "Continue" ;;
    aider)    mkdir -p "$HOME/.aider/skills";            install_skill "$HOME/.aider/skills/$SKILL_NAME" "Aider" ;;
    workbuddy)mkdir -p "$HOME/.workbuddy/skills";        install_skill "$HOME/.workbuddy/skills/$SKILL_NAME" "WorkBuddy" ;;
    trae)     mkdir -p "$HOME/.trae/skills";             install_skill "$HOME/.trae/skills/$SKILL_NAME" "Trae" ;;
    lingma)   mkdir -p "$HOME/.lingma/skills";           install_skill "$HOME/.lingma/skills/$SKILL_NAME" "通义灵码" ;;
    marscode) mkdir -p "$HOME/.marscode/skills";         install_skill "$HOME/.marscode/skills/$SKILL_NAME" "MarsCode" ;;
    codegeex) mkdir -p "$HOME/.codegeex/skills";         install_skill "$HOME/.codegeex/skills/$SKILL_NAME" "CodeGeeX" ;;
    comate)   mkdir -p "$HOME/.comate/skills";           install_skill "$HOME/.comate/skills/$SKILL_NAME" "Comate" ;;
    devchat)  mkdir -p "$HOME/.chat/skills";             install_skill "$HOME/.chat/skills/$SKILL_NAME" "DevChat" ;;
  esac
done

echo ""
echo "  ════════════════════════════════════════"
echo "  Agent Atlas 安装成功! ($AGENTS_FOUND 个 Agent)"
echo "  ════════════════════════════════════════"
echo ""
echo "  使用方法: 跟你的 Agent 说「评估下我的 Agent 水平」"
echo "  报告路径: ~/Desktop/AgentAtlas-Report-{日期}.html"
echo "  在线 URL: 推到你自己的 GitHub Pages (首次会引导配置)"
echo ""
