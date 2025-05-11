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
    tag = "v2.0.0"
  },
  {
    "williamboman/mason-lspconfig.nvim",
    tag = "v2.0.0"
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    commit = "b5311ab3ed9c846b585c0c15b7559be131ec4be9"
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    commit = "39e2eda76828d88b773cc27a3f61d2ad782c922d"  -- No tags available
  },
  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    commit = "031e6ba70b0ad5eee49fd2120ff7a2e325b17fa7"  -- No tags available
  },
  {
    "L3MON4D3/LuaSnip",
    tag = "v2.3.0"
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
  "preservim/nerdcommenter",
})
