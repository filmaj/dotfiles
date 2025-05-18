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
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
      routes = {
        { filter = { event = "msg_show", kind = "", find = "written", }, opts = { skip = true }, },
        { filter = { event = "msg_show", kind = "", find = "<ed", }, opts = { skip = true }, },
        { filter = { event = "msg_show", kind = "", find = ">ed", }, opts = { skip = true }, },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
})
