local telescope = require("telescope")
local builtin = require("telescope/builtin")
local actions = require("telescope/actions")
local keymap_overrides = {
  ["<C-s>"] = actions.select_horizontal
}
telescope.setup({
  defaults = {
    layout_strategy = "flex",
    mappings = {
      i = keymap_overrides,
      n = keymap_overrides,
    }
  }
})
telescope.load_extension("fzf")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>g", builtin.grep_string, {})
vim.keymap.set("n", "<leader>lr", builtin.lsp_references, {})
vim.keymap.set("n", "<leader>li", builtin.lsp_implementations, {})
vim.keymap.set("n", "<leader>ld", builtin.lsp_definitions, {})
