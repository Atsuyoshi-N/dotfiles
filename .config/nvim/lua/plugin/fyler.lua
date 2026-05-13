return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "stable",
  lazy = false,
  opts = {
    integrations = {
      icon = "nvim_web_devicons",
    },

    views = {
      finder = {
        icon = {
          directory_empty = "",
          directory_expanded = "",
        },

        mappings = {
          ["<C-e>"] = "CloseView",
        },

        win = {
          kind = "float",
        },
      },
    },
  },
  keys = {
    { "<C-e>", "<Cmd>Fyler<Cr>", desc = "Open Fyler View" },
  }
}
