# Upstream同期コマンド

フォーク元の最新変更を取り込み、japaneseディレクトリに反映する。

## 前提条件

- upstream リモートが設定されていること
- 設定されていない場合: `git remote add upstream https://github.com/affaan-m/everything-claude-code.git`

## 実行手順

### 1. upstreamの確認と設定

```bash
git remote -v
```

upstreamがない場合は追加:
```bash
git remote add upstream https://github.com/anthropics/everything-claude-code.git
```

### 2. upstream の最新を取得

```bash
git fetch upstream
```

### 3. 差分を確認

```bash
# 前回同期からの差分ファイル一覧
git diff --name-only HEAD upstream/main

# 差分の詳細
git diff HEAD upstream/main --stat
```

### 4. 差分の分析

変更されたファイルを以下のカテゴリに分類:

| カテゴリ | 対応 |
|---------|------|
| 新規ファイル | ルートに英語版追加 → japaneseに日本語版作成 |
| 更新ファイル | ルートを更新 → japaneseの対応箇所を更新 |
| 削除ファイル | ルートから削除 → japaneseからも削除 |
| コード変更のみ | 両方に同じ変更を適用（翻訳不要） |
| ドキュメント変更 | ルートは英語のまま → japaneseは日本語に翻訳 |

### 5. ルートディレクトリの更新

```bash
# upstreamの変更をマージ（japaneseディレクトリは除外）
git checkout upstream/main -- <変更されたファイル>
```

**注意**: japaneseディレクトリは上書きしない

### 6. japaneseディレクトリの更新

各変更ファイルについて:

1. **説明文・コメント**: 日本語に翻訳
2. **descriptionフィールド**: 日本語に翻訳
3. **コード例**: 英語のまま（変数名、関数名、構文）
4. **技術用語**: 英語のまま（必要に応じてカッコ内に補足）
5. **ファイル名・パス**: 英語のまま

### 7. 翻訳対象の判断基準

#### 日本語にすべきもの
- Markdownの説明文
- YAMLフロントマターのdescription
- JSONのdescriptionフィールド
- シェルスクリプトのコメント
- エラーメッセージ（ユーザー向け）

#### 英語のままにすべきもの
- ファイル名、ディレクトリ名
- コード内の変数名、関数名
- コマンド名（/tdd, /plan等）
- 技術用語（API, TDD, E2E等）
- URL、ファイルパス
- 設定キー名

### 8. 変更のコミット

```bash
git add .
git commit -m "sync: upstream の変更を反映 (YYYY-MM-DD)"
```

## 同期チェックリスト

- [ ] upstream リモートが設定されている
- [ ] upstream/main を fetch した
- [ ] 差分ファイルを確認した
- [ ] ルートディレクトリを更新した
- [ ] japaneseディレクトリに翻訳を反映した
- [ ] 新規ファイルは両方に追加した
- [ ] 削除ファイルは両方から削除した
- [ ] コミットメッセージに同期日付を記載した

## 自動化のヒント

差分ファイル一覧を取得してループ処理:
```bash
for file in $(git diff --name-only HEAD upstream/main); do
  echo "Processing: $file"
  # ルートを更新
  git checkout upstream/main -- "$file" 2>/dev/null || echo "New file: $file"
  # japaneseにコピー（翻訳は手動）
  if [[ -f "$file" ]]; then
    mkdir -p "japanese/$(dirname "$file")"
    cp "$file" "japanese/$file"
    echo "  -> Copied to japanese/$file (needs translation)"
  fi
done
```

## トラブルシューティング

### upstreamが見つからない
```bash
git remote add upstream https://github.com/affaan-m/everything-claude-code.git
```

### マージコンフリクト
```bash
# 手動で解決後
git add <解決したファイル>
git commit
```

### japaneseの翻訳が古い
このコマンドを実行して最新のupstreamと同期してください。
