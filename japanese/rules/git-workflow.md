# Gitワークフロー

## コミットメッセージ形式

```
<type>: <description>

<optional body>
```

type: feat, fix, refactor, docs, test, chore, perf, ci

注: 帰属表示は~/.claude/settings.jsonでグローバルに無効化されています。

## プルリクエストワークフロー

PR作成時：
1. 完全なコミット履歴を分析（最新コミットだけでなく）
2. `git diff [base-branch]...HEAD`で全変更を確認
3. 包括的なPRサマリーを作成
4. TODOを含むテストプランを含める
5. 新規ブランチの場合は`-u`フラグでプッシュ

## 機能実装ワークフロー

1. **まず計画**
   - **planner**エージェントで実装計画を作成
   - 依存関係とリスクを特定
   - フェーズに分割

2. **TDDアプローチ**
   - **tdd-guide**エージェントを使用
   - まずテストを書く（RED）
   - テストをパスするよう実装（GREEN）
   - リファクタリング（IMPROVE）
   - 80%以上のカバレッジを確認

3. **コードレビュー**
   - コード記述直後に**code-reviewer**エージェントを使用
   - CRITICALとHIGHの問題に対処
   - 可能な場合はMEDIUMの問題も修正

4. **コミット & プッシュ**
   - 詳細なコミットメッセージ
   - conventional commits形式に従う
