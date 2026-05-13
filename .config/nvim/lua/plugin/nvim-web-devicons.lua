return {
  "nvim-tree/nvim-web-devicons",
  lazy = false,
  priority = 900, ---MEMO: nvim-web-devicons overrides vim-hybrid for file icon colors
  opts = {
    color_icons = true,
    default = true,
  },
  config = function(_, opts)
    require("nvim-web-devicons").setup(opts)
    local devicons = require("nvim-web-devicons")
    for _, icon in pairs(devicons.get_icons()) do
    end
  end
}
