# 🔐 セキュリティガイド

このドキュメントでは、APIキーとその他の機密情報の安全な管理方法について説明します。

## 🚨 重要な注意事項

### ✅ 実装済みのセキュリティ対策

1. **環境変数による管理**
   - APIキーは`.env`ファイルで管理
   - ソースコードに直接記述されない

2. **Git除外設定**
   - `.env`ファイルは自動的にGitから除外
   - 機密情報がリポジトリにコミットされない

3. **サンプルファイル提供**
   - `.env.example`でテンプレート提供
   - 実際のキーは含まれない

## 📋 安全な運用方法

### 開発時
```bash
# 1. サンプルファイルをコピー
cp .env.example .env

# 2. 実際のAPIキーを設定
vim .env  # または任意のエディタで編集
```

### チーム開発時
- `.env`ファイルは共有しない
- 各開発者が個別にAPIキーを設定
- `.env.example`は更新してコミット可能

### 本番環境
- 環境変数またはシークレット管理サービスを使用
- Dockerの場合: `docker run -e OPENROUTER_API_KEY=xxx`
- クラウドの場合: AWS Secrets Manager、Azure Key Vault等

## 🔧 設定ファイル構造

```
.env.example          # ← Git管理対象（テンプレート）
.env                  # ← Git除外対象（実際の設定）
.env.local           # ← ローカル開発用
.env.production      # ← 本番環境用
```

## ⚠️ セキュリティ上の注意

### やってはいけないこと
- ❌ APIキーをソースコードに直接記述
- ❌ `.env`ファイルをGitにコミット
- ❌ APIキーをチャットやメールで共有
- ❌ スクリーンショットにAPIキーを含める

### 推奨事項
- ✅ 環境変数での管理
- ✅ 定期的なAPIキーの更新
- ✅ 最小権限の原則
- ✅ アクセスログの監視

## 🛠️ トラブルシューティング

### APIキーが読み込まれない場合

1. **ファイル名確認**
   ```bash
   ls -la | grep .env
   ```

2. **ファイル内容確認**
   ```bash
   cat .env
   ```

3. **アプリの再起動**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### デバッグ情報の確認

アプリ起動時のログで設定状況を確認：

```
# 正常時
I/flutter: AI Config initialized successfully

# 設定ファイルなし時  
I/flutter: Warning: Could not load .env file
I/flutter: Using default configuration
```

## 📞 サポート

セキュリティに関する質問や懸念がある場合：

1. `.env`ファイルの設定を確認
2. `.gitignore`の設定を確認
3. 必要に応じてAPIキーを再生成

---

**重要**: APIキーは個人の責任で管理してください。紛失や漏洩の場合は、すぐにOpenRouterでキーを無効化し、新しいキーを生成してください。