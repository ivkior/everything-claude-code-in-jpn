# コーディングスタイル

## 不変性（CRITICAL）

常に新しいオブジェクトを作成、絶対にミューテーションしない：

```javascript
// 悪い例: ミューテーション
function updateUser(user, name) {
  user.name = name  // ミューテーション！
  return user
}

// 良い例: 不変性
function updateUser(user, name) {
  return {
    ...user,
    name
  }
}
```

## ファイル構成

多くの小さなファイル > 少数の大きなファイル：
- 高凝集、低結合
- 通常200-400行、最大800行
- 大きなコンポーネントからユーティリティを抽出
- 型別ではなく機能/ドメイン別に整理

## エラーハンドリング

常に包括的にエラーを処理：

```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  console.error('Operation failed:', error)
  throw new Error('詳細でユーザーフレンドリーなメッセージ')
}
```

## 入力バリデーション

常にユーザー入力を検証：

```typescript
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150)
})

const validated = schema.parse(input)
```

## コード品質チェックリスト

作業完了前に確認：
- [ ] コードが読みやすく、適切な命名
- [ ] 関数が小さい（50行未満）
- [ ] ファイルが集中している（800行未満）
- [ ] 深いネストがない（4レベル以上）
- [ ] 適切なエラーハンドリング
- [ ] console.log文がない
- [ ] ハードコードされた値がない
- [ ] ミューテーションがない（不変パターンを使用）
