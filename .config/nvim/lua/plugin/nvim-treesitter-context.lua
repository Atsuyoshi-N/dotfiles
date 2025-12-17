return {
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  event = "CursorHold",

  config = function ()
    require("treesitter-context").setup({
      enable = true,
      patterns = {
        css = { "media_statement", "rule_set" },
        scss = { "media_statement", "rule_set" },
        rmd = { "section" },
        yaml = { "block_mapping_pair", "block_sequence_item" },
      }
    })

    vim.keymap.set("n", "[c", function ()
      require("treesitter-context").go_to_context(vim.v.count1)
    end, { silent = true })
  end
}
