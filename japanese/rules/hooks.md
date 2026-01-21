# Hookシステム

## Hookタイプ

- **PreToolUse**: ツール実行前（バリデーション、パラメータ変更）
- **PostToolUse**: ツール実行後（自動フォーマット、チェック）
- **Stop**: セッション終了時（最終検証）

## 現在のHook（~/.claude/settings.json内）

### PreToolUse
- **tmux reminder**: 長時間実行コマンド（npm, pnpm, yarn, cargo等）にtmuxを提案
- **git push review**: プッシュ前にZedでレビューを開く
- **doc blocker**: 不要な.md/.txtファイルの作成をブロック

### PostToolUse
- **PR creation**: PR URLとGitHub Actionsステータスをログ
- **Prettier**: 編集後にJS/TSファイルを自動フォーマット
- **TypeScript check**: .ts/.tsxファイル編集後にtscを実行
- **console.log warning**: 編集ファイル内のconsole.logを警告

### Stop
- **console.log audit**: セッション終了前に変更ファイル全体のconsole.logをチェック

## 自動承認パーミッション

注意して使用：
- 信頼できる、明確に定義されたプランには有効化
- 探索的な作業には無効化
- dangerously-skip-permissionsフラグは絶対に使用しない
- 代わりに`~/.claude.json`の`allowedTools`を設定

## TodoWriteのベストプラクティス

TodoWriteツールの使用目的：
- 複数ステップタスクの進捗追跡
- 指示の理解を確認
- リアルタイムの軌道修正を可能に
- 詳細な実装ステップを表示

Todoリストで明らかになること：
- 順序が間違っているステップ
- 欠落している項目
- 不要な追加項目
- 間違った粒度
- 誤解された要件
