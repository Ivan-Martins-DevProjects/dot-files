return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    enable_builtin = true,
    default_remote = { "upstream", "origin" },
    ssh_aliases = {},
  },
  keys = {
    { "<leader>pi", "<cmd>Octo issue list<cr>", desc = "List Issues (Octo)" },
    {
      "<leader>pp",
      function()
        -- Encontra a pasta raiz do git usando vim.fs
        local git_dir = vim.fs.find(".git", { upward = true, stop = vim.loop.os_homedir() })[1]
        if git_dir then
          -- Muda temporariamente o cwd do Neovim para a raiz do git
          vim.api.nvim_set_current_dir(vim.fs.dirname(git_dir))
        end
        vim.cmd("Octo pr list")
      end,
      desc = "List PRs (Octo)",
    },
    { "<leader>pP", "<cmd>Octo pr search<cr>", desc = "Search PRs (Octo)" },
  },
}
