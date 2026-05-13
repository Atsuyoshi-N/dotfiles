# Neovim LSPでInlay Hintsを正しく設定する完全ガイド

## はじめに

Neovim 0.10以降、待望のInlay Hints機能がネイティブでサポートされるようになりました。しかし、実際に設定してみると「LSPが重複起動する」「Inlay Hintsが表示されない」といった問題に遭遇することがあります。

この記事では、実際のトラブルシューティング経験を基に、mason.nvim + nvim-lspconfigを使ったInlay Hintsの正しい設定方法を解説します。

## 環境

- Neovim 0.11.5
- mason.nvim
- mason-lspconfig.nvim v2.0+
- nvim-lspconfig
- 対象LSP: astro-ls, typescript-language-server (ts_ls), lua_ls等

## 重要: ネイティブAPI使用について

**この記事で紹介する設定は、Neovim 0.10以降の公式Inlay Hints APIを使用します。プラグインは一切不要です。**

### プラグインが必要だった時代（Neovim 0.9以前）

過去には以下のようなプラグインが必要でした：
- `lvimuser/lsp-inlayhints.nvim`
- `MysticalDevil/inlay-hints.nvim`

これらはNeovimにネイティブのInlay Hints機能がなかった時代に、LSPの機能を独自実装していたプラグインです。

### 現在（Neovim 0.10以降）

Neovim 0.10以降では**ネイティブAPIが標準装備**されています：

```lua
-- ネイティブAPI（プラグイン不要）
vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
```

### ネイティブAPIのメリット

1. **依存関係ゼロ** - プラグインのメンテナンスを気にする必要なし
2. **高パフォーマンス** - C言語で実装された公式機能
3. **長期サポート保証** - Neovimの公式機能として継続的にサポート
4. **設定がシンプル** - 余計な抽象化レイヤーがない

**結論: Neovim 0.10以降を使用している場合、Inlay Hintsプラグインは削除して問題ありません。**

## 問題1: LSPサーバーの重複起動

### 症状

`.astro`ファイルを開くと、同じLSPサーバーが複数回起動してしまう：

```
- astro (id: 1)
- htmx (id: 2)
- astro (id: 3)  ← 重複！
- htmx (id: 4)   ← 重複！
```

### 原因

mason-lspconfig v2.0では、`automatic_enable`オプションがデフォルトで`true`になっています。これにより：

1. mason-lspconfigが自動的にサーバーを有効化（1回目）
2. 手動の`lspconfig[server].setup()`でも起動（2回目）

→ 結果として2回起動してしまいます

### 解決策

`mason_lspconfig.setup()`に`automatic_enable = false`を追加：

```lua
mason_lspconfig.setup({
  ensure_installed = {
    "astro", "lua_ls", "ts_ls", "pyright", "rust_analyzer",
    "gopls", "jsonls", "htmx", "marksman", "mdx_analyzer",
  },
  automatic_installation = true,  -- 自動インストールは継続
  automatic_enable = false,       -- 自動有効化を無効化
})
```

**重要**: `automatic_installation`と`automatic_enable`は別の概念です
- `automatic_installation`: サーバーの自動インストール（v2.0でも継続）
- `automatic_enable`: サーバーの自動有効化（v2.0で新規追加、デフォルトtrue）

## 問題2: Inlay Hintsが表示されない

### 症状

LSP設定でInlay Hintsを有効にしたはずなのに、実際には表示されない。

### 原因1: LspAttachイベントのタイミング問題

lazy.nvimの遅延ロード（`event = { "BufReadPre", "BufNewFile" }`）により、以下の順序で処理が発生：

1. ファイルを開く
2. LSPがアタッチされる
3. プラグインがロードされ、`LspAttach`イベントが登録される ← 遅い！

→ LspAttachイベントを見逃してしまいます

### 解決策1: 既存クライアントへの対応

`LspAttach`イベントだけでなく、既にアタッチ済みのクライアントにも対応：

```lua
local function enable_inlay_hints(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

-- 新規アタッチ時
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    enable_inlay_hints(client, bufnr)
  end,
})

-- 既存クライアント対応
vim.schedule(function()
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    local buffers = vim.lsp.get_buffers_by_client_id(client.id)
    for _, bufnr in ipairs(buffers) do
      enable_inlay_hints(client, bufnr)
    end
  end
end)
```

### 原因2: LSPサーバーごとの設定形式の違い

これが最も重要な発見です。**LSPサーバーによってInlay Hints設定のキー名が異なります**。

#### TypeScript Language Server (ts_ls)の場合

**古い形式**（`includeInlay...`）を使用：

```lua
-- lua/lsp/settings/ts_ls.lua
return {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}
```

#### Astro Language Server (astro-ls)の場合

**新しい形式**（`parameterNames.enabled`）を使用：

```lua
-- lua/lsp/settings/astro.lua
return {
  init_options = {
    typescript = {
      tsdk = vim.fn.trim(vim.fn.system("npm root -g")) .. "/typescript/lib",
    },
  },
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}
```

#### Lua Language Server (lua_ls)の場合

Lua LSPは独自の設定形式：

```lua
-- lua/lsp/settings/lua_ls.lua
return {
  settings = {
    Lua = {
      hint = {
        enable = true,
        arrayIndex = "Enable",
        setType = true,
        paramName = "All",
        paramType = true,
      },
    },
  },
}
```

### LSPサーバーごとの設定形式まとめ

| LSPサーバー | 設定形式 | 備考 |
|------------|---------|------|
| ts_ls | `includeInlay...` | Neovim向けの従来形式 |
| astro | `parameterNames.enabled` | VS Code互換の新形式 |
| lua_ls | `hint.enable` | 独自形式 |
| rust_analyzer | `inlayHints.enable` | 独自形式 |
| gopls | `hints` | 独自形式 |

**重要**: 各LSPサーバーの公式ドキュメントで最新の設定形式を確認してください。

## デバッグ方法

Inlay Hintsが表示されない場合、以下の手順でデバッグできます：

### 1. LSPサーバーのcapabilitiesを確認

```lua
local clients = vim.lsp.get_clients({ name = "astro" })
if #clients > 0 then
  print(vim.inspect(clients[1].server_capabilities.inlayHintProvider))
end
```

- `nil`: サーバーがInlay Hintsをサポートしていない
- `vim.empty_dict()`: 設定が正しく反映されていない
- テーブル: 正常に設定されている

### 2. Inlay Hintsが有効化されているか確認

```lua
:lua print(vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
```

### 3. デバッグ出力を追加

一時的にprint文を追加して、処理の流れを確認：

```lua
local function enable_inlay_hints(client, bufnr)
  print(string.format("Client: %s, inlayHintProvider: %s",
    client.name, vim.inspect(client.server_capabilities.inlayHintProvider)))

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    print(string.format("Enabled for %s on buffer %d", client.name, bufnr))
  end
end
```

`:messages`で出力を確認できます。

## 完全な設定例

最終的な`lua/plugin/lsp.lua`の設定：

```lua
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      -- 1. Mason Setup
      mason.setup()

      mason_lspconfig.setup({
        ensure_installed = {
          "astro", "lua_ls", "ts_ls", "pyright", "rust_analyzer",
          "gopls", "jsonls", "htmx", "marksman", "mdx_analyzer",
        },
        automatic_installation = true,
        automatic_enable = false,  -- 重複起動を防ぐ
      })

      -- 2. Capabilities (補完機能の連携)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities()
      end

      -- 3. Inlay Hints有効化関数
      local function enable_inlay_hints(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      -- 4. LspAttachイベント
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          enable_inlay_hints(client, bufnr)

          -- Inlay Hintsトグルキーマップ
          vim.keymap.set('n', '<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
          end, { buffer = bufnr, desc = 'Toggle Inlay Hints' })

          -- 診断関連キーマップ
          vim.keymap.set('n', 'gl', vim.diagnostic.open_float,
            { buffer = bufnr, desc = 'Show line diagnostics' })
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
            { buffer = bufnr, desc = 'Go to previous diagnostic' })
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
            { buffer = bufnr, desc = 'Go to next diagnostic' })
        end,
      })

      -- 5. 既存クライアントへのInlay Hints有効化
      vim.schedule(function()
        local clients = vim.lsp.get_clients()
        for _, client in ipairs(clients) do
          local buffers = vim.lsp.get_buffers_by_client_id(client.id)
          for _, bufnr in ipairs(buffers) do
            enable_inlay_hints(client, bufnr)
          end
        end
      end)

      -- 6. サーバーのセットアップ
      local servers = {
        "astro", "lua_ls", "ts_ls", "pyright", "rust_analyzer",
        "gopls", "jsonls", "htmx", "marksman", "mdx_analyzer",
      }

      for _, server in ipairs(servers) do
        local opts = { capabilities = capabilities }

        -- サーバー固有の設定を読み込み
        local has_settings, settings = pcall(require, "lsp.settings." .. server)
        if has_settings then
          opts = vim.tbl_deep_extend("force", opts, settings)
        end

        -- エラー時の保護
        local setup_ok, err = pcall(function()
          lspconfig[server].setup(opts)
        end)

        if not setup_ok then
          vim.notify("LSP Setup Error (" .. server .. "): " .. tostring(err), vim.log.levels.ERROR)
        end
      end
    end,
  },
}
```

## よくある質問

### Q1: Inlay Hintsが邪魔な時は？

一時的に無効化できます：

```lua
-- 無効化
vim.lsp.inlay_hint.enable(false, { bufnr = 0 })

-- 再度有効化
vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
```

キーマップに設定すると便利です（上記の完全な設定例には既に含まれています）：

```lua
-- LspAttachイベント内で設定（バッファごとに有効）
vim.keymap.set('n', '<leader>th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end, { buffer = bufnr, desc = 'Toggle Inlay Hints' })
```

これで`<leader>th`を押すたびに、現在のバッファのInlay Hintsをオン/オフできます。

### Q2: LSPサーバーごとに個別に設定したい場合は？

`LspAttach`内でサーバー名を判定：

```lua
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- TypeScriptとAstroのみ有効化
    if client.name == "ts_ls" or client.name == "astro" then
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end
  end,
})
```

### Q3: `automatic_installation`は削除されたのでは？

これは誤解です。mason-lspconfig v2.0での変更：

- **削除されていない**: `automatic_installation`は`ensure_installed`との併用が可能
- **削除された**: `handlers`オプション
- **新規追加**: `automatic_enable`オプション

### Q4: 診断キーマップについて

上記の設定例には診断関連のキーマップも含まれています：

```lua
gl   -- カーソル位置の診断エラーをフローティング表示
[d   -- 前の診断へ移動
]d   -- 次の診断へ移動
```

これらは**LazyVimやAstroNvimなどの人気ディストリビューションで広く採用されている標準的なキーマップ**です。

- **`gl`**: "go line diagnostic"の略で、コミュニティで最も人気
- **`[d`/`]d`**: Neovim 0.10以降のデフォルトキーマップ

**使い方:**
1. エラーが出ている行にカーソルを移動
2. `gl`を押すとエラー内容がポップアップ表示
3. `]d`で次のエラーへジャンプ、`[d`で前のエラーへジャンプ

## まとめ

Neovim LSPでInlay Hintsを正しく設定するポイント：

1. **mason-lspconfig v2.0では`automatic_enable = false`を設定**してLSPの重複起動を防ぐ
2. **`LspAttach`イベントと既存クライアントの両方**でInlay Hintsを有効化する
3. **LSPサーバーごとに設定形式が異なる**ことを理解する
   - ts_ls: `includeInlay...`形式
   - astro: `parameterNames.enabled`形式
   - lua_ls: `hint.enable`形式
4. **デバッグ時は`server_capabilities.inlayHintProvider`を確認**する
5. **便利なキーマップを設定する**
   - `<leader>th`: Inlay Hintsのトグル
   - `gl`: 診断エラー表示
   - `[d`/`]d`: 診断間の移動

これらのポイントを押さえれば、快適なLSP開発環境が構築できます。

## 参考リンク

- [ts-inlay-hints Guide](https://jellydn.github.io/ts-inlay-hints/)
- [nvim-lspconfig - astro.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/astro.lua)
- [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim)
- [Breaking Changes in Mason 2.0](https://kosu.me/blog/breaking-changes-in-mason-2-0-how-i-updated-my-neovim-lsp-config)
- [Neovim LSP Documentation](https://neovim.io/doc/user/lsp.html)
- [Neovim Diagnostic Documentation](https://neovim.io/doc/user/diagnostic.html)
- [A guide on Neovim's LSP client - Devlog](https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/)

---

**執筆日**: 2025年
**動作確認環境**: Neovim 0.11.5, mason-lspconfig v2.0+
