return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local previewers = require("telescope.previewers")
    telescope.load_extension("fzf")

    telescope.setup({
      defaults = {
        buffer_previewer_maker = function(file, bufnr, opts)
          opts = opts or {}
          previewers.buffer_previewer_maker(file, bufnr, opts)
          if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            vim.schedule(function()
              pcall(function()
                vim.treesitter.start(bufnr)
              end)
            end)
          end
        end,
        preview = { treesitter = true },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" },
        file_ignore_patterns = { "bin/", "obj/", "%.vs/", "TestResults/", "packages/" },
        layout_config = { preview_width = 0.6 },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    -- Carrega a extensão do ui-select para capturar o vim.ui.select
    telescope.load_extension("ui-select")

    -- Atalhos do Telescope
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
    vim.keymap.set("n", "<leader>fi", "<cmd>Telescope git_files<cr>", opts)
    vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
    vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
    vim.keymap.set("n", "<leader>fr", function()
      require("telescope.builtin").lsp_references({ search = vim.fn.expand("<cword>") })
    end, opts)
    vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", opts)

    -- Atalho universal de Code Actions conectado ao Telescope via ui-select
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Actions" })
  end,
}
