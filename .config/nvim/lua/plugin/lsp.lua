return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "folke/neodev.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Setup neodev before LSP
      require("neodev").setup({
        library = {
          enabled = true,
          runtime = true,
          types = true,
          plugins = false,
        },
      })

      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      -- Inlay Hintsの色設定（明るめのグレー）
      vim.api.nvim_set_hl(0, 'LspInlayHint', {
        fg = '#999999',  -- 明るめのグレー
        italic = true,   -- イタリック体（お好みで調整可）
      })

      -- 1. Mason Setup
      mason.setup()

      mason_lspconfig.setup({
        ensure_installed = {
          "astro", "lua_ls", "ts_ls", "pyright", "rust_analyzer",
          "gopls", "jsonls", "htmx", "marksman", "mdx_analyzer",
        },
        automatic_installation = true,
        automatic_enable = false,
      })

      -- 2. Capabilities (補完機能の連携)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities()
      end

      -- 3. 共通のLspAttach設定 (モダンなon_attachの代替)
      -- Neovim 0.10+ では on_attach を各サーバーに渡すのではなく
      -- このオートコマンドで一括管理するのが推奨です
      local function enable_inlay_hints(client, bufnr)
        -- Inlay Hintsの有効化
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          enable_inlay_hints(client, bufnr)

          -- LSP ナビゲーション（Telescopeを使って一覧表示）
          vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>',
            { buffer = bufnr, desc = 'Go to definition (Telescope)' })
          vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>',
            { buffer = bufnr, desc = 'Show references (Telescope)' })
          vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>',
            { buffer = bufnr, desc = 'Go to implementation (Telescope)' })
          vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<cr>',
            { buffer = bufnr, desc = 'Go to type definition (Telescope)' })

          -- その他のLSP機能
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
            { buffer = bufnr, desc = 'Go to declaration' })
          vim.keymap.set('n', 'K', vim.lsp.buf.hover,
            { buffer = bufnr, desc = 'Hover documentation' })
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
            { buffer = bufnr, desc = 'Signature help' })
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
            { buffer = bufnr, desc = 'Rename symbol' })
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
            { buffer = bufnr, desc = 'Code action' })
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format({ async = true })
          end, { buffer = bufnr, desc = 'Format buffer' })

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

      -- 既にアタッチされているクライアントに対してもinlay hintsを有効化
      vim.schedule(function()
        local clients = vim.lsp.get_clients()
        for _, client in ipairs(clients) do
          local buffers = vim.lsp.get_buffers_by_client_id(client.id)
          for _, bufnr in ipairs(buffers) do
            enable_inlay_hints(client, bufnr)
          end
        end
      end)

      local servers = {
          "astro", "lua_ls", "ts_ls", "pyright", "rust_analyzer",
          "gopls", "jsonls", "htmx", "marksman", "mdx_analyzer",
      }

      for _, server in ipairs(servers) do
        local opts = {
          capabilities = capabilities,
        }

        -- 設定ファイルの読み込み (lua/lsp/settings/server_name.lua)
        local has_settings, settings = pcall(require, "lsp.settings." .. server)
        if has_settings then
          opts = vim.tbl_deep_extend("force", opts, settings)
        end

        -- ★ここ重要: エラーが出てもNeovim全体が落ちないように保護してsetupする
        local setup_ok, err = pcall(function()
            -- Neovim 0.11+ の新しいAPI
            vim.lsp.config(server, opts)
            vim.lsp.enable(server)
        end)

        if not setup_ok then
            vim.notify("LSP Setup Error (" .. server .. "): " .. tostring(err), vim.log.levels.ERROR)
        end
      end
    end,
  },
}
