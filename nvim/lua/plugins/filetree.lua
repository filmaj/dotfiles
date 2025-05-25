return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    lazy = false, -- neo-tree will lazily load itself
    ---@module "neo-tree"
    ---@type neotree.Config?
    opts = {
      filesystem = {
        bind_to_cwd = false,
        filtered_items = {
          hide_dotfiles = false,
        },
        hijack_netrw_behavior = "open_current",
      },
      window = {
        mappings = {
          ["<C-s>"] = "open_split",
          ["<C-v>"] = "open_vsplit",
        }
      }
    },
    keys = {
      { "<leader>tt", "<cmd>Neotree position=float source=filesystem toggle<cr>", desc = "Toggle filesystem tree" },
      { "<leader>tb", "<cmd>Neotree position=float source=buffers toggle<cr>",    desc = "Toggle buffers tree" },
    }
  }
}
