return {
  "saghen/blink.cmp",
  version = "v0.*", -- ou use range apropriado
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    -- 1. Atalhos de Teclado (Presets)
    -- "default", "super-tab", ou "enter"
    keymap = {
      preset = "super-tab",
      -- Exemplo de customização manual se não usar o preset:
      -- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },

    -- 2. Aparência da Janela de Completar
    appearance = {
      -- Ajusta o estilo dos ícones para fontes Nerd Font mono
      nerd_font_variant = "mono",
      -- Mantém compatibilidade visual limpa semelhante ao nvim-cmp
      use_nvim_cmp_as_default = true,
    },

    -- 3. Fontes de Dados (Sources)
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },

      per_filetype = {
        cs = { inherit_defaults = true, sources = { "lsp", "snippets", "path", "buffer" } },
      },
    },

    -- 4. Comportamento da Janela de Documentação e Menu
    completion = {
      trigger = {
        -- Mostra o menu automaticamente ao digitar
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
      menu = {
        border = "rounded",
        draw = {
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
        },
      },
      ghost_text = {
        enabled = true, -- Exibe texto fantasma da sugestão em tempo real
      },
    },

    -- 5. Motor de Busca Difusa (Fuzzy Matching)
    fuzzy = {
      implementation = "prefer_rust_with_warning", -- Usa motor em Rust otimizado para alta performance
    },
  },
  opts_extend = { "sources.default" },
}
