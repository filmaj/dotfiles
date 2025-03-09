local lsp = require("lsp-zero")
local config = require("lspconfig")
local cmp = require("cmp")
-- local trouble = require("trouble")
lsp.preset("recommended")
lsp.ensure_installed({
  "biome",
  "cssls",
  "denols",
  "eslint@4.8.0",
  "golangci_lint_ls",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "ts_ls",
})
config.biome.setup {
  root_dir = config.util.root_pattern("biome.json", "biome.jsonc"),
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { async = false }
      end,
    })
  end,
}
config.denols.setup {
  root_dir = config.util.root_pattern("deno.json", "deno.jsonc"),
  -- This will disable denols in non-Deno projects
  single_file_support = false,
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufReadPost", {
      buffer = bufnr,
      command = "DenolsCache",
    })
  end,
}
config.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})
config.golangci_lint_ls.setup{}
config.gopls.setup{}
config.jsonls.setup{}
config.lua_ls.setup(lsp.nvim_lua_ls())
config.ts_ls.setup {
  root_dir = function(fname)
    return config.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(fname) or
           config.util.find_git_ancestor(fname) or
           vim.fn.getcwd()
  end,
  single_file_support = true,
  init_options = {
    preferences = {
      -- These settings improve parameter completion
      includeCompletionsForImportStatements = true,
      includeCompletionsWithSnippetText = true,
      includeAutomaticOptionalChainCompletions = true,
      includeCompletionsWithInsertText = true,
    }
  }
}

-- Text completions
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<CR>"] = cmp.mapping({
    i = function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
      else
        fallback()
      end
    end,
    s = cmp.mapping.confirm({ select = true }),
    c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  }),
  -- Add tab completion
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { "i", "s" }),
})
lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 1000 },
    { name = "nvim_lsp_signature_help", priority = 900 }
  }),
  preselect = cmp.PreselectMode.None, -- Don't preselect first item
  completion = {
    completeopt = "menu,menuone,noinsert,noselect" -- Don't auto-select
  },
})

-- Buffer mappings
lsp.on_attach(function(_client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "<C-Space>", function() vim.lsp.buf.hover() end, opts)
end)

lsp.setup()

-- Diagnostics key mappings
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
