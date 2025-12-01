-- INICIALIZAÇÃO DO GERENCIADOR DE PLUGINS (LAZY.NVIM)
-- ===================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


vim.opt.clipboard = "unnamedplus"

-- ===================================================================
-- LISTA DE PLUGINS
-- ===================================================================
-- require('neoclip').setup({
-- 	history = 100,
-- 	enable_persistent_history = true,
-- 	continuous_sync = true,
-- 	enable_macro_history = true,
-- })


require("lazy").setup({

  -- Tema
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme tokyonight-night')
    end
  },

{
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    'nvim-telescope/telescope.nvim',
    },
    config = function()
    require('neoclip').setup({
        history = 100,
        -- enable_persistent_history = true,
        continuous_sync = true,
        enable_macro_history = true,
          })
  end,
},


  {
    'brianhuster/live-preview.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'ibhagwan/fzf-lua',
        'echasnovski/mini.pick',
        'folke/snacks.nvim',
    },
    config = function()
        require('livepreview.config').set({
            port = 8000,
            browser = 'default',
            dynamic_root = true,
            sync_scroll = true,
            picker = "",
            address = '127.0.0.1',
        })
    end
},

  -- =================================================================
  -- BUFFERLINE (ABAS)
  -- =================================================================
  {
    'akinsho/bufferline.nvim',
    branch = "main",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local colors = require("tokyonight.colors").setup({ style = "night" })

      require('bufferline').setup {
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          indicator = { icon = '▎' },
          buffer_close_icon = '',
          modified_icon = '●',
          close_icon = '',
          separator_style = "slant",
          always_show_bufferline = true,
        },
        highlights = {
          background = {
            fg = colors.comment,
            bg = colors.bg,
          },
          buffer_selected = {
            fg = colors.fg,
            bg = colors.bg_highlight,
            bold = true,
          },
          separator = {
            fg = colors.bg,
            bg = colors.bg,
          },
          separator_selected = {
            fg = colors.bg,
            bg = colors.bg_highlight,
          },
        }
      }
    end
  },

  -- =================================================================
  -- HARPOON
  -- =================================================================
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- =================================================================
  -- LUALINE (barra inferior)
  -- =================================================================
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
        }
      }
    end
  },

  -- =================================================================
  -- OUTROS PLUGINS
  -- =================================================================
  'sheerun/vim-polyglot',
  'preservim/nerdtree',
  'dense-analysis/ale',

  {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      -- suas configs ficam depois
    end
  },

  'honza/vim-snippets',
  'jiangmiao/auto-pairs',

  -- {
  --   'nvim-telescope/telescope.nvim',
  --   tag = '0.1.5',
  --   dependencies = { 'nvim-lua/plenary.nvim' }
  -- },

  'davidhalter/jedi-vim',
}, {
  ui = { border = "rounded" }
})

--- Lua
vim.o.autowriteall = true
vim.api.nvim_create_autocmd({ 'InsertLeavePre', 'TextChanged', 'TextChangedP' }, {
    pattern = '*', callback = function()
        vim.cmd('silent! write')
    end
})

-- ===================================================================
-- CONFIGURAÇÕES GLOBAIS (VIM.OPT)
-- ===================================================================
vim.cmd('syntax on')
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.hidden = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "100"
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 2
vim.opt.updatetime = 100
vim.opt.encoding = "utf-8"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.autoread = true
vim.opt.mouse = "a"
vim.cmd('filetype plugin indent on')

vim.o.omnifunc = ""

-- ===================================================================
-- HARPOON CONFIG
-- ===================================================================
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)

vim.keymap.set("n", "<C-o>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-p>", function() harpoon:list():next() end)

-- ===================================================================
-- CONFIGURAÇÕES DE TEMA / CORES
-- ===================================================================
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- ===================================================================
-- ALE
-- ===================================================================
vim.g.ale_linters = {
  python = { 'flake8', 'bandit'},
}
vim.g.ale_fixers = {
  ['*'] = { 'trim_whitespace' },
  python = { 'black', 'isort' },
}
vim.g.ale_fix_on_save = 1
vim.g.ale_python_flake8_options = '--max-line-length=100 --extend-ignore=E203'
vim.g.ale_python_black_options = '--line-length 100'

-- ===================================================================
-- COC CONFIG (COMPLETA, MANTIDA)
-- ===================================================================
vim.g.coc_global_extensions = { 'coc-snippets', 'coc-explorer' }

vim.g.python3_host_prog = '/usr/bin/python3'
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

local keyset = vim.keymap.set

function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

keyset("i", "<TAB>",
  'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
  { expr = true, noremap = true, silent = true }
)

keyset("i", "<S-TAB>",
  [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],
  { expr = true, noremap = true, silent = true }
)

keyset("i", "<cr>",
  [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
  { expr = true, noremap = true, silent = true }
)

keyset("i", "<c-space>", "coc#refresh()", { expr = true, silent = true })

keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

function _G.show_docs()
  local cw = vim.fn.expand('<cword>')
  if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
    vim.api.nvim_command('h ' .. cw)
  elseif vim.fn.CocAction('hasProvider', 'hover') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.api.nvim_command('! ' .. vim.o.keywordprg .. ' ' .. cw)
  end
end

keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
  group = "CocGroup",
  command = "silent call CocActionAsync('highlight')",
})

keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "CocGroup",
  pattern = {"typescript", "json", "jsonc"},
  command = "setl formatexpr=CocAction('formatSelected')",
})

vim.api.nvim_create_autocmd("User", {
  group = "CocGroup",
  pattern = "CocJumpPlaceholder",
  command = "call CocActionAsync('showSignatureHelp')",
})

local opts_float = { silent = true, nowait = true, expr = true }
keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts_float)
keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts_float)

keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts_float)
keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts_float)

vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = '?' })
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", { silent = true })
keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", { silent = true })
keyset("n", "<space>c", ":<C-u>CocList commands<cr>", { silent = true })
keyset("n", "<space>o", ":<C-u>CocList outline<cr>", { silent = true })
keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", { silent = true })
keyset("n", "<space>j", ":<C-u>CocNext<cr>", { silent = true })
keyset("n", "<space>k", ":<C-u>CocPrev<cr>", { silent = true })
keyset("n", "<space>p", ":<C-u>CocListResume<cr>", { silent = true })

vim.g.coc_explorer_global_presets = {
  ['.vim'] = { root_uri = '~/.vim' },
  cocConfig = { root_uri = '~/.config/coc' },
  tab = { position = 'tab', quit_on_open = true },
  floating = { position = 'floating', open_action_strategy = 'sourceWindow' },
}

keyset("n", "<space>ed", "<cmd>CocCommand explorer --preset .vim<cr>", { silent = true })
keyset("n", "<space>ef", "<cmd>CocCommand explorer --preset floating<cr>", { silent = true })
keyset("n", "<space>ec", "<cmd>CocCommand explorer --preset cocConfig<cr>", { silent = true })
keyset("n", "<space>eb", "<cmd>CocCommand explorer --preset buffer<cr>", { silent = true })
keyset("n", "<space>el", "<cmd>CocList explPresets<cr>", { silent = true })

-- ===================================================================
-- KEYMAPS GERAIS
-- ===================================================================
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts)
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opts)
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opts)
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opts)

-- Keymap para buscar a palavra que esta sob o cursor
vim.keymap.set('n', '<leader>fw', function()
    local word = vim.fn.expand('<cword>')
    vim.cmd('Telescope grep_string search=' .. word .. '\n')
end, {desc = 'Teste'})


vim.keymap.set('n', '<C-a>', '<cmd>NERDTreeToggle<cr>', opts)

vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

vim.keymap.set('n', 'te', '<cmd>tabe<cr>', opts)
vim.keymap.set('n', 'ty', '<cmd>bn<cr>', opts)
vim.keymap.set('n', 'tr', '<cmd>bp<cr>', opts)
vim.keymap.set('n', 'td', '<cmd>bd<cr>', opts)
vim.keymap.set('n', '<leader>h', '<cmd>nohlsearch<cr>', opts)

vim.keymap.set('n', 'th', '<cmd>split<cr>', opts)
vim.keymap.set('n', 'tv', '<cmd>vsplit<cr>', opts)
vim.keymap.set('n', 'tt', '<cmd>q<cr>', opts)

vim.keymap.set('n', 'tp', '<cmd>!python %<cr>', opts)

vim.keymap.set('n', '<leader>e', 'oif err != nil {<CR>}<Esc>O', opts)

