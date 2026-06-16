#!/usr/bin/env bash
# Agent Atlas Skill Uninstaller — multi-agent support

set -euo pipefail

echo ""
echo "  [*] 正在卸载 Agent Atlas skill..."

REMOVED=0

for dir in \
  "$HOME/.claude/skills/agent-atlas" \
  "$HOME/.codex/skills/agent-atlas" \
  "$HOME/.cursor/skills/agent-atlas" \
  "$HOME/.codeium/windsurf/skills/agent-atlas" \
  "$HOME/.continue/skills/agent-atlas" \
  "$HOME/.aider/skills/agent-atlas" \
  "$HOME/.workbuddy/skills/agent-atlas" \
  "$HOME/.trae/skills/agent-atlas" \
  "$HOME/.lingma/skills/agent-atlas" \
  "$HOME/.marscode/skills/agent-atlas" \
  "$HOME/.codegeex/skills/agent-atlas" \
  "$HOME/.comate/skills/agent-atlas" \
  "$HOME/.chat/skills/agent-atlas"; do
  if [ -d "$dir" ]; then
    rm -rf "$dir"
    echo "  [OK] 已移除: $dir"
    REMOVED=$((REMOVED + 1))
  fi
done

if [ "$REMOVED" -eq 0 ]; then
  echo "  [*] 未找到 Agent Atlas skill 安装"
else
  echo ""
  echo "  [OK] 已从 $REMOVED 个 Agent 中卸载"
fi
echo ""
