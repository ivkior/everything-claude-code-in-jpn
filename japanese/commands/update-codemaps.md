# コードマップ更新

コードベース構造を分析し、アーキテクチャドキュメントを更新：

1. すべてのソースファイルをスキャンし、import、export、依存関係を抽出
2. 以下の形式でトークン効率の良いコードマップを生成：
   - codemaps/architecture.md - 全体アーキテクチャ
   - codemaps/backend.md - バックエンド構造
   - codemaps/frontend.md - フロントエンド構造
   - codemaps/data.md - データモデルとスキーマ

3. 前バージョンからの差分パーセンテージを計算
4. 変更が30%を超える場合、更新前にユーザー承認を要求
5. 各コードマップに鮮度タイムスタンプを追加
6. レポートを .reports/codemap-diff.txt に保存

分析にはTypeScript/Node.jsを使用。実装詳細ではなく、高レベル構造に焦点を当てる。
