return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim-lsp",
          always_show_bufferline = true,
          separator_style = "slope",
        },
      })
    end,
  },
}
