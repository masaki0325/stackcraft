# API ドキュメント

## 認証

### ログイン

```http
POST /api/auth/login
```

#### リクエストボディ

```json
{
  "email": "string",
  "password": "string"
}
```

#### レスポンス

```json
{
  "token": "string",
  "user": {
    "id": "number",
    "email": "string",
    "name": "string"
  }
}
```

### ユーザー登録

```http
POST /api/auth/register
```

#### リクエストボディ

```json
{
  "email": "string",
  "password": "string",
  "name": "string"
}
```

#### レスポンス

```json
{
  "token": "string",
  "user": {
    "id": "number",
    "email": "string",
    "name": "string"
  }
}
```

## ノート

### ノート一覧の取得

```http
GET /api/notes
```

#### ヘッダー

```
Authorization: Bearer <token>
```

#### レスポンス

```json
[
  {
    "id": "number",
    "title": "string",
    "content": "string",
    "createdAt": "string",
    "updatedAt": "string"
  }
]
```

### ノートの作成

```http
POST /api/notes
```

#### ヘッダー

```
Authorization: Bearer <token>
```

#### リクエストボディ

```json
{
  "title": "string",
  "content": "string"
}
```

#### レスポンス

```json
{
  "id": "number",
  "title": "string",
  "content": "string",
  "createdAt": "string",
  "updatedAt": "string"
}
```

### ノートの更新

```http
PUT /api/notes
```

#### ヘッダー

```
Authorization: Bearer <token>
```

#### リクエストボディ

```json
{
  "id": "number",
  "title": "string",
  "content": "string"
}
```

#### レスポンス

```json
{
  "id": "number",
  "title": "string",
  "content": "string",
  "createdAt": "string",
  "updatedAt": "string"
}
```

### ノートの削除

```http
DELETE /api/notes/:id
```

#### ヘッダー

```
Authorization: Bearer <token>
```

#### パラメータ

| パラメータ | 型     | 説明        |
| ---------- | ------ | ----------- |
| id         | number | ノートの ID |

#### レスポンス

```json
{
  "message": "string"
}
```

## エラーレスポンス

### 400 Bad Request

```json
{
  "message": "string"
}
```

### 401 Unauthorized

```json
{
  "message": "string"
}
```

### 404 Not Found

```json
{
  "message": "string"
}
```

### 500 Internal Server Error

```json
{
  "message": "string"
}
```
