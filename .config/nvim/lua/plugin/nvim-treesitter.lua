return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  priority = 1000,
  config = function()
    require("nvim-treesitter").setup({
      -- シンタックスハイライトを有効化
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      -- インストールするパーサー
      ensure_installed = {
        "markdown",
        "markdown_inline",
        "lua",
        "vim",
        "vimdoc",
      },
      -- パーサーの自動インストール
      auto_install = true,

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
        callback = function ()
          pcall(vim.treesitter.start)
        end,
      })
    })
  end,
}
