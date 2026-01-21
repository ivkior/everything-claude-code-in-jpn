#!/bin/bash
# PreCompactフック - コンテキストコンパクション前に状態を保存
#
# Claudeがコンテキストをコンパクトする前に実行され、
# 要約で失われる可能性のある重要な状態を保存する機会を提供します。
#
# フック設定 (~/.claude/settings.json内):
# {
#   "hooks": {
#     "PreCompact": [{
#       "matcher": "*",
#       "hooks": [{
#         "type": "command",
#         "command": "~/.claude/hooks/memory-persistence/pre-compact.sh"
#       }]
#     }]
#   }
# }

SESSIONS_DIR="${HOME}/.claude/sessions"
COMPACTION_LOG="${SESSIONS_DIR}/compaction-log.txt"

mkdir -p "$SESSIONS_DIR"

# タイムスタンプ付きでコンパクションイベントをログ
echo "[$(date '+%Y-%m-%d %H:%M:%S')] コンテキストコンパクションがトリガーされました" >> "$COMPACTION_LOG"

# アクティブなセッションファイルがある場合、コンパクションを記録
ACTIVE_SESSION=$(ls -t "$SESSIONS_DIR"/*.tmp 2>/dev/null | head -1)
if [ -n "$ACTIVE_SESSION" ]; then
  echo "" >> "$ACTIVE_SESSION"
  echo "---" >> "$ACTIVE_SESSION"
  echo "**[$(date '+%H:%M')にコンパクション発生]** - コンテキストが要約されました" >> "$ACTIVE_SESSION"
fi

echo "[PreCompact] コンパクション前に状態を保存しました" >&2
