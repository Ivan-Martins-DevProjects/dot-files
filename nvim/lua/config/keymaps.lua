-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
---------------------------------------------------------------------------
vim.keymap.set("n", "<C-a>", "<cmd>NERDTreeToggle<cr>", opts)

vim.keymap.set("n", "ty", "<cmd>bn<cr>", opts)
vim.keymap.set("n", "tr", "<cmd>bp<cr>", opts)
vim.keymap.set("n", "td", "<cmd>bd<cr>", opts)
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<cr>", opts)

vim.keymap.set("n", "C-h", "<cmd>TmuxNavigateLeft<cr>", opts)
vim.keymap.set("n", "C-j", "<cmd>TmuxNavigateDown<cr>", opts)
vim.keymap.set("n", "C-k", "<cmd>TmuxNavigateUp<cr>", opts)
vim.keymap.set("n", "C-l", "<cmd>TmuxNavigateRight<cr>", opts)

vim.keymap.set("n", "th", "<cmd>split<cr>", opts)
vim.keymap.set("n", "tv", "<cmd>vsplit<cr>", opts)
vim.keymap.set("n", "tt", "<cmd>bd<cr>", opts)

local function goto_definition()
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  if #clients == 0 then
    vim.notify("Nenhum LSP ativo neste buffer", vim.log.levels.WARN)
    return
  end

  -- Pega a codificação de offset do primeiro cliente ativo (padrão utf-16)
  local encoding = clients[1].offset_encoding or "utf-16"
  local params = vim.lsp.util.make_position_params(0, encoding)

  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      vim.notify("Nenhuma definição encontrada", vim.log.levels.WARN)
      return
    end

    -- Se o LSP retornar uma lista de localizações, escolhe a primeira
    local target = vim.islist(result) and result[1] or result

    -- Usa a API atualizada (show_document) em vez de jump_to_location
    vim.lsp.util.show_document(target, encoding, { focus = true })
  end)
end

vim.keymap.set("n", "fd", goto_definition, opts)

vim.keymap.set("n", "<leader>j", "<cmd>%!python3 -m json.tool<cr>", opts)

vim.keymap.set("n", "<leader>ri", function()
  vim.ui.input({ prompt = "Namespace antigo" }, function(old_ns)
    if not old_ns or old_ns == "" then return end
    vim.ui.input({ prompt = "Namespace novo" }, function(new_ns)
      if not new_ns or new_ns == "" then return end

      local cs_files = vim.fn.systemlist({ "find", vim.fn.getcwd(), "-name", "*.cs", "-type", "f" })
      if vim.v.shell_error ~= 0 or #cs_files == 0 then
        vim.notify("Nenhum arquivo .cs encontrado", vim.log.levels.WARN)
        return
      end

      local count = 0
      for _, file in ipairs(cs_files) do
        local content = table.concat(vim.fn.readfile(file), "\n")
        if content:find(old_ns, 1, true) then
          local new_content = content:gsub(vim.pesc(old_ns), new_ns)
          vim.fn.writefile(vim.split(new_content, "\n"), file)
          count = count + 1
        end
      end

      vim.notify(string.format("Namespace renomeado em %d arquivo(s)", count))
    end)
  end)
end, { desc = "Renomear namespace em todo o projeto" })
