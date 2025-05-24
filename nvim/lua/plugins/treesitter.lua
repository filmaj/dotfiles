return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "bash", "css",
          "html", "jsdoc", "json", "sql", "yaml", "regex" },
        sync_install = false,
        auto_install = false,
        highlight = { enable = true },
        indent = {
          enable = true,
          disable = { "html" },
        },
      })
    end
  },
}
