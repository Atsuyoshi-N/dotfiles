return {
  "https://github.com/andymass/vim-matchup",
  event = "BufReadPost",
  config = function ()
    vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    vim.g.matchup_treesitter_enable_quotes = true
    vim.g.matchup_treesitter_disable_virtual_text = true
    vim.g.matchup_treesitter_include_match_words = true
  end
}
