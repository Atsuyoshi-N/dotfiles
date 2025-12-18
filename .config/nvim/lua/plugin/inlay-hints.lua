return {
  "MysticalDevil/inlay-hints.nvim",
  event = "LspAttach",
  dependencies = {
    "neovim/nvim-lspconfig",
  },

  config = function()
    vim.lsp.inlay_hint.enable(true)

    vim.keymap.set("n", "<leader>ih", function ()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle Inlay Hints" })

    require("inlay-hints").setup()
  end
}
