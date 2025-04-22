# Node.jsバージョン18をベースにした公式イメージを使う
FROM node:18

# 作業ディレクトリを設定
WORKDIR /app

# package.jsonとpackage-lock.jsonをコピー
COPY package*.json ./

# 開発環境の依存パッケージをインストール
RUN npm install

# アプリケーションコードをコピー
COPY . .

# ポート5000を公開
EXPOSE 5000

# アプリケーションの起動
CMD ["npm", "run", "dev"]
