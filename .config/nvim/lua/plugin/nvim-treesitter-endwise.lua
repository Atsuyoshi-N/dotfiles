return {
  "https://github.com/RRethy/nvim-treesitter-endwise",
  ft = { "bash", "elixir", "fish", "julia", "lua", "luau", "ruby", "verilog", "vim" },
  config = function()
    require("nvim-treesitter-endwise").init()
  end,
}
