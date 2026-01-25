return {
  {
    "saghen/blink.cmp",
    opts = {
      -- Configura o comportamento da lista
      completion = {
        list = {
          selection = {
            preselect = false, -- Impede que ele selecione o primeiro automaticamente
            auto_insert = true, -- Insere o texto conforme você navega (opcional)
          },
        },
      },
      -- Configura os atalhos manualmente para controle total
      keymap = {
        preset = "none", -- Removemos o padrão para não haver conflito
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },

        ["<Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_next()
            else
              return cmp.snippet_forward() -- Pula para o próximo campo de snippet
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_prev()
            else
              return cmp.snippet_backward() -- Volta no campo de snippet
            end
          end,
          "fallback",
        },
      },
    },
  },
}
