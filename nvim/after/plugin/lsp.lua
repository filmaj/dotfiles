-- Global diagnostic keymaps
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

-- Configure floating window borders
vim.diagnostic.config({
  float = {
    border = "rounded"
  },
  severity_sort = true
})

-- Use LspAttach autocommand to set up mappings and configuration
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(event)
    -- Buffer local mappings
    local opts = { buffer = event.buf, noremap = true, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', function() require("telescope.builtin").lsp_definitions() end, opts)
    vim.keymap.set('n', 'gi', function() require("telescope.builtin").lsp_implementations() end, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<C-Space>', function()
      vim.lsp.buf.hover { border = "rounded" }
    end, opts)
    vim.keymap.set({ 'n', 'v' }, 'f', vim.lsp.buf.document_highlight, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>c', vim.lsp.buf.clear_references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', function() require("telescope.builtin").lsp_references() end, opts)
  end,
})
