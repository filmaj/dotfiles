local lazypath = vim.fn.stdpath("config") .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
  },
  {
    "nvim-lualine/lualine.nvim",
    priority = 999,
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "bash", "css",
          "html", "jsdoc", "json", "sql", "yaml" },
        sync_install = false,
        auto_install = false,
        highlight = { enable = true },
        indent = {
          enable = true,
          disable = {"html"},
        },
      })
    end
  },
  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    tag = "v2.1.0"
  },
  {
    "williamboman/mason.nvim",
    tag = "v2.0.0",
    lazy = false,
  },
  -- Autocompletion
  {
    'saghen/blink.cmp',
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'super-tab' },
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = {
        documentation = { auto_show = true },
        list = {
          selection = { preselect = false, auto_insert = false },

        },
      },
      -- Experimental signature help support
      signature = { enabled = true },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      focus = true,
      keys = {
        ["<cr>"] = "jump_close",
      }
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>dd",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>db",
        "<cmd>Trouble diagnostics toggle filter.buf=0 win={type=float,size={height=10,width=0.8},position={0.1, 0.1},border=rounded}<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  "tpope/vim-sleuth",
  {
    "numToStr/Comment.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Add descriptions for which-key
      mappings = {
        basic = true,
        extra = false,
      },
    },
  },
  "lewis6991/gitsigns.nvim",
})
