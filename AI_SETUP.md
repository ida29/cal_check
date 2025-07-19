# AI カロリー計算機能の設定方法

このアプリは、OpenRouter APIを使用してAIによる正確なカロリー計算機能を提供します。

## セットアップ手順

### 1. OpenRouter APIキーの取得

1. [OpenRouter](https://openrouter.ai/)にアクセス
2. アカウントを作成してログイン
3. [API Keys](https://openrouter.ai/keys)ページでAPIキーを生成
4. 初回クレジット（$5相当）を受け取り

### 2. APIキーの設定

`lib/config/ai_config.dart` ファイルを開き、以下の行を編集：

```dart
static const String openRouterApiKey = 'your-openrouter-api-key-here';
```

↓

```dart
static const String openRouterApiKey = 'あなたのAPIキー';
```

### 3. モデルの選択

利用可能なモデルと特徴：

| モデル | 速度 | 精度 | コスト | 推奨用途 |
|--------|------|------|--------|----------|
| Claude 3 Haiku | ⚡⚡⚡ | ⭐⭐⭐ | 💰 | 日常使用（デフォルト） |
| Claude 3 Sonnet | ⚡⚡ | ⭐⭐⭐⭐ | 💰💰 | バランス重視 |
| GPT-4 Vision | ⚡ | ⭐⭐⭐⭐⭐ | 💰💰💰 | 最高精度 |
| Gemini Pro Vision | ⚡⚡ | ⭐⭐⭐⭐ | 💰💰 | Google製 |

モデルを変更するには、`ai_config.dart`の`defaultModel`を変更：

```dart
static const String defaultModel = 'claude-3-haiku'; // または他のモデル
```

## 機能

### ✅ 実装済み機能

- 📸 写真からの食品認識
- 🔢 AIによる正確なカロリー計算
- 📊 栄養素分析（タンパク質、炭水化物、脂質）
- 🎯 信頼度スコア表示
- ❌ 検出項目の削除
- 🔄 分析の再実行
- 📱 デモモード（APIキー未設定時）

### 🚧 今後の機能

- ✏️ 検出項目の編集
- ➕ カスタム食品の追加
- 💾 食事履歴への保存
- 📈 日別統計
- ⚙️ 詳細設定

## 使用方法

1. アプリを起動
2. カメラタブに移動
3. 食事の写真を撮影
4. AI分析が自動実行
5. 結果を確認・調整
6. 保存して完了

## APIコストの目安

Claude 3 Haiku使用時の概算：

- 1回の解析：約$0.001-0.003（約0.1-0.3円）
- 月30回使用：約$0.03-0.09（約3-9円）
- 月100回使用：約$0.1-0.3（約10-30円）

※実際のコストは画像サイズや応答の長さによって変動します

## トラブルシューティング

### よくある問題

1. **「Analysis Failed」エラー**
   - APIキーが正しく設定されているか確認
   - インターネット接続を確認
   - OpenRouterの残高を確認

2. **分析が遅い**
   - より高速なモデル（Claude 3 Haiku）に変更
   - インターネット接続速度を確認

3. **認識精度が低い**
   - より正確なモデル（GPT-4 Vision）に変更
   - 照明の良い環境で撮影
   - 食品を明確にフレームに収める

### サポート

問題が解決しない場合は、以下を確認してください：

1. [OpenRouter Status](https://status.openrouter.ai/) - サービス状況
2. [OpenRouter Discord](https://discord.gg/openrouter) - コミュニティサポート
3. APIキーの使用量と残高

---

**注意**: APIキーは機密情報です。他人と共有したり、公開リポジトリにコミットしないよう注意してください。