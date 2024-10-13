# Linux 演習環境

このプロジェクトは、Docker を使用して簡単にセットアップできる Linux 演習環境を提供します。SSH アクセス、Docker ボリュームを使用したデータの永続化、作業スペースの共有などの機能を備えています。

## 前提条件

-   Docker
-   Docker Compose

## セットアップ

1. このリポジトリをクローンまたはダウンロードします。

2. プロジェクトディレクトリに移動します：

    ```
    cd linux-practice-environment
    ```

3. `.env`ファイルを編集して、必要に応じて設定を変更します：

    ```
    USERNAME=ubuntu
    USER_PASSWORD=your_secure_password
    SUDO_WITHOUT_PASSWORD=true
    CONTAINER_NAME=linux_environment
    SSH_PORT=2222
    WORKSPACE_VOLUME=./workspace
    TIMEZONE=Asia/Tokyo
    DATA_VOLUME_NAME=linux_practice_data
    ```

4. コンテナをビルドして起動します：
    ```
    docker-compose up -d
    ```

## 使用方法

### SSH アクセス

コンテナに SSH でアクセスするには：

```
ssh -p 2222 ubuntu@localhost
```

パスワードは`.env`ファイルで設定したものを使用します。

### データの永続化

データは Docker ボリューム`linux_practice_data`（または`.env`ファイルで指定した名前）を使用して永続化されます。このボリュームはコンテナ内の`/home/ubuntu/data`にマウントされています。このボリュームに保存されたデータはコンテナを削除しても保持されます。

使用例：

```
# コンテナ内で
echo "Hello, Data!" > /home/ubuntu/data/example.txt

# データの確認
cat /home/ubuntu/data/example.txt
```

Docker ボリュームの内容を確認するには：

```
docker volume inspect linux_practice_data
```

### 作業スペース

`./workspace`ディレクトリはコンテナ内の`/home/ubuntu/workspace`にマウントされています。このディレクトリは開発作業用に使用できます。

使用例：

```
# コンテナ内で
cd /home/ubuntu/workspace
git clone https://github.com/example/project.git

# ホスト側で
cd ./workspace/project
# ここでプロジェクトファイルを編集
```

## セキュリティ注意事項

-   本番環境で使用する場合は、強力なパスワードを使用し、可能であれば SSH 鍵認証に切り替えてください。
-   `SUDO_WITHOUT_PASSWORD`を`false`に設定することで、sudo 使用時にパスワードを要求できます。
-   `.env`ファイルには機密情報が含まれるため、バージョン管理システムにコミットしないよう注意してください。

## データ管理

-   データは Docker ボリューム`linux_practice_data`に保存されます。このボリュームは Docker によって管理され、ホストのファイルシステムとは独立しています。
-   ボリュームのバックアップを行う場合は、Docker のボリュームバックアップ機能を使用してください。

## トラブルシューティング

問題が発生した場合は、以下を試してください：

1. コンテナのログを確認：

    ```
    docker-compose logs
    ```

2. コンテナを再起動：

    ```
    docker-compose restart
    ```

3. 環境を完全に再構築（注意：データボリュームは保持されます）：

    ```
    docker-compose down
    docker-compose up -d --build
    ```

4. データボリュームの内容を確認：
    ```
    docker run --rm -v linux_practice_data:/data busybox ls -l /data
    ```

## コントリビューション

バグ報告や機能リクエストは、Issue トラッカーを使用してください。プルリクエストも歓迎します。

## ライセンス

このプロジェクトは[MIT ライセンス](LICENSE)の下で公開されています。
