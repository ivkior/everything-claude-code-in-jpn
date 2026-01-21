# Everything Claude Codeへの貢献

貢献に興味を持っていただきありがとうございます。このリポジトリはClaude Codeユーザーのためのコミュニティリソースを目指しています。

## 求めているもの

### Agent

特定のタスクをうまく処理する新しいagent：
- 言語固有のレビュアー（Python、Go、Rust）
- フレームワークエキスパート（Django、Rails、Laravel、Spring）
- DevOpsスペシャリスト（Kubernetes、Terraform、CI/CD）
- ドメインエキスパート（MLパイプライン、データエンジニアリング、モバイル）

### Skill

ワークフロー定義とドメイン知識：
- 言語のベストプラクティス
- フレームワークパターン
- テスト戦略
- アーキテクチャガイド
- ドメイン固有の知識

### Command

便利なワークフローを呼び出すスラッシュコマンド：
- デプロイメントコマンド
- テストコマンド
- ドキュメントコマンド
- コード生成コマンド

### Hook

便利な自動化：
- Lint/フォーマットhook
- セキュリティチェック
- バリデーションhook
- 通知hook

### Rule

常に従うべきガイドライン：
- セキュリティルール
- コードスタイルルール
- テスト要件
- 命名規則

### MCP設定

新規または改善されたMCPサーバー設定：
- データベース統合
- クラウドプロバイダーMCP
- 監視ツール
- コミュニケーションツール

---

## 貢献方法

### 1. リポジトリをフォーク

```bash
git clone https://github.com/YOUR_USERNAME/everything-claude-code.git
cd everything-claude-code
```

### 2. ブランチを作成

```bash
git checkout -b add-python-reviewer
```

### 3. 貢献を追加

ファイルを適切なディレクトリに配置：
- `agents/` - 新しいagent
- `skills/` - skill（単一の.mdまたはディレクトリ）
- `commands/` - スラッシュコマンド
- `rules/` - ruleファイル
- `hooks/` - hook設定
- `mcp-configs/` - MCPサーバー設定

### 4. フォーマットに従う

**Agent**にはfrontmatterが必要：

```markdown
---
name: agent-name
description: 何をするか
tools: Read, Grep, Glob, Bash
model: sonnet
---

ここに指示を書く...
```

**Skill**は明確で実行可能に：

```markdown
# スキル名

## 使用タイミング

...

## 動作方法

...

## 例

...
```

**Command**は何をするか説明：

```markdown
---
description: コマンドの簡潔な説明
---

# コマンド名

詳細な指示...
```

**Hook**には説明を含める：

```json
{
  "matcher": "...",
  "hooks": [...],
  "description": "このhookが何をするか"
}
```

### 5. 貢献をテスト

提出前にClaude Codeで設定が動作することを確認してください。

### 6. PRを提出

```bash
git add .
git commit -m "Add Python code reviewer agent"
git push origin add-python-reviewer
```

PRを開く際に以下を記載：
- 何を追加したか
- なぜ有用か
- どのようにテストしたか

---

## ガイドライン

### すべきこと

- 設定を集中的かつモジュール化
- 明確な説明を含める
- 提出前にテスト
- 既存のパターンに従う
- 依存関係をドキュメント化

### すべきでないこと

- 機密データを含める（APIキー、トークン、パス）
- 過度に複雑またはニッチな設定を追加
- テストされていない設定を提出
- 重複した機能を作成
- 代替手段なしに特定の有料サービスを必要とする設定を追加

---

## ファイル命名

- 小文字とハイフンを使用：`python-reviewer.md`
- 説明的に：`tdd-workflow.md`（`workflow.md`ではなく）
- agent/skill名をファイル名と一致させる

---

## 質問？

issueを開くか、Xで連絡してください：[@affaanmustafa](https://x.com/affaanmustafa)

---

貢献に感謝します。一緒に素晴らしいリソースを作りましょう。
