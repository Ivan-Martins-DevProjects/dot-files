-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
vim.opt.updatetime = 100

local inlay_group = vim.api.nvim_create_augroup("disable_inlay_hints", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    vim.lsp.inlay_hint.enable = function(_, _)
      pcall(function()
        local ns = vim.api.nvim_create_namespace("nvim.lsp.inlayhint")
        vim.api.nvim_set_decoration_provider(ns, nil)
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = inlay_group,
  callback = function(args)
    pcall(function()
      local ns = vim.api.nvim_create_namespace("nvim.lsp.inlayhint")
      vim.api.nvim_set_decoration_provider(ns, nil)
    end)
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(0, {
      lnum = line,
    })

    if #diagnostics == 0 then
      return
    end

    vim.diagnostic.open_float({
      focus = false,
      scope = "line",
      border = "rounded",
      source = "if_many",
    })
  end,
})
