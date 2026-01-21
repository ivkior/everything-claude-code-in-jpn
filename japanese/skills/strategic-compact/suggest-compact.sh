#!/bin/bash
# 戦略的コンパクト提案
# PreToolUseまたは定期的に実行され、論理的な間隔で手動コンパクションを提案
#
# 自動より手動コンパクトを推奨する理由:
# - 自動コンパクトは任意のタイミング（タスクの途中など）で発生する
# - 戦略的コンパクションは論理的なフェーズを通じてコンテキストを保持
# - 調査後、実行前にコンパクト
# - マイルストーン完了後、次の開始前にコンパクト
#
# フック設定 (~/.claude/settings.json内):
# {
#   "hooks": {
#     "PreToolUse": [{
#       "matcher": "Edit|Write",
#       "hooks": [{
#         "type": "command",
#         "command": "~/.claude/skills/strategic-compact/suggest-compact.sh"
#       }]
#     }]
#   }
# }
#
# コンパクト提案の基準:
# - セッションが長時間実行されている
# - 多数のツール呼び出しが行われた
# - 調査/探索から実装への移行
# - 計画が確定した

# ツール呼び出し回数を追跡（一時ファイルでインクリメント）
COUNTER_FILE="/tmp/claude-tool-count-$$"
THRESHOLD=${COMPACT_THRESHOLD:-50}

# カウンターを初期化またはインクリメント
if [ -f "$COUNTER_FILE" ]; then
  count=$(cat "$COUNTER_FILE")
  count=$((count + 1))
  echo "$count" > "$COUNTER_FILE"
else
  echo "1" > "$COUNTER_FILE"
  count=1
fi

# 閾値のツール呼び出し後にコンパクトを提案
if [ "$count" -eq "$THRESHOLD" ]; then
  echo "[StrategicCompact] $THRESHOLD 回のツール呼び出しに到達 - フェーズ移行時は /compact を検討してください" >&2
fi

# 閾値後は定期的な間隔で提案
if [ "$count" -gt "$THRESHOLD" ] && [ $((count % 25)) -eq 0 ]; then
  echo "[StrategicCompact] $count 回のツール呼び出し - コンテキストが古くなった場合は /compact の良いチェックポイントです" >&2
fi
