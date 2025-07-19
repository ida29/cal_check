# 設計文書

## 概要

カロリーチェッカー AI は、Flutter フレームワークを使用したクロスプラットフォームモバイルアプリケーションです。AI 画像認識技術を活用して食事写真から自動的にカロリーを計算し、ユーザーの健康管理をサポートします。

## アーキテクチャ

### 全体アーキテクチャ

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │    Business     │    │      Data       │
│     Layer       │◄──►│     Logic       │◄──►│     Layer       │
│                 │    │     Layer       │    │                 │
│ - Screens       │    │ - Services      │    │ - Repositories  │
│ - Widgets       │    │ - Providers     │    │ - Data Sources  │
│ - Controllers   │    │ - Models        │    │ - APIs          │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 技術スタック

- **フレームワーク**: Flutter 3.x
- **状態管理**: Riverpod
- **ローカルデータベース**: sqflite
- **画像処理**: image パッケージ
- **カメラ**: camera プラッケージ
- **AI 画像認識**: Google ML Kit または TensorFlow Lite
- **HTTP 通信**: dio
- **ローカル通知**: flutter_local_notifications

## コンポーネントとインターフェース

### 1. プレゼンテーション層

#### 主要画面

- **ホーム画面** (`HomeScreen`)

  - カメラ撮影ボタン
  - 最近の記録表示
  - 日次統計サマリー

- **カメラ画面** (`CameraScreen`)

  - カメラプレビュー
  - 撮影ボタン
  - ギャラリーからの選択

- **結果画面** (`ResultScreen`)

  - 認識結果表示
  - カロリー情報
  - 編集・保存オプション

- **履歴画面** (`HistoryScreen`)

  - 食事記録一覧
  - 日付フィルター
  - 詳細表示

- **統計画面** (`StatisticsScreen`)

  - 日次・週次グラフ
  - 目標との比較
  - 栄養バランス表示

- **設定画面** (`SettingsScreen`)
  - ユーザー情報
  - 目標設定
  - アプリ設定

#### 共通ウィジェット

- `CalorieCard`: カロリー情報表示
- `NutritionChart`: 栄養バランスチャート
- `MealItem`: 食事記録アイテム
- `LoadingOverlay`: ローディング表示

### 2. ビジネスロジック層

#### サービス

- **CameraService**: カメラ操作管理
- **ImageRecognitionService**: AI 画像認識処理
- **CalorieCalculationService**: カロリー計算
- **NotificationService**: 通知管理

#### プロバイダー（状態管理）

- **MealProvider**: 食事記録状態管理
- **UserProvider**: ユーザー情報状態管理
- **StatisticsProvider**: 統計データ状態管理
- **SettingsProvider**: アプリ設定状態管理

### 3. データ層

#### リポジトリ

- **MealRepository**: 食事記録データ操作
- **UserRepository**: ユーザーデータ操作
- **NutritionRepository**: 栄養データ操作

#### データソース

- **LocalDataSource**: SQLite データベース操作
- **RemoteDataSource**: 外部 API 通信（必要に応じて）

## データモデル

### 主要エンティティ

```dart
class Meal {
  final String id;
  final DateTime timestamp;
  final String imagePath;
  final List<FoodItem> foodItems;
  final double totalCalories;
  final NutritionInfo nutrition;
}

class FoodItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final double calories;
  final NutritionInfo nutrition;
  final double confidence; // AI認識の信頼度
}

class NutritionInfo {
  final double protein;
  final double carbohydrates;
  final double fat;
  final double fiber;
  final double sugar;
}

class User {
  final String id;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final double targetCalories;
  final String activityLevel;
}
```

### データベーススキーマ

```sql
-- ユーザーテーブル
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  age INTEGER,
  gender TEXT,
  height REAL,
  weight REAL,
  target_calories REAL,
  activity_level TEXT,
  created_at TEXT,
  updated_at TEXT
);

-- 食事記録テーブル
CREATE TABLE meals (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  timestamp TEXT,
  image_path TEXT,
  total_calories REAL,
  created_at TEXT,
  FOREIGN KEY (user_id) REFERENCES users (id)
);

-- 食材テーブル
CREATE TABLE food_items (
  id TEXT PRIMARY KEY,
  meal_id TEXT,
  name TEXT,
  quantity REAL,
  unit TEXT,
  calories REAL,
  protein REAL,
  carbohydrates REAL,
  fat REAL,
  confidence REAL,
  FOREIGN KEY (meal_id) REFERENCES meals (id)
);
```

## エラーハンドリング

### エラータイプと対応

1. **カメラエラー**

   - 権限不足: 権限要求ダイアログ表示
   - カメラ利用不可: エラーメッセージとギャラリー選択オプション

2. **画像認識エラー**

   - API 接続エラー: リトライ機能とオフライン通知
   - 認識失敗: 手動入力オプション提供

3. **データベースエラー**

   - 保存失敗: エラー通知と再試行
   - データ破損: バックアップからの復旧

4. **ネットワークエラー**
   - 接続不可: オフラインモード切り替え
   - タイムアウト: 自動リトライ機能

### エラー処理フロー

```dart
class ErrorHandler {
  static void handleError(AppError error) {
    switch (error.type) {
      case ErrorType.camera:
        _handleCameraError(error);
        break;
      case ErrorType.network:
        _handleNetworkError(error);
        break;
      case ErrorType.database:
        _handleDatabaseError(error);
        break;
    }
  }
}
```

## テスト戦略

### テストピラミッド

1. **ユニットテスト** (70%)

   - モデルクラスのテスト
   - サービスクラスのロジックテスト
   - ユーティリティ関数のテスト

2. **ウィジェットテスト** (20%)

   - 個別ウィジェットの動作テスト
   - 状態変化のテスト
   - ユーザーインタラクションのテスト

3. **統合テスト** (10%)
   - エンドツーエンドのフローテスト
   - データベース操作のテスト
   - API 連携のテスト

### テスト環境

- **モックデータ**: テスト用の画像とレスポンス
- **テストデータベース**: インメモリ SQLite
- **CI/CD**: GitHub Actions での自動テスト実行

### パフォーマンス考慮事項

1. **画像処理最適化**

   - 画像サイズの自動リサイズ
   - 非同期処理による UI ブロック回避

2. **データベース最適化**

   - インデックスの適切な設定
   - バッチ処理による効率化

3. **メモリ管理**

   - 画像キャッシュの適切な管理
   - 不要なオブジェクトの適時解放

4. **バッテリー最適化**
   - バックグラウンド処理の最小化
   - 効率的な AI 推論の実装
