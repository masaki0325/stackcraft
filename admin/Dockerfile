# Node.jsバージョン18をベースにした公式イメージを使う
FROM node:18

# 作業ディレクトリを設定
WORKDIR /app

# 依存パッケージをインストール
COPY package*.json ./
RUN npm install

# アプリケーションコードをコピー
COPY . .

# ポート3000を公開
EXPOSE 3000

# アプリケーションの起動
CMD ["npm", "start"]