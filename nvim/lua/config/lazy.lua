local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- 1. Importa as configurações padrão do LazyVim
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- 2. Configuração do Tema Sonokai
    {
      "sainnhe/sonokai",
      lazy = false,
      priority = 1000,
      config = function()
        -- Configurações de estilo do Sonokai
        vim.g.sonokai_enable_italic = true
        vim.g.sonokai_style = "atlantis" -- Opções: default, aurora, andromeda, shusia, maia, atlantis
        vim.cmd.colorscheme("sonokai")

        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      end,
    },

    -- 3. Importa seus plugins customizados da pasta lua/plugins/
    -- É aqui que você deve colocar o easy-dotnet, por exemplo.
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "sonokai", "habamax" } },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}) -- Fechamento correto da função setup)
