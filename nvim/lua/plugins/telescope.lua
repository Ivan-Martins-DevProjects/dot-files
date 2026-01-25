return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        -- usa árvores de sintaxe (Treesitter) no preview
        preview = {
          treesitter = false,
        },

        -- melhora a aparência dos resultados
        color_devicons = true,

        -- deixa o Telescope usar highlights do colorscheme
        set_env = { ["COLORTERM"] = "truecolor" },

        file_ignore_patterns = {
          "bin/",
          "obj/",
          "%.vs/",
          "TestResults/",
          "packages/",
        },

        -- layout mais confortável
        layout_config = {
          preview_width = 0.6,
        },
      },
    })
  end,
}
