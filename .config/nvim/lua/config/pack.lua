require("core.plugin").init()
--- use lazy for package manager for nvim
local lazy = require("lazy")

if vim.env.NVIM_COLORSCHEME == nil then
  vim.env.NVIM_COLORSCHEME = "hybrid"
end

--- load plugins
lazy.setup({
  spec = {
    { import = "plugin" },
  },
  defaults = { lazy = true },
  install = { missing = true, colorscheme = { "vim-hybrid" } },
  checker = { enabled = true },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "netrw",
        "tarPlugin",
        "tar",
        "tohtml",
        "tutor",
        "zipPlugin",
        "ziop",
      },
    },
  }
})
