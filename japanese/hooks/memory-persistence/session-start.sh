#!/bin/bash
# SessionStartフック - 新規セッションで前回のコンテキストを読み込み
#
# 新しいClaudeセッションが開始されたときに実行されます。
# 最近のセッションファイルを確認し、読み込み可能なコンテキストをClaudeに通知します。
#
# フック設定 (~/.claude/settings.json内):
# {
#   "hooks": {
#     "SessionStart": [{
#       "matcher": "*",
#       "hooks": [{
#         "type": "command",
#         "command": "~/.claude/hooks/memory-persistence/session-start.sh"
#       }]
#     }]
#   }
# }

SESSIONS_DIR="${HOME}/.claude/sessions"
LEARNED_DIR="${HOME}/.claude/skills/learned"

# 最近のセッションファイルを確認（過去7日間）
recent_sessions=$(find "$SESSIONS_DIR" -name "*.tmp" -mtime -7 2>/dev/null | wc -l | tr -d ' ')

if [ "$recent_sessions" -gt 0 ]; then
  latest=$(ls -t "$SESSIONS_DIR"/*.tmp 2>/dev/null | head -1)
  echo "[SessionStart] 最近のセッションが $recent_sessions 件見つかりました" >&2
  echo "[SessionStart] 最新: $latest" >&2
fi

# 学習済みスキルを確認
learned_count=$(find "$LEARNED_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

if [ "$learned_count" -gt 0 ]; then
  echo "[SessionStart] $learned_count 件の学習済みスキルが $LEARNED_DIR で利用可能" >&2
fi
