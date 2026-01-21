# Everything Claude Code

**Anthropicハッカソン優勝者によるClaude Code設定の完全コレクション**

このリポジトリには、Claude Codeで日常的に使用している本番運用レベルのagent、skill、hook、command、rule、MCP設定が含まれています。これらの設定は、実際のプロダクト開発で10ヶ月以上かけて進化してきたものです。

---

## まず完全ガイドを読む

**これらの設定を使う前に、Xの完全ガイドを読んでください：**


<img width="592" height="445" alt="image" src="https://github.com/user-attachments/assets/1a471488-59cc-425b-8345-5245c7efbcef" />


**[The Shorthand Guide to Everything Claude Code](https://x.com/affaanmustafa/status/2012378465664745795)**



ガイドの内容：
- 各設定タイプの役割と使用タイミング
- Claude Codeセットアップの構成方法
- コンテキストウィンドウ管理（パフォーマンスに重要）
- 並列ワークフローと高度なテクニック
- これらの設定の背後にある思想

**このリポジトリは設定ファイルのみです！ヒント、コツ、その他の例はXの記事や動画にあります（リンクはこのREADMEに随時追加されます）。**

---

## 収録内容

```
everything-claude-code/
|-- agents/           # 委譲用の専門サブエージェント
|   |-- planner.md           # 機能実装の計画
|   |-- architect.md         # システム設計の意思決定
|   |-- tdd-guide.md         # テスト駆動開発
|   |-- code-reviewer.md     # 品質とセキュリティレビュー
|   |-- security-reviewer.md # 脆弱性分析
|   |-- build-error-resolver.md
|   |-- e2e-runner.md        # Playwright E2Eテスト
|   |-- refactor-cleaner.md  # 不要コードの削除
|   |-- doc-updater.md       # ドキュメント同期
|
|-- skills/           # ワークフロー定義とドメイン知識
|   |-- coding-standards.md         # 言語のベストプラクティス
|   |-- backend-patterns.md         # API、データベース、キャッシュパターン
|   |-- frontend-patterns.md        # React、Next.jsパターン
|   |-- project-guidelines-example.md # プロジェクト固有スキルの例
|   |-- tdd-workflow/               # TDD方法論
|   |-- security-review/            # セキュリティチェックリスト
|   |-- clickhouse-io.md            # ClickHouse分析
|
|-- commands/         # クイック実行用のスラッシュコマンド
|   |-- tdd.md              # /tdd - テスト駆動開発
|   |-- plan.md             # /plan - 実装計画
|   |-- e2e.md              # /e2e - E2Eテスト生成
|   |-- code-review.md      # /code-review - 品質レビュー
|   |-- build-fix.md        # /build-fix - ビルドエラー修正
|   |-- refactor-clean.md   # /refactor-clean - 不要コード削除
|   |-- test-coverage.md    # /test-coverage - カバレッジ分析
|   |-- update-codemaps.md  # /update-codemaps - ドキュメント更新
|   |-- update-docs.md      # /update-docs - ドキュメント同期
|
|-- rules/            # 常に従うべきガイドライン
|   |-- security.md         # 必須セキュリティチェック
|   |-- coding-style.md     # 不変性、ファイル構成
|   |-- testing.md          # TDD、80%カバレッジ要件
|   |-- git-workflow.md     # コミット形式、PRプロセス
|   |-- agents.md           # サブエージェントへの委譲タイミング
|   |-- performance.md      # モデル選択、コンテキスト管理
|   |-- patterns.md         # APIレスポンス形式、フック
|   |-- hooks.md            # フックのドキュメント
|
|-- hooks/            # トリガーベースの自動化
|   |-- hooks.json          # PreToolUse、PostToolUse、Stopフック
|
|-- mcp-configs/      # MCPサーバー設定
|   |-- mcp-servers.json    # GitHub、Supabase、Vercel、Railway等
|
|-- plugins/          # プラグインエコシステムのドキュメント
|   |-- README.md           # プラグイン、マーケットプレイス、スキルガイド
|
|-- examples/         # 設定例
    |-- CLAUDE.md           # プロジェクトレベル設定の例
    |-- user-CLAUDE.md      # ユーザーレベル設定の例（~/.claude/CLAUDE.md）
    |-- statusline.json     # カスタムステータスライン設定
```

---

## クイックスタート

### 1. 必要なものをコピー

```bash
# リポジトリをクローン
git clone https://github.com/affaan-m/everything-claude-code.git

# agentをClaude設定にコピー
cp everything-claude-code/agents/*.md ~/.claude/agents/

# ruleをコピー
cp everything-claude-code/rules/*.md ~/.claude/rules/

# commandをコピー
cp everything-claude-code/commands/*.md ~/.claude/commands/

# skillをコピー
cp -r everything-claude-code/skills/* ~/.claude/skills/
```

### 2. hookをsettings.jsonに追加

`hooks/hooks.json`のhookを`~/.claude/settings.json`にコピーします。

### 3. MCPを設定

`mcp-configs/mcp-servers.json`から必要なMCPサーバーを`~/.claude.json`にコピーします。

**重要：** `YOUR_*_HERE`プレースホルダーを実際のAPIキーに置き換えてください。

### 4. ガイドを読む

本当に、[ガイドを読んでください](https://x.com/affaanmustafa/status/2012378465664745795)。コンテキストがあれば、これらの設定が10倍理解しやすくなります。

---

## 主要コンセプト

### Agent

サブエージェントは限定されたスコープで委譲されたタスクを処理します。例：

```markdown
---
name: code-reviewer
description: コードの品質、セキュリティ、保守性をレビュー
tools: Read, Grep, Glob, Bash
model: opus
---

あなたはシニアコードレビュアーです...
```

### Skill

skillはcommandやagentから呼び出されるワークフロー定義です：

```markdown
# TDD Workflow

1. まずインターフェースを定義
2. 失敗するテストを書く（RED）
3. 最小限のコードを実装（GREEN）
4. リファクタリング（IMPROVE）
5. 80%以上のカバレッジを確認
```

### Hook

hookはツールイベントで発火します。例 - console.logの警告：

```json
{
  "matcher": "tool == \"Edit\" && tool_input.file_path matches \"\\\\.(ts|tsx|js|jsx)$\"",
  "hooks": [{
    "type": "command",
    "command": "#!/bin/bash\ngrep -n 'console\\.log' \"$file_path\" && echo '[Hook] Remove console.log' >&2"
  }]
}
```

### Rule

ruleは常に従うべきガイドラインです。モジュール化して管理：

```
~/.claude/rules/
  security.md      # ハードコードされた秘密情報の禁止
  coding-style.md  # 不変性、ファイル制限
  testing.md       # TDD、カバレッジ要件
```

---

## 貢献

**貢献を歓迎します。**

このリポジトリはコミュニティリソースを目指しています。以下をお持ちであれば：
- 便利なagentやskill
- 巧みなhook
- より良いMCP設定
- 改善されたrule

ぜひ貢献してください！ガイドラインは[CONTRIBUTING.md](CONTRIBUTING.md)を参照してください。

### 貢献のアイデア

- 言語固有のskill（Python、Go、Rustパターン）
- フレームワーク固有の設定（Django、Rails、Laravel）
- DevOps agent（Kubernetes、Terraform、AWS）
- テスト戦略（各種フレームワーク）
- ドメイン固有の知識（ML、データエンジニアリング、モバイル）

---

## 背景

Claude Codeの実験的ロールアウト以来使用しています。2025年9月のAnthropic x Forum Venturesハッカソンで[@DRodriguezFX](https://x.com/DRodriguezFX)と[zenith.chat](https://zenith.chat)を構築して優勝 - 完全にClaude Codeのみで開発しました。

これらの設定は複数の本番アプリケーションで実戦テスト済みです。

---

## 重要な注意事項

### コンテキストウィンドウ管理

**重要：** すべてのMCPを一度に有効にしないでください。有効化するツールが多すぎると、200kのコンテキストウィンドウが70kまで縮小する可能性があります。

目安：
- 20-30個のMCPを設定
- プロジェクトごとに10個以下を有効化
- アクティブなツールは80個以下

未使用のMCPはプロジェクト設定の`disabledMcpServers`で無効化してください。

### カスタマイズ

これらの設定は私のワークフロー向けです。あなたは：
1. 共感できるものから始める
2. 自分のスタックに合わせて修正
3. 使わないものは削除
4. 独自のパターンを追加

---

## リンク

- **完全ガイド：** [The Shorthand Guide to Everything Claude Code](https://x.com/affaanmustafa/status/2012378465664745795)
- **フォロー：** [@affaanmustafa](https://x.com/affaanmustafa)
- **zenith.chat：** [zenith.chat](https://zenith.chat)

---

## ライセンス

MIT - 自由に使用、必要に応じて修正、可能であれば貢献をお願いします。

---

**このリポジトリが役立ったらスターを。ガイドを読んで。素晴らしいものを作ろう。**
