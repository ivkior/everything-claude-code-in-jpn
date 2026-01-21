---
description: Playwrightでエンドツーエンドテストを生成・実行。テストジャーニーを作成、テストを実行、スクリーンショット/動画/トレースをキャプチャ、アーティファクトをアップロード。
---

# E2Eコマンド

このコマンドは**e2e-runner**エージェントを呼び出し、Playwrightを使用してエンドツーエンドテストを生成、保守、実行します。

## このコマンドが行うこと

1. **テストジャーニーを生成** - ユーザーフロー用のPlaywrightテストを作成
2. **E2Eテストを実行** - 複数ブラウザでテストを実行
3. **アーティファクトをキャプチャ** - 失敗時のスクリーンショット、動画、トレース
4. **結果をアップロード** - HTMLレポートとJUnit XML
5. **不安定なテストを特定** - 不安定なテストを隔離

## 使用するタイミング

`/e2e`を使用する場合：
- 重要なユーザージャーニーをテスト（ログイン、取引、支払い）
- 複数ステップのフローがエンドツーエンドで動作することを確認
- UIインタラクションとナビゲーションをテスト
- フロントエンドとバックエンドの統合を検証
- 本番デプロイの準備

## 動作の仕組み

e2e-runnerエージェントは：

1. **ユーザーフローを分析**し、テストシナリオを特定
2. **Page Object Modelパターンを使用してPlaywrightテストを生成**
3. **複数ブラウザでテストを実行**（Chrome、Firefox、Safari）
4. **失敗をキャプチャ**（スクリーンショット、動画、トレース）
5. **結果とアーティファクトを含むレポートを生成**
6. **不安定なテストを特定**し、修正を推奨

## 使用例

```
ユーザー: /e2e マーケット検索と表示フローをテスト

エージェント (e2e-runner):
# E2Eテスト生成: マーケット検索と表示フロー

## 特定されたテストシナリオ

**ユーザージャーニー:** マーケット検索 → 結果表示 → マーケットクリック → 詳細表示

**テストカバレッジ:**
1. マーケットページに移動
2. セマンティック検索を実行
3. 検索結果を確認
4. 最初の結果をクリック
5. マーケット詳細ページが読み込まれることを確認
6. チャートがレンダリングされることを確認

## 生成されたテストコード

```typescript
// tests/e2e/markets/search-and-view.spec.ts
import { test, expect } from '@playwright/test'
import { MarketsPage } from '../../pages/MarketsPage'
import { MarketDetailsPage } from '../../pages/MarketDetailsPage'

test.describe('マーケット検索と表示フロー', () => {
  test('ユーザーがマーケットを検索して詳細を表示できる', async ({ page }) => {
    // 1. マーケットページに移動
    const marketsPage = new MarketsPage(page)
    await marketsPage.goto()

    // ページが読み込まれたことを確認
    await expect(page).toHaveTitle(/Markets/)
    await expect(page.locator('h1')).toContainText('Markets')

    // 2. セマンティック検索を実行
    await marketsPage.searchMarkets('election')

    // APIレスポンスを待機
    await page.waitForResponse(resp =>
      resp.url().includes('/api/markets/search') && resp.status() === 200
    )

    // 3. 検索結果を確認
    const marketCards = marketsPage.marketCards
    await expect(marketCards.first()).toBeVisible()
    const resultCount = await marketCards.count()
    expect(resultCount).toBeGreaterThan(0)

    // 検索結果のスクリーンショットを撮影
    await page.screenshot({ path: 'artifacts/search-results.png' })

    // 4. 最初の結果をクリック
    const firstMarketTitle = await marketCards.first().textContent()
    await marketCards.first().click()

    // 5. マーケット詳細ページが読み込まれることを確認
    await expect(page).toHaveURL(/\/markets\/[a-z0-9-]+/)

    const detailsPage = new MarketDetailsPage(page)
    await expect(detailsPage.marketName).toBeVisible()
    await expect(detailsPage.marketDescription).toBeVisible()

    // 6. チャートがレンダリングされることを確認
    await expect(detailsPage.priceChart).toBeVisible()

    // マーケット名が一致することを確認
    const detailsTitle = await detailsPage.marketName.textContent()
    expect(detailsTitle?.toLowerCase()).toContain(
      firstMarketTitle?.toLowerCase().substring(0, 20) || ''
    )

    // マーケット詳細のスクリーンショットを撮影
    await page.screenshot({ path: 'artifacts/market-details.png' })
  })

  test('結果なしの検索が空の状態を表示', async ({ page }) => {
    const marketsPage = new MarketsPage(page)
    await marketsPage.goto()

    // 存在しないマーケットを検索
    await marketsPage.searchMarkets('xyznonexistentmarket123456')

    // 空の状態を確認
    await expect(page.locator('[data-testid="no-results"]')).toBeVisible()
    await expect(page.locator('[data-testid="no-results"]')).toContainText(
      /no.*results|no.*markets/i
    )

    const marketCount = await marketsPage.marketCards.count()
    expect(marketCount).toBe(0)
  })

  test('検索をクリアしてすべてのマーケットを再表示できる', async ({ page }) => {
    const marketsPage = new MarketsPage(page)
    await marketsPage.goto()

    // 初期のマーケット数
    const initialCount = await marketsPage.marketCards.count()

    // 検索を実行
    await marketsPage.searchMarkets('trump')
    await page.waitForLoadState('networkidle')

    // フィルタされた結果を確認
    const filteredCount = await marketsPage.marketCards.count()
    expect(filteredCount).toBeLessThan(initialCount)

    // 検索をクリア
    await marketsPage.searchInput.clear()
    await page.waitForLoadState('networkidle')

    // すべてのマーケットが再び表示されることを確認
    const finalCount = await marketsPage.marketCards.count()
    expect(finalCount).toBe(initialCount)
  })
})
```

## テストの実行

```bash
# 生成されたテストを実行
npx playwright test tests/e2e/markets/search-and-view.spec.ts

Running 3 tests using 3 workers

  ✓  [chromium] › search-and-view.spec.ts:5:3 › ユーザーがマーケットを検索して詳細を表示できる (4.2s)
  ✓  [chromium] › search-and-view.spec.ts:52:3 › 結果なしの検索が空の状態を表示 (1.8s)
  ✓  [chromium] › search-and-view.spec.ts:67:3 › 検索をクリアしてすべてのマーケットを再表示できる (2.9s)

  3 passed (9.1s)

生成されたアーティファクト:
- artifacts/search-results.png
- artifacts/market-details.png
- playwright-report/index.html
```

## テストレポート

```
╔══════════════════════════════════════════════════════════════╗
║                    E2Eテスト結果                              ║
╠══════════════════════════════════════════════════════════════╣
║ ステータス:  ✅ すべてのテストがパス                          ║
║ 合計:        3テスト                                         ║
║ 成功:        3 (100%)                                        ║
║ 失敗:        0                                               ║
║ 不安定:      0                                               ║
║ 所要時間:    9.1s                                            ║
╚══════════════════════════════════════════════════════════════╝

アーティファクト:
📸 スクリーンショット: 2ファイル
📹 動画: 0ファイル（失敗時のみ）
🔍 トレース: 0ファイル（失敗時のみ）
📊 HTMLレポート: playwright-report/index.html

レポートを表示: npx playwright show-report
```

✅ E2EテストスイートがCI/CD統合の準備完了！
```

## テストアーティファクト

テスト実行時に以下のアーティファクトがキャプチャされます：

**すべてのテストで:**
- タイムラインと結果を含むHTMLレポート
- CI統合用のJUnit XML

**失敗時のみ:**
- 失敗状態のスクリーンショット
- テストの動画記録
- デバッグ用トレースファイル（ステップバイステップのリプレイ）
- ネットワークログ
- コンソールログ

## アーティファクトの表示

```bash
# ブラウザでHTMLレポートを表示
npx playwright show-report

# 特定のトレースファイルを表示
npx playwright show-trace artifacts/trace-abc123.zip

# スクリーンショットはartifacts/ディレクトリに保存
open artifacts/search-results.png
```

## 不安定なテストの検出

テストが断続的に失敗する場合：

```
⚠️  不安定なテストを検出: tests/e2e/markets/trade.spec.ts

テストは10回中7回成功（70%成功率）

一般的な失敗:
"要素 '[data-testid="confirm-btn"]' を待機中にタイムアウト"

推奨修正:
1. 明示的な待機を追加: await page.waitForSelector('[data-testid="confirm-btn"]')
2. タイムアウトを増加: { timeout: 10000 }
3. コンポーネントの競合状態をチェック
4. 要素がアニメーションで隠れていないか確認

隔離の推奨: 修正するまでtest.fixme()としてマーク
```

## ブラウザ設定

デフォルトで複数のブラウザでテストを実行：
- ✅ Chromium (Desktop Chrome)
- ✅ Firefox (Desktop)
- ✅ WebKit (Desktop Safari)
- ✅ Mobile Chrome (オプション)

`playwright.config.ts`でブラウザを調整して設定。

## CI/CD統合

CIパイプラインに追加：

```yaml
# .github/workflows/e2e.yml
- name: Playwrightをインストール
  run: npx playwright install --with-deps

- name: E2Eテストを実行
  run: npx playwright test

- name: アーティファクトをアップロード
  if: always()
  uses: actions/upload-artifact@v3
  with:
    name: playwright-report
    path: playwright-report/
```

## プロジェクト固有の重要フロー

プロジェクトでは以下のE2Eテストを優先：

**🔴 CRITICAL（常にパスする必要あり）:**
1. ユーザーがウォレットを接続できる
2. ユーザーがマーケットを閲覧できる
3. ユーザーがマーケットを検索できる（セマンティック検索）
4. ユーザーがマーケット詳細を表示できる
5. ユーザーが取引できる（テスト資金で）
6. マーケットが正しく解決される
7. ユーザーが資金を引き出せる

**🟡 IMPORTANT:**
1. マーケット作成フロー
2. ユーザープロフィール更新
3. リアルタイム価格更新
4. チャートレンダリング
5. マーケットのフィルタとソート
6. モバイルレスポンシブレイアウト

## ベストプラクティス

**すべきこと:**
- ✅ 保守性のためにPage Object Modelを使用
- ✅ セレクターにdata-testid属性を使用
- ✅ 任意のタイムアウトではなく、APIレスポンスを待機
- ✅ 重要なユーザージャーニーをエンドツーエンドでテスト
- ✅ mainにマージする前にテストを実行
- ✅ テストが失敗したらアーティファクトをレビュー

**すべきでないこと:**
- ❌ 脆弱なセレクターを使用（CSSクラスは変わる可能性あり）
- ❌ 実装の詳細をテスト
- ❌ 本番環境に対してテストを実行
- ❌ 不安定なテストを無視
- ❌ 失敗時のアーティファクトレビューをスキップ
- ❌ すべてのエッジケースをE2Eでテスト（ユニットテストを使用）

## 重要な注意事項

**プロジェクトでCRITICAL:**
- 実際のお金が関わるE2Eテストは、テストネット/ステージングのみで実行
- 本番環境に対して取引テストを実行しない
- 金融テストには`test.skip(process.env.NODE_ENV === 'production')`を設定
- 少額のテスト資金のみを持つテストウォレットを使用

## 他のコマンドとの統合

- `/plan`を使用してテストする重要なジャーニーを特定
- `/tdd`をユニットテストに使用（より高速、より粒度が細かい）
- `/e2e`を統合とユーザージャーニーテストに使用
- `/code-review`を使用してテスト品質を確認

## 関連エージェント

このコマンドは以下にある`e2e-runner`エージェントを呼び出します：
`~/.claude/agents/e2e-runner.md`

## クイックコマンド

```bash
# すべてのE2Eテストを実行
npx playwright test

# 特定のテストファイルを実行
npx playwright test tests/e2e/markets/search.spec.ts

# ヘッドモードで実行（ブラウザを表示）
npx playwright test --headed

# テストをデバッグ
npx playwright test --debug

# テストコードを生成
npx playwright codegen http://localhost:3000

# レポートを表示
npx playwright show-report
```
