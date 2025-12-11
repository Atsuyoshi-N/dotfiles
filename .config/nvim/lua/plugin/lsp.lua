return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- 補完ソースも依存関係に含める
    },
    config = function()
      if vim.bo.filetype == "fyler" then
        return
      end
      -- 1. モジュールの読み込み
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

      -- 2. Masonのセットアップ
      mason.setup()

      -- 3. Mason-LSPConfigのセットアップ
      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "pyright",
          "rust_analyzer",
          "gopls",
          "jsonls",
        },
        automatic_installation = true,
      })

      -- 4. 補完機能(capabilities)の準備
      -- cmp_nvim_lsp がインストールされていない場合のエラーを防ぐための保護
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities()
      end

      -- 5. ハンドラーの設定 (LSP起動)
      mason_lspconfig.setup {
        -- デフォルトハンドラー
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- Lua固有設定
        ["lua_ls"] = function()
          lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
              },
            },
          })
        end,
      }
    end,
  },
}
