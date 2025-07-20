# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

これは「Calorie Checker AI」というFlutterアプリケーションです。AIを使用して食品写真からカロリーを自動計算する健康管理アプリです。

### 主な機能
- 写真からの食品認識とカロリー計算（OpenRouter API使用）
- バーコードスキャンによる栄養情報取得
- 運動記録と消費カロリー計算
- オフラインファーストのローカルデータベース
- 日本語・英語の多言語対応

## 開発コマンド

### 基本的なセットアップ
```bash
# 依存関係のインストール
flutter pub get

# 環境変数の設定（OpenRouter APIキーが必要）
cp .env.example .env
# .envファイルを編集してOPENROUTER_API_KEYを追加

# コード生成（モデルファイル変更後は必須）
dart run build_runner build --delete-conflicting-outputs

# ローカライゼーションファイルの生成
flutter gen-l10n
```

### 開発中によく使うコマンド
```bash
# アプリの実行
flutter run

# コード生成の自動監視（モデル開発時に便利）
dart run build_runner watch --delete-conflicting-outputs

# コード解析
flutter analyze

# テストの実行
flutter test

# 特定のテストファイルの実行
flutter test test/widget_test.dart

# ビルドのクリーン
flutter clean
```

### リリースビルド
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## アーキテクチャ概要

### クリーンアーキテクチャの3層構造

1. **プレゼンテーション層** (`/lib/presentation/`)
   - `screens/` - 各画面のUI実装
   - `widgets/` - 再利用可能なUIコンポーネント

2. **ビジネスロジック層** (`/lib/business/`)
   - `providers/` - Riverpodによる状態管理
   - `services/` - AIサービス、カメラ、通知などのビジネスロジック
   - `models/` - Freezedによる不変データモデル

3. **データ層** (`/lib/data/`)
   - `repositories/` - データアクセスの抽象化
   - `datasources/` - SQLiteデータベース実装
   - `entities/` - データベースエンティティ

### 重要な設計パターン

**状態管理フロー:**
```
UI → StateNotifierProvider → Service/Repository → Database/API
         ↓ AsyncValue
    Loading/Error/Data
```

**依存性注入:**
- Riverpodプロバイダーを使用したDIコンテナ
- リポジトリインターフェースによる実装の分離

**データモデル:**
- Freezedによる不変オブジェクト
- `@freezed`アノテーション使用時は必ずコード生成が必要

### 主要なプロバイダー

- `userProvider` - ユーザー情報の管理
- `dailySummaryProvider` - 日別カロリー集計
- `mealsByDateProvider` - 日付別の食事記録
- `exerciseProvider` - 運動記録の管理
- `aiCalorieServiceProvider` - AI解析サービス

### ナビゲーション構造

```
SplashScreen → SetupGuideScreen（初回）
            → MainNavigationScreen
                ├── HomeScreen
                ├── HistoryScreen
                ├── ExerciseScreen
                ├── StatisticsScreen
                └── SettingsScreen
```

## 開発時の注意点

1. **モデルファイル変更時**: `/lib/business/models/`や`/lib/data/entities/`のFreezedモデルを変更したら必ず`dart run build_runner build`を実行

2. **AIサービス**: `.env`ファイルにOPENROUTER_API_KEYが設定されていない場合、モックデータが返される

3. **データベース**: SQLiteを使用。マイグレーションは`DatabaseHelper`の`_onUpgrade`で管理

4. **権限**: カメラとストレージのアクセス権限が必要

5. **状態管理**: AsyncValueを使用してローディング/エラー/データ状態を一貫して処理

6. **ローカライゼーション**: 新しい翻訳を追加する場合は`/lib/l10n/`のARBファイルを更新後、`flutter gen-l10n`を実行