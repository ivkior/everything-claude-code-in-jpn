# プロジェクト CLAUDE.md の例

これはプロジェクトレベルのCLAUDE.mdファイルの例です。プロジェクトルートに配置してください。

## プロジェクト概要

[プロジェクトの簡単な説明 - 何をするか、技術スタック]

## 重要なルール

### 1. コード構成

- 少数の大きなファイルより多数の小さなファイル
- 高凝集、低結合
- 通常200-400行、ファイルあたり最大800行
- タイプ別ではなく機能/ドメイン別に整理

### 2. コードスタイル

- コード、コメント、ドキュメントに絵文字禁止
- 常に不変性 - オブジェクトや配列を直接変更しない
- 本番コードにconsole.log禁止
- try/catchで適切なエラーハンドリング
- Zodなどで入力バリデーション

### 3. テスト

- TDD: テストを先に書く
- 最低80%カバレッジ
- ユーティリティにユニットテスト
- APIに統合テスト
- 重要なフローにE2Eテスト

### 4. セキュリティ

- ハードコードされたシークレット禁止
- 機密データは環境変数で
- すべてのユーザー入力をバリデート
- パラメータ化クエリのみ
- CSRF保護を有効化

## ファイル構造

```
src/
|-- app/              # Next.js app router
|-- components/       # 再利用可能なUIコンポーネント
|-- hooks/            # カスタムReactフック
|-- lib/              # ユーティリティライブラリ
|-- types/            # TypeScript定義
```

## 主要パターン

### APIレスポンス形式

```typescript
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
}
```

### エラーハンドリング

```typescript
try {
  const result = await operation()
  return { success: true, data: result }
} catch (error) {
  console.error('Operation failed:', error)
  return { success: false, error: 'ユーザー向けメッセージ' }
}
```

## 環境変数

```bash
# 必須
DATABASE_URL=
API_KEY=

# オプション
DEBUG=false
```

## 利用可能なコマンド

- `/tdd` - テスト駆動開発ワークフロー
- `/plan` - 実装計画を作成
- `/code-review` - コード品質をレビュー
- `/build-fix` - ビルドエラーを修正

## Gitワークフロー

- Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`
- mainに直接コミット禁止
- PRにはレビューが必要
- マージ前にすべてのテストをパス
