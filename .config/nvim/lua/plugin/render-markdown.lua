return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = { "markdown", "mdx" },
  keys = {
    { "<Space>sm", ":RenderMarkdown toggle<CR>" },
  },
  opts = {
    render_modes = true,
    heading = {
      width = "block",
      left_pad = 0,
      right_pad = 4,
      icons = {},
    },
    code = {
      width = "block",
    }
  },
}
