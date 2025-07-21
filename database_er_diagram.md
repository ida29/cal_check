# Calorie Checker AI - ER図

## エンティティ関係図 (Entity Relationship Diagram)

```mermaid
erDiagram
    User {
        string id PK "主キー"
        string name "ユーザー名"
        int age "年齢"
        string gender "性別 (male/female/other)"
        double height "身長(cm)"
        double weight "体重(kg)"
        string activityLevel "活動レベル"
        double targetCalories "目標カロリー"
        double targetWeight "目標体重"
        bool isFirstTimeUser "初回ユーザーフラグ"
        datetime createdAt "作成日時"
        datetime updatedAt "更新日時"
    }

    Meal {
        string id PK "主キー"
        datetime timestamp "食事日時"
        string mealType "食事タイプ (breakfast/lunch/dinner/snack)"
        string imagePath "写真パス"
        double totalCalories "合計カロリー"
        string notes "メモ"
        bool isSynced "同期フラグ"
        bool isManualEntry "手動入力フラグ"
        datetime createdAt "作成日時"
    }

    FoodItem {
        string id PK "主キー"
        string meal_id FK "食事ID"
        string name "食品名"
        double quantity "数量"
        string unit "単位"
        double calories "カロリー"
        double confidenceScore "AI認識信頼度"
        string imageUrl "画像URL"
    }

    NutritionInfo {
        string food_item_id FK "食品アイテムID"
        double protein "タンパク質(g)"
        double carbohydrates "炭水化物(g)"
        double fat "脂質(g)"
        double fiber "食物繊維(g)"
        double sugar "糖質(g)"
        double sodium "ナトリウム(mg)"
    }

    Exercise {
        string id PK "主キー"
        datetime timestamp "運動日時"
        string type "運動タイプ (cardio/strength/flexibility/sports)"
        string name "運動名"
        int durationMinutes "運動時間(分)"
        double caloriesBurned "消費カロリー"
        string intensity "運動強度 (low/moderate/high)"
        string notes "メモ"
        int sets "セット数"
        int reps "レップ数"
        double weight "重量(kg)"
        double distance "距離(km)"
        bool isSynced "同期フラグ"
        bool isManualEntry "手動入力フラグ"
        datetime createdAt "作成日時"
    }

    WeightRecord {
        string id PK "主キー"
        datetime recordedAt "記録日時"
        double weight "体重(kg)"
        double bodyFat "体脂肪率(%)"
        double muscleMass "筋肉量(kg)"
        string note "メモ"
        datetime createdAt "作成日時"
        datetime updatedAt "更新日時"
    }

    FoodDatabase {
        string id PK "主キー"
        string name "食品名"
        string category "カテゴリ"
        double calories "カロリー(100gあたり)"
        double protein "タンパク質(g)"
        double carbs "炭水化物(g)"
        double fat "脂質(g)"
        string unit "標準単位"
    }

    ManagerCharacter {
        string id PK "主キー"
        string characterType "キャラクタータイプ (sakura/nyanko)"
        string name "キャラクター名"
        int notificationLevel "通知レベル"
        list messages "メッセージリスト"
        datetime createdAt "作成日時"
    }

    %% リレーションシップ
    User ||--o{ Meal : "has"
    User ||--o{ Exercise : "records"
    User ||--o{ WeightRecord : "tracks"
    User ||--|| ManagerCharacter : "selects"
    
    Meal ||--o{ FoodItem : "contains"
    FoodItem ||--|| NutritionInfo : "has"
    
    FoodItem }o--|| FoodDatabase : "references"
```

## 主要なリレーションシップ

### 1. User - Meal (1:多)
- 1人のユーザーは複数の食事記録を持つ
- 各食事記録は1人のユーザーに属する

### 2. User - Exercise (1:多)
- 1人のユーザーは複数の運動記録を持つ
- 各運動記録は1人のユーザーに属する

### 3. User - WeightRecord (1:多)
- 1人のユーザーは複数の体重記録を持つ
- 各体重記録は1人のユーザーに属する

### 4. User - ManagerCharacter (1:1)
- 1人のユーザーは1つのマネージャーキャラクターを選択
- キャラクター設定はユーザーごとに保存

### 5. Meal - FoodItem (1:多)
- 1回の食事は複数の食品アイテムを含む
- 各食品アイテムは1つの食事に属する

### 6. FoodItem - NutritionInfo (1:1)
- 各食品アイテムは1つの栄養情報を持つ
- 栄養情報は食品アイテムごとに計算される

### 7. FoodItem - FoodDatabase (多:1)
- 複数の食品アイテムが同じ食品データベースエントリを参照可能
- 食品データベースはマスターデータとして機能

## データベース設計の特徴

### 1. **正規化**
- 栄養情報を別テーブルに分離
- 食品マスターデータの分離
- 重複データの最小化

### 2. **拡張性**
- 新しい栄養素の追加が容易
- カスタム食品の追加対応
- 運動タイプの柔軟な拡張

### 3. **データ整合性**
- 外部キー制約による参照整合性
- enum型による値の制約
- NOT NULL制約による必須項目管理

### 4. **パフォーマンス考慮**
- 日付ベースのインデックス
- ユーザーIDによるパーティショニング
- 頻繁にアクセスされるデータの最適化

## 主要なインデックス

```sql
-- ユーザー別の食事記録検索用
CREATE INDEX idx_meals_user_timestamp ON meals(user_id, timestamp);

-- 日付範囲での検索用
CREATE INDEX idx_meals_timestamp ON meals(timestamp);

-- 運動記録の検索用
CREATE INDEX idx_exercises_user_timestamp ON exercises(user_id, timestamp);

-- 体重記録の検索用
CREATE INDEX idx_weight_records_user_recorded ON weight_records(user_id, recorded_at);

-- 食品データベースの検索用
CREATE INDEX idx_food_database_category ON food_database(category);
CREATE INDEX idx_food_database_name ON food_database(name);
```