-- Global diagnostic keymaps
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { desc = "Prev diagnostic" })
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', { desc = "Next diagnostic" })

-- Configure floating window borders
vim.diagnostic.config({
  float = {
    border = "rounded"
  },
  severity_sort = true
})

-- Use LspAttach autocommand to set up mappings and configuration
local userLsp = 'UserLspConfig'
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup(userLsp, {}),
  callback = function(event)
    -- Buffer local mappings
    local base = { buffer = event.buf }
    local opts = vim.tbl_extend('force', base, { noremap = true, silent = true })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
    vim.keymap.set('n', 'gd', function() require("telescope.builtin").lsp_definitions() end,
      vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
    vim.keymap.set('n', 'gi', function() require("telescope.builtin").lsp_implementations() end,
      vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition,
      vim.tbl_extend('force', opts, { desc = 'Go to type definition' }))
    vim.keymap.set('n', '<C-Space>', function()
      vim.lsp.buf.hover { border = "rounded" }
    end, vim.tbl_extend('force', opts, { desc = 'Show hover information' }))
    vim.keymap.set({ 'n', 'v' }, '<leader>h', vim.lsp.buf.document_highlight,
      vim.tbl_extend('force', opts, { desc = 'Highlight symbol' }))
    vim.keymap.set({ 'n', 'v' }, '<leader>c', vim.lsp.buf.clear_references,
      vim.tbl_extend('force', opts, { desc = 'Clear references' }))
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
      vim.tbl_extend('force', opts, { desc = 'Code action' }))
    vim.keymap.set('n', 'gr', function() require("telescope.builtin").lsp_references() end,
      vim.tbl_extend('force', opts, { desc = 'Go to references' }))
    -- server capability detection and autocommands
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    -- Special case for biome: always set up formatting since we force capabilities
    if (not client:supports_method('textDocument/willSaveWaitUntil')
          and client:supports_method('textDocument/formatting'))
        or client.name == "biome" then
      vim.api.nvim_create_autocmd('BufWritePre', vim.tbl_extend('force', base, {
        group = vim.api.nvim_create_augroup(userLsp, { clear = false }),
        callback = function()
          -- Only format if this client still has formatting capabilities
          if client.server_capabilities.documentFormattingProvider or client.name == "biome" then
            vim.lsp.buf.format({ bufnr = event.buf, id = client.id, timeout_ms = 1000 })
          end
        end,
      }))
    end
  end,
})
