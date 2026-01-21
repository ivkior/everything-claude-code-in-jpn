#!/bin/bash
# 継続学習 - セッション評価スクリプト
# Stopフックで実行され、Claude Codeセッションから再利用可能なパターンを抽出
#
# UserPromptSubmitではなくStopフックを使用する理由:
# - Stopはセッション終了時に1回だけ実行（軽量）
# - UserPromptSubmitは毎メッセージ実行（重く、レイテンシが増加）
#
# フック設定 (~/.claude/settings.json内):
# {
#   "hooks": {
#     "Stop": [{
#       "matcher": "*",
#       "hooks": [{
#         "type": "command",
#         "command": "~/.claude/skills/continuous-learning/evaluate-session.sh"
#       }]
#     }]
#   }
# }
#
# 検出するパターン: error_resolution, debugging_techniques, workarounds, project_specific
# 無視するパターン: simple_typos, one_time_fixes, external_api_issues
# 抽出されたスキルの保存先: ~/.claude/skills/learned/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config.json"
LEARNED_SKILLS_PATH="${HOME}/.claude/skills/learned"
MIN_SESSION_LENGTH=10

# 設定ファイルが存在すれば読み込み
if [ -f "$CONFIG_FILE" ]; then
  MIN_SESSION_LENGTH=$(jq -r '.min_session_length // 10' "$CONFIG_FILE")
  LEARNED_SKILLS_PATH=$(jq -r '.learned_skills_path // "~/.claude/skills/learned/"' "$CONFIG_FILE" | sed "s|~|$HOME|")
fi

# 学習済みスキルディレクトリを確保
mkdir -p "$LEARNED_SKILLS_PATH"

# 環境変数からトランスクリプトパスを取得（Claude Codeが設定）
transcript_path="${CLAUDE_TRANSCRIPT_PATH:-}"

if [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then
  exit 0
fi

# セッション内のメッセージ数をカウント
message_count=$(grep -c '"type":"user"' "$transcript_path" 2>/dev/null || echo "0")

# 短いセッションはスキップ
if [ "$message_count" -lt "$MIN_SESSION_LENGTH" ]; then
  echo "[ContinuousLearning] セッションが短すぎます（${message_count}メッセージ）、スキップ" >&2
  exit 0
fi

# 抽出可能なパターンの評価が必要なことをClaudeに通知
echo "[ContinuousLearning] セッションに${message_count}メッセージあり - 抽出可能なパターンを評価" >&2
echo "[ContinuousLearning] 学習済みスキルの保存先: $LEARNED_SKILLS_PATH" >&2
