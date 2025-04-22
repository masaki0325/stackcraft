# StackCraft

StackCraft は、3 つのプロジェクトで構成される総合的なノート管理システムです：

1. **モバイルアプリ（Flutter）**

   - クロスプラットフォーム対応のユーザー向けアプリケーション
   - Riverpod を使用した状態管理
   - 直感的な UI でノートの作成・管理が可能

2. **管理画面（React）**

   - 管理者向けの Web インターフェース
   - ユーザー管理とノート管理機能
   - TailwindCSS によるモダンな UI

3. **バックエンド API（Node.js）**
   - Express フレームワークによる RESTful API
   - Sequelize ORM でのデータベース操作
   - JWT 認証による安全なアクセス制御

## 機能

- ユーザー認証（ログイン/登録）
- ノートの作成、編集、削除
- ノート一覧の表示と更新
- プルリフレッシュによるノート一覧の更新
- 管理画面での権限管理（管理者、モデレーター、一般ユーザー）

## 技術スタック

### モバイルアプリ（Flutter）

- **フレームワーク**: Flutter 3.x
- **状態管理**
  - Riverpod
  - Flutter Hooks
- **ルーティング**: GoRouter
- **HTTP 通信**: Dio
- **ローカルストレージ**: SharedPreferences

### 管理画面（React）

- **フレームワーク**: React 18.x
- **UI ライブラリ**: TailwindCSS
- **状態管理**: React Hooks
- **ルーティング**: React Router v6
- **HTTP 通信**: Axios
- **フォーム**: React Hook Form

### バックエンド（Node.js）

- **フレームワーク**: Express
- **データベース**
  - MySQL
  - Sequelize ORM
- **認証**: JWT
- **バリデーション**: Express Validator

### 開発環境

- **コンテナ化**: Docker/Docker Compose
- **バージョン管理**: Git
- **コード品質**: ESLint/Prettier

## プロジェクト構造

```
.
├── app/                    # Flutterモバイルアプリ
│   ├── lib/               # Dartソースコード
│   │   ├── models/       # データモデル
│   │   ├── providers/    # Riverpodプロバイダー
│   │   ├── screens/      # 画面UI
│   │   ├── services/     # APIサービス
│   │   └── widgets/      # 再利用可能なウィジェット
│   └── test/             # テストコード
│
├── admin/                  # React管理画面
│   ├── src/              # ソースコード
│   │   ├── components/   # Reactコンポーネント
│   │   ├── hooks/       # カスタムフック
│   │   ├── pages/       # ページコンポーネント
│   │   ├── services/    # APIサービス
│   │   └── utils/       # ユーティリティ関数
│   └── tests/           # テストコード
│
├── api/                    # Node.jsバックエンド
│   ├── controllers/      # ルートハンドラー
│   ├── middleware/      # カスタムミドルウェア
│   ├── models/          # Sequelizeモデル
│   ├── routes/          # ルート定義
│   ├── validators/      # バリデーションルール
│   └── tests/          # テストコード
│
├── docker/                 # Docker設定
│   ├── mysql/           # MySQLコンテナ設定
│   ├── nginx/           # Nginxコンテナ設定
│   └── node/            # Nodeコンテナ設定
│
└── docs/                   # ドキュメント
    ├── api/              # APIドキュメント
    ├── mobile/           # モバイルアプリドキュメント
    └── admin/            # 管理画面ドキュメント
```

## セットアップ手順

### Docker を使用した環境構築

1. リポジトリのクローン

```bash
git clone https://github.com/yourusername/stackcraft.git
cd stackcraft
```

2. Docker コンテナの起動

```bash
docker compose up -d
```

これにより以下のサービスが起動します：

- API サーバー (http://localhost:5000)
- MySQL データベース (localhost:3306)
- 管理画面 (http://localhost:3000)

### 管理画面の開発

1. 依存関係のインストール

```bash
cd admin
npm install
```

2. 開発サーバーの起動

```bash
npm run dev
```

### モバイルアプリの開発

1. Flutter SDK のセットアップ

```bash
flutter doctor # 開発環境の確認
```

2. 依存関係のインストール

```bash
cd app
flutter pub get
```

3. 開発の開始

```bash
flutter run
```

## API 仕様

### 認証 API

| エンドポイント       | メソッド | 説明         |
| -------------------- | -------- | ------------ |
| `/api/auth/login`    | POST     | ログイン     |
| `/api/auth/register` | POST     | ユーザー登録 |

### ノート API

| エンドポイント   | メソッド | 説明           |
| ---------------- | -------- | -------------- |
| `/api/notes`     | GET      | ノート一覧取得 |
| `/api/notes`     | POST     | ノート作成     |
| `/api/notes/:id` | PUT      | ノート更新     |
| `/api/notes/:id` | DELETE   | ノート削除     |

### 管理者 API

| エンドポイント         | メソッド | 説明             |
| ---------------------- | -------- | ---------------- |
| `/api/admin/users`     | GET      | ユーザー一覧取得 |
| `/api/admin/users/:id` | PUT      | ユーザー更新     |
| `/api/admin/users/:id` | DELETE   | ユーザー削除     |

## API ドキュメント

詳細な API 仕様については、[API ドキュメント](docs/api.md)を参照してください。

## Postman コレクション

API のテストや開発には、[Postman コレクション](docs/StackCraft.postman_collection.json)を使用できます。このコレクションには以下のリクエストが含まれています：

- 認証
  - ログイン
  - ユーザー登録
- ノート
  - ノート一覧の取得
  - ノートの作成
  - ノートの更新
  - ノートの削除

コレクションをインポート後、環境変数 `token` にログイン時に取得した JWT トークンを設定してください。
