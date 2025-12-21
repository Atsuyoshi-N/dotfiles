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

          -- ここにキーマップ設定などを追加することも可能です
          -- local opts = { buffer = bufnr }
          -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
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
            lspconfig[server].setup(opts)
        end)

        if not setup_ok then
            vim.notify("LSP Setup Error (" .. server .. "): " .. tostring(err), vim.log.levels.ERROR)
        end
      end
    end,
  },
}
