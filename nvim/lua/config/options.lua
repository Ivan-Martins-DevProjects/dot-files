require("config.remote_clipboard").setup()
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

vim.g.colorscheme = "sonokai"

vim.g.lazyvim_lsp_inlay_hints = false

vim.opt.colorcolumn = "100"
vim.opt.shortmess:append("A")
