return {
  "folke/snacks.nvim",
  opts = {
    scroll = { enabled = true },
    bigfile = { enabled = true },
  },
  keys = {
    {
      "<leader>t",
      function()
        Snacks.terminal()
      end,
      mode = { "n", "t" },
      desc = "Toggle Terminal",
    },
  },
}
