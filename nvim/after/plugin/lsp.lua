local lsp = require("lsp-zero")
local config = require("lspconfig")
local cmp = require("cmp")
-- local trouble = require("trouble")
lsp.preset("recommended")
lsp.ensure_installed({
  "cssls",
  "denols",
  "eslint",
  "gopls",
  "html",
  "lua_ls",
  "tsserver",
})

config.denols.setup {
  root_dir = config.util.root_pattern("deno.json", "deno.jsonc"),
}
config.lua_ls.setup(lsp.nvim_lua_ls())
config.tsserver.setup {
  root_dir = config.util.root_pattern("package.json"),
  single_file_support = false
}
config.eslint.setup {
  format = false
}

-- Text completions
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<CR>"] = cmp.mapping.confirm({ select = true }),
})
lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" }
  }),
})

-- Buffer mappings
lsp.on_attach(function(_client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "<C-Space>", function() vim.lsp.buf.hover() end, opts)
end)

lsp.setup()

-- Diagnostics key mappings
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
