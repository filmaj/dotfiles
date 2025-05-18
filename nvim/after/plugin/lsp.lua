-- LSP setup
local lspconfig = require("lspconfig")
local mason = require("mason")

-- Mason setup
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  },
})

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
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<C-Space>', function()
      vim.lsp.buf.hover { border = "rounded" }
    end, opts)
    vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set({ 'n', 'v' }, 'f', vim.lsp.buf.document_highlight, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>c', vim.lsp.buf.clear_references, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Server specific configurations
lspconfig.biome.setup {
  root_markers = { "biome.json", "biome.jsonc" },
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { async = false }
      end,
    })
  end,
}

lspconfig.eslint.setup {
  root_markers = { ".eslintrc.json", ".eslintrc.js", "eslint.config.json" },
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
}

lspconfig.golangci_lint_ls.setup {}
lspconfig.gopls.setup {}
lspconfig.jsonls.setup {}

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { async = false }
      end,
    })
  end,
}

lspconfig.ts_ls.setup {
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
  workspace_required = true,
  init_options = {
    preferences = {
      includeCompletionsForImportStatements = true,
      includeCompletionsWithSnippetText = true,
      includeAutomaticOptionalChainCompletions = true,
      includeCompletionsWithInsertText = true,
    }
  }
}
