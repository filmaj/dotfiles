local lsp = require('lsp-zero')
local config = require('lspconfig')
local cmp = require('cmp')
lsp.preset("recommended")
lsp.ensure_installed({
  'denols',
  'gopls',
  'lua_ls',
  'tsserver',
})

config.denols.setup {
  root_dir = config.util.root_pattern("deno.json", "deno.jsonc"),
}
config.lua_ls.setup(lsp.nvim_lua_ls())
config.tsserver.setup {
  root_dir = config.util.root_pattern("package.json"),
  single_file_support = false
}

-- Text completions
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-Space>'] = cmp.mapping.complete(),
})
lsp.setup_nvim_cmp({ mapping = cmp_mappings })

-- Buffer mappings
lsp.on_attach(function(_client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gV", ":vsplit | lua vim.lsp.buf.definition()<CR>")
  vim.keymap.set("n", "gS", ":split | lua vim.lsp.buf.definition()<CR>")
  vim.keymap.set("n", "<C-Space>", function() vim.lsp.buf.hover() end, opts)
end)

-- Initialization
lsp.setup()
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
