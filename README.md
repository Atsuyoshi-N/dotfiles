# dotfiles

nix-darwin + home-manager + flakes で macOS の開発環境を宣言的に管理する。

## Getting Started

### 1. Nix をインストール

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

インストール後、シェルを再起動する。

```sh
exec $SHELL
```

### 2. Homebrew をインストール

GUIアプリ（cask）の管理に必要。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 3. dotfiles をクローン

```sh
git clone https://github.com/Atsuyoshi-N/dotfiles.git ~/dotfiles
```

### 4. ホスト名を確認・設定

```sh
scutil --get LocalHostName
```

出力されたホスト名が `flake.nix` の `darwinConfigurations` に存在することを確認する。
新しいマシンの場合は、`nix/hosts/` にホスト別の設定ファイルを作成し、`flake.nix` にエントリを追加する。

### 5. ビルド・適用

初回:

```sh
cd ~/dotfiles
sudo nix run nix-darwin -- switch --flake .
```

2回目以降（`rebuild` abbr が使える）:

```sh
rebuild
# 展開: sudo --preserve-env=PATH darwin-rebuild switch --flake ~/dotfiles
```

## 構成

```
dotfiles/
  flake.nix                    # エントリーポイント
  nix/
    hosts/
      personal.nix             # 個人Mac固有設定
      work.nix                 # 仕事Mac固有設定
    modules/
      common.nix               # 共通設定
      home.nix                 # CLIツール + dotfilesシンボリックリンク
      darwin-defaults.nix      # macOSシステム設定
      homebrew.nix             # Homebrew cask管理
      shell.nix                # zshプラグイン
  .zshrc / .zshenv / ...       # 各種設定ファイル（そのまま管理）
  .config/nvim/ ...            # XDG設定ディレクトリ
```

## 新しいマシンを追加する

1. `nix/hosts/` に新しいホスト設定ファイルを作成（`personal.nix` や `work.nix` を参考に）
2. `flake.nix` の `darwinConfigurations` にエントリを追加
3. ビルド・適用

## パッケージの追加・変更

- **CLIツール**: `nix/modules/home.nix` の `home.packages` に追加
- **GUIアプリ**: `nix/modules/homebrew.nix` の `casks` に追加（ホスト固有の場合はホスト設定ファイルに）
- **macOS設定**: `nix/modules/darwin-defaults.nix` を編集

変更後は `darwin-rebuild switch` で適用する。
