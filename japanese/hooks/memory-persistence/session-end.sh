#!/bin/bash
# Stopフック（セッション終了） - セッション終了時に学習を永続化
#
# Claudeセッションが終了したときに実行されます。
# 継続性追跡のためタイムスタンプ付きでセッションログファイルを作成/更新します。
#
# フック設定 (~/.claude/settings.json内):
# {
#   "hooks": {
#     "Stop": [{
#       "matcher": "*",
#       "hooks": [{
#         "type": "command",
#         "command": "~/.claude/hooks/memory-persistence/session-end.sh"
#       }]
#     }]
#   }
# }

SESSIONS_DIR="${HOME}/.claude/sessions"
TODAY=$(date '+%Y-%m-%d')
SESSION_FILE="${SESSIONS_DIR}/${TODAY}-session.tmp"

mkdir -p "$SESSIONS_DIR"

# 今日のセッションファイルが存在する場合、終了時刻を更新
if [ -f "$SESSION_FILE" ]; then
  # 最終更新タイムスタンプを更新
  sed -i '' "s/\*\*最終更新:\*\*.*/\*\*最終更新:\*\* $(date '+%H:%M')/" "$SESSION_FILE" 2>/dev/null || \
  sed -i "s/\*\*最終更新:\*\*.*/\*\*最終更新:\*\* $(date '+%H:%M')/" "$SESSION_FILE" 2>/dev/null
  echo "[SessionEnd] セッションファイルを更新: $SESSION_FILE" >&2
else
  # テンプレート付きで新しいセッションファイルを作成
  cat > "$SESSION_FILE" << EOF
# セッション: $(date '+%Y-%m-%d')
**日付:** $TODAY
**開始:** $(date '+%H:%M')
**最終更新:** $(date '+%H:%M')

---

## 現在の状態

[セッションコンテキストをここに記載]

### 完了
- [ ]

### 進行中
- [ ]

### 次回セッションへのメモ
-

### 読み込むコンテキスト
\`\`\`
[関連ファイル]
\`\`\`
EOF
  echo "[SessionEnd] セッションファイルを作成: $SESSION_FILE" >&2
fi
