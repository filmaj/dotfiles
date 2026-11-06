return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install({ "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "bash", "css",
        "html", "jsdoc", "json", "sql", "yaml", "regex", "markdown", "markdown_inline", "groq" })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          -- no-op for filetypes without an installed parser
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end
  },
}
