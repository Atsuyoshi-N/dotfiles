vim.g.mapleader = t("<Space>")

vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_backup")
vim.opt.swapfile = false
vim.opt.writebackup = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.mouse = "a"

vim.opt.shortmess:append("I")

vim.opt.wrap = false
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.virtualedit = "onemore"
vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.showmatch = true
vim.opt.showcmd = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.fenc = "utf-8"
local tabwidth = 2
vim.opt.tabstop = tabwidth
vim.opt.softtabstop = tabwidth
vim.opt.shiftwidth = tabwidth
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.nrformats:remove({ "unsigned", "octal" })

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrapscan = true
vim.opt.wildmode = { list = "longest" }

vim.opt.undolevels = 1000
vim.opt.history = 1000

vim.opt.scrolloff = 4

vim.opt.list = true

vim.opt.listchars = {
	tab = "▸▹┊",
	trail = "▫",
	nbsp = "␣",
	extends = "❯",
	precedes = "❮",
}

vim.opt.guicursor:append({ "t:blinkon0" })

vim.opt.pumblend = 10
vim.opt.laststatus = 0
vim.cmd([[set statusline=%{repeat('─',winwidth('.'))}]])
vim.opt.showcmd = false

--- enable clipboard
vim.opt.clipboard:append("unnamedplus")

-- neovim以外でファイル変更があった後、neovimに復帰した際に自動で同期する
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    -- Only reload if buffer is not modified and not in command-line mode
    if vim.fn.mode() ~= "c" and not vim.bo.modified then
      vim.cmd("checktime")
    end
  end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function ()
    vim.api.nvim_echo({ { "File changed on disk. Buffer reloaded.", "WarningMsg" } }, false, {})
  end,
})
