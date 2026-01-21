# プラグインとマーケットプレイス

プラグインはClaude Codeに新しいツールと機能を追加します。このガイドはインストール方法のみを扱います - 使用タイミングと理由については[完全記事](https://x.com/affaanmustafa/status/2012378465664745795)を参照してください。

---

## マーケットプレイス

マーケットプレイスはインストール可能なプラグインのリポジトリです。

### マーケットプレイスの追加

```bash
# 公式Anthropicマーケットプレイスを追加
claude plugin marketplace add https://github.com/anthropics/claude-plugins-official

# コミュニティマーケットプレイスを追加
claude plugin marketplace add https://github.com/mixedbread-ai/mgrep
```

### 推奨マーケットプレイス

| マーケットプレイス | ソース |
|-------------|--------|
| claude-plugins-official | `anthropics/claude-plugins-official` |
| claude-code-plugins | `anthropics/claude-code` |
| Mixedbread-Grep | `mixedbread-ai/mgrep` |

---

## プラグインのインストール

```bash
# プラグインブラウザを開く
/plugins

# または直接インストール
claude plugin install typescript-lsp@claude-plugins-official
```

### 推奨プラグイン

**開発：**
- `typescript-lsp` - TypeScriptインテリジェンス
- `pyright-lsp` - Python型チェック
- `hookify` - 会話形式でhookを作成
- `code-simplifier` - コードのリファクタリング

**コード品質：**
- `code-review` - コードレビュー
- `pr-review-toolkit` - PR自動化
- `security-guidance` - セキュリティチェック

**検索：**
- `mgrep` - 強化された検索（ripgrepより優秀）
- `context7` - ライブドキュメント検索

**ワークフロー：**
- `commit-commands` - Gitワークフロー
- `frontend-design` - UIパターン
- `feature-dev` - 機能開発

---

## クイックセットアップ

```bash
# マーケットプレイスを追加
claude plugin marketplace add https://github.com/anthropics/claude-plugins-official
claude plugin marketplace add https://github.com/mixedbread-ai/mgrep

# /pluginsを開いて必要なものをインストール
```

---

## プラグインファイルの場所

```
~/.claude/plugins/
|-- cache/                    # ダウンロードされたプラグイン
|-- installed_plugins.json    # インストール済みリスト
|-- known_marketplaces.json   # 追加済みマーケットプレイス
|-- marketplaces/             # マーケットプレイスデータ
```
