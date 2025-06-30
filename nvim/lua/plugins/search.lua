return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      -- Find/File operations (f* namespace)
      { "<leader>ff", function() require("telescope.builtin").find_files() end,          desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,           desc = "Find with grep" },
      { "<leader>fs", function() require("telescope.builtin").grep_string() end,         desc = "Find string under cursor" },

      -- LSP operations (l* namespace)
      { "<leader>lr", function() require("telescope.builtin").lsp_references() end,      desc = "LSP references" },
      { "<leader>li", function() require("telescope.builtin").lsp_implementations() end, desc = "LSP implementations" },
      { "<leader>ld", function() require("telescope.builtin").lsp_definitions() end,     desc = "LSP definitions" },
      -- telescope's split options by default won't split if reference is in the same file, so use a function to override that behaviour
      {
        "<leader>ls",
        function()
          vim.cmd("split")
          require("telescope.builtin").lsp_definitions()
        end,
        desc = "LSP definitions (split)"
      },
      {
        "<leader>lv",
        function()
          vim.cmd("vsplit")
          require("telescope.builtin").lsp_definitions()
        end,
        desc = "LSP definitions (vsplit)"
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      local keymap_overrides = {
        ["<C-s>"] = actions.select_horizontal
      }
      return {
        defaults = {
          layout_strategy = "flex",
          mappings = {
            i = keymap_overrides,
            n = keymap_overrides,
          }
        }
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("noice")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make"
  },
}
