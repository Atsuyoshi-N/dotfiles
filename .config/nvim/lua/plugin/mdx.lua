return {
  "davidmh/mdx.nvim",
  dependencies = {"nvim-treesitter/nvim-treesitter"},
  ft = "mdx",
  init = function()
    -- .mdxファイルのファイルタイプを設定（プラグインロード前に実行）
    vim.filetype.add({
      extension = {
        mdx = "mdx",
      },
    })
  end,
}
