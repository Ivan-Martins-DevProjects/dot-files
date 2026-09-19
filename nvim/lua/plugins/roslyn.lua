return {
  "seblyng/roslyn.nvim",
  ft = { "cs", "razor" },

  opts = {
    filewatching = "roslyn",
    broad_search = true,
    lock_target = false,
  },

  config = function(_, opts)
    -- Define a cor e opacidade percebida do Code Lens (LspCodeLens)
    vim.api.nvim_set_hl(0, "LspCodeLens", { fg = "#A0A8B7", italic = false })
    vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { fg = "#5c6370" })

    require("roslyn").setup(opts)

    vim.lsp.codelens.enable()

    vim.lsp.config("roslyn", {
      capabilities = {
        offsetEncoding = { "utf-16" },
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/codeLens") then
          vim.lsp.codelens.enable()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = function()
              vim.lsp.codelens.refresh({ bufnr = bufnr })
            end,
          })
        end
      end,
      settings = {
        ["csharp|background_analysis"] = {
          dotnet_compiler_diagnostics_scope = "fullSolution",
          dotnet_analyzer_diagnostics_scope = "fullSolution",
        },

        ["csharp|completion"] = {
          dotnet_show_completion_items_from_unimported_namespaces = true,
          dotnet_show_name_completion_suggestions = true,
        },

        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = false,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = false,

          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = false,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = false,
        },

        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
          dotnet_enable_tests_code_lens = true,
        },

        ["csharp|formatting"] = {
          dotnet_organize_imports_on_format = true,
        },

        ["csharp|symbol_search"] = {
          dotnet_search_reference_assemblies = true,
        },
      },
    })
  end,
}
