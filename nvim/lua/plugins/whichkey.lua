return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    expand = 1, -- expand groups when <= n mappings
    spec = {
      -- searching
      { "<leader>f",  group = "find", },
      -- Git + subgroups for better organization
      { "<leader>g",  group = "git", },
      { "<leader>gs", group = "stage", },
      { "<leader>gr", group = "reset", },
      { "<leader>gp", group = "preview", },
      { "<leader>gh", group = "hunk", },
      { "<leader>gt", group = "toggle", },
      -- lsp
      { "<leader>l",  group = "lsp", },
      -- diag/trouble
      { "<leader>d",  group = "diagnostics", },
      { "<leader>c",  desc = "clear references" },
      { "<leader>rn", desc = "rename" },
      { "<leader>ca", desc = "code action" },
      -- Filetree
      { "<leader>t",  desc = "File tree nav" },
      -- Navigation patterns
      { "]",          group = "next" },
      { "[",          group = "prev" },
      { "g",          group = "goto" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
