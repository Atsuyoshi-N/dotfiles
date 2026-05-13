local isHybrid = function()
  return vim.startswith(vim.env.NVIM_COLORSCHEME, "hybrid")
end

return {
  {
    "w0ng/vim-hybrid",
    lazy = false,
    priority = 1000,
    event = isHybrid() and { "UiEnter" } or { "ColorScheme" },
    cond = not is_vscode(),
    config = function()
      vim.opt.background = "dark"

      if isHybrid() then
        vim.cmd.colorscheme(vim.env.NVIM_COLORSCHEME)
      end
    end,
  }
}
