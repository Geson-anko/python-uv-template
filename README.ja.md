# 🚀 Python UV Template

[![GitHub stars](https://img.shields.io/github/stars/Geson-anko/python-uv-template?style=social)](https://github.com/Geson-anko/python-uv-template/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python Version](https://img.shields.io/badge/python-3.12+-blue.svg)](https://www.python.org/downloads/)
[![Format & Lint](https://github.com/Geson-anko/python-uv-template/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/Geson-anko/python-uv-template/actions/workflows/pre-commit.yml)
[![Test](https://github.com/Geson-anko/python-uv-template/actions/workflows/test.yml/badge.svg)](https://github.com/Geson-anko/python-uv-template/actions/workflows/test.yml)
[![Type Check](https://github.com/Geson-anko/python-uv-template/actions/workflows/type-check.yaml/badge.svg)](https://github.com/Geson-anko/python-uv-template/actions/workflows/type-check.yaml)

[English](./README.md) | **日本語**

> ✨ 高速なUVパッケージマネージャーを使用した、モダンなPythonプロジェクトテンプレート

## 📋 特徴

- 🐍 Python 3.12+、型ヒント付き
- 🧪 カバレッジ付きpytestの事前設定
- 🔍 pyrightによる静的型チェック
- 🧹 ruffによるコードフォーマット
- 🔄 GitHub Actionsを使用したCI/CD（pre-commit、テスト、型チェック用の個別ワークフロー）
- 🐳 開発環境用のDockerとDocker Composeサポート
- 📦 uvによる高速なパッケージ管理
- 📝 コード品質のためのpre-commitフック
- 🏗️ ベストプラクティスに従ったプロジェクト構造

## 🛠️ クイックスタート

### 新しいリポジトリの作成

[![Use this template](https://img.shields.io/badge/%E3%81%93%E3%81%AE%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88%E3%82%92%E4%BD%BF%E7%94%A8-2ea44f?style=for-the-badge)](https://github.com/new?template_name=python-uv-template&template_owner=Geson-anko)

### クローンとセットアップ

```bash
# 新しいリポジトリをクローン
git clone https://github.com/yourusername/your-new-repo.git
cd your-new-repo

# 対話式セットアップを実行（Linux/macOS）
./setup.sh your-project-name

# 対話式セットアップを実行（Windows）
.\Setup.ps1 your-project-name

# セットアップスクリプトは以下を実行します：
# - プロジェクトのリネーム
# - 使用言語の選択（英語/日本語）
# - ビルドツールの選択（Make/Just）
# - 不要なファイルのクリーンアップ
# - シンプルなREADMEテンプレートの作成

# セットアップ後、仮想環境を作成
make venv  # Makeを選択した場合
# または
just venv  # Justを選択した場合
```

### 開発ツール

`make` または `just` コマンドのどちらでも使用できます：

#### Make を使用

```bash
# すべてのチェックを実行（フォーマット、テスト、型チェック）
make run

# コードのフォーマット
make format

# テストの実行
make test

# 型チェックの実行
make type

# 一時ファイルのクリーンアップ
make clean
```

#### Just を使用

```bash
# 利用可能なコマンドを表示
just

# すべてのチェックを実行（フォーマット、テスト、型チェック）
just run

# コードのフォーマット
just format

# テストの実行
just test

# 型チェックの実行
just type

# 一時ファイルのクリーンアップ
just clean
```

### Docker開発

#### Make を使用

```bash
# Dockerイメージのビルド
make docker-build

# 開発コンテナの起動
make docker-up

# 開発コンテナへの接続
make docker-attach

# コンテナの停止
make docker-down

# コンテナの停止とボリュームの削除
make docker-down-volume

# コンテナの再起動
make docker-restart
```

#### Just を使用

```bash
# Dockerイメージのビルド
just docker-build

# 開発コンテナの起動
just docker-up

# 開発コンテナへの接続
just docker-attach

# コンテナの停止
just docker-down

# コンテナの停止とボリュームの削除
just docker-down-volume

# コンテナの再起動
just docker-restart
```

## 📂 プロジェクト構造

```
.
├── .github/            # GitHubワークフローとテンプレート
│   └── workflows/
│       ├── pre-commit.yml    # フォーマット＆リントワークフロー
│       ├── test.yml          # テストワークフロー
│       └── type-check.yaml   # 型チェックワークフロー
├── .vscode/            # VSCode設定
│   └── extensions.json
├── src/
│   └── python_uv_template/  # ソースコード（リネームされます）
├── tests/              # テストファイル
├── .pre-commit-config.yaml
├── docker-compose.yml  # Docker Compose設定
├── Dockerfile          # Dockerイメージ設定
├── Makefile            # 開発コマンド
├── pyproject.toml      # プロジェクト設定
├── LICENSE
└── README.md
```

## 🏄‍♂️ Docker環境の使用

このプロジェクトには、一貫した開発環境のためのDocker設定が含まれています。

1. [Docker](https://www.docker.com/products/docker-desktop) と [Docker Compose](https://docs.docker.com/compose/) をインストール
2. 開発コンテナをビルドして起動：
   ```bash
   make docker-build
   make docker-up
   make docker-attach
   ```
3. コンテナには、適切なシェル補完付きの必要なツールと依存関係がすべて含まれています

## 🧩 依存関係

- Python 3.12+
- [UV](https://github.com/astral-sh/uv) - モダンなPythonパッケージマネージャー
- `make venv` または `just venv` で自動的にインストールされる開発ツール
- オプション: [just](https://github.com/casey/just) - コマンドランナー（makeの代替）

## 📄 ライセンス

このプロジェクトはMITライセンスの下でライセンスされています - 詳細は[LICENSE](LICENSE)ファイルを参照してください。

## 🤝 貢献

お気軽にプルリクエストを提出してください。

1. リポジトリをフォーク
2. フィーチャーブランチを作成（`git checkout -b feature/amazing-feature`）
3. 変更をコミット（`git commit -m 'Add some amazing feature'`）
4. ブランチにプッシュ（`git push origin feature/amazing-feature`）
5. プルリクエストを開く

## 🔧 設定

### GitHub Actions

プロジェクトには3つのワークフローが含まれています：

- **pre-commit.yml**: すべてのファイルでpre-commitフックを実行
- **test.yml**: 複数のOSとPythonバージョンでテストを実行
- **type-check.yaml**: pyright型チェックを実行

### pyproject.toml

- Python 3.12+向けに設定
- 依存関係管理にUVを使用
- テスト、リント、型チェック用の開発依存関係を含む
- カバレッジ設定はテストファイルを除外

## 🙏 謝辞

- [UV](https://github.com/astral-sh/uv) - 高速なパッケージ管理
- [ruff](https://github.com/astral-sh/ruff) - 強力なPythonリンターとフォーマッター
- [pyright](https://github.com/microsoft/pyright) - 静的型チェック
- [pre-commit](https://pre-commit.com/) - gitフック管理
