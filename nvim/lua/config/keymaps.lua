-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-------------------------- Telescope --------------------------------------
local opts = { noremap = true, silent = false }

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

vim.keymap.set("v", "<leader>fw", function()
  local word = vim.fn.expand("<cword>")
  vim.cmd("Telescope grep_string search=" .. word .. "\n")
end, { desc = "Teste" })

-- Keymap para buscar a palavra que esta sob o cursor
vim.keymap.set("n", "<leader>fw", function()
  local word = vim.fn.expand("<cword>")
  vim.cmd("Telescope grep_string search=" .. word .. "\n")
end, { desc = "Teste" })

---------------------------------------------------------------------------
vim.keymap.set("n", "<C-a>", "<cmd>NERDTreeToggle<cr>", opts)

vim.keymap.set("n", "ty", "<cmd>bn<cr>", opts)
vim.keymap.set("n", "tr", "<cmd>bp<cr>", opts)
vim.keymap.set("n", "td", "<cmd>bd<cr>", opts)
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<cr>", opts)

vim.keymap.set("n", "C-h", "<cmd>TmuxNavigateLeft<cr>", opts)
vim.keymap.set("n", "C-j", "<cmd>TmuxNavigateDown<cr>", opts)
vim.keymap.set("n", "C-k", "<cmd>TmuxNavigateUp<cr>", opts)
vim.keymap.set("n", "C-l", "<cmd>TmuxNavigateRight<cr>", opts)

vim.keymap.set("n", "th", "<cmd>split<cr>", opts)
vim.keymap.set("n", "tv", "<cmd>vsplit<cr>", opts)
vim.keymap.set("n", "tt", "<cmd>bd<cr>", opts)

vim.keymap.set("n", "tp", "<cmd>!python %<cr>", opts)

-- Keymap para abrir terminal
vim.keymap.set("n", "<leader>t", "<cmd>!tmux split-window -v -p 30<cr>", opts)

vim.keymap.set("n", "<space>c", "<cmd>Telescope neoclip<cr>", opts)

local function goto_definition()
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  if #clients == 0 then
    vim.notify("Nenhum LSP ativo neste buffer", vim.log.levels.WARN)
    return
  end

  vim.lsp.buf.definition()
end
vim.keymap.set("n", "fd", goto_definition, opts)
