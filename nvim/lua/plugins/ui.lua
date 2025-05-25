-- Configure float window
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1f1f28" }) -- Dark background color
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7aa89f", bg = "#1f1f28" })

return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        background = { dark = "dragon", light = "lotus" },
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none"
              },
            },
          },
        },
        commentStyle = { italic = false },
        keywordStyle = { italic = false },
        overrides = function(colors)
          local theme = colors.theme
          return {
            -- dont italicize builtins (via treesitter)
            ["@variable.builtin"] = { fg = theme.syn.special2, italic = false },
            -- dark completion popup menu
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            -- floating window with borders
            NormalFloat = { bg = theme.ui.bg_m3 },
            FloatBorder = { fg = theme.ui.bg_p2, bg = theme.ui.bg_m3 },
            FloatTitle = { bg = theme.ui.bg_m3, fg = theme.ui.fg },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
      })
      vim.cmd("colorscheme kanagawa-dragon")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    priority = 999,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function(_, opts)
      local custom_iceberg = require("lualine/themes/iceberg")
      -- make middle part of status line background transparent
      custom_iceberg.normal.c.bg = 'none'
      return {
        options = {
          icons_enabled = true,
          theme = custom_iceberg,
        },
        sections = {
          lualine_a = {
            {
              'mode',
              fmt = function(str)
                -- Create shortened mode names
                local mode_map = {
                  ['NORMAL'] = 'N',
                  ['INSERT'] = 'I',
                  ['VISUAL'] = 'V',
                  ['V-LINE'] = 'L',
                  ['V-BLOCK'] = 'B',
                  ['REPLACE'] = 'R',
                  ['COMMAND'] = 'C',
                  ['TERMINAL'] = 'T',
                  ['SELECT'] = 'S',
                }
                -- Return the shortened version or the original if not found
                return mode_map[str] or str
              end,
            }
          },
          lualine_b = { 'diff', 'diagnostics' },
          lualine_c = {
            {
              'filename',
              path = 1,             -- 1 for relative path, 2 for absolute path
              file_status = true,
              shorting_target = 40, -- Shortens path if file name exceeds this length
            }
          },
          lualine_x = { 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = { 'diff', 'diagnostics' },
          lualine_b = {
            {
              'filename',
              path = 1, -- Same path style for inactive windows
              file_status = true,
            }
          },
          lualine_c = {},
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
      }
    end
  },
  {
    "folke/noice.nvim",
    priority = 998,
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
        { filter = { event = "msg_show", kind = "", find = "written", },    opts = { skip = true }, },
        { filter = { event = "msg_show", kind = "", find = "more lines", }, opts = { skip = true }, },
        { filter = { event = "msg_show", kind = "", find = "<ed", },        opts = { skip = true }, },
        { filter = { event = "msg_show", kind = "", find = ">ed", },        opts = { skip = true }, },
        { filter = { event = "msg_show", kind = "", find = "yanked", },     opts = { skip = true }, },
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
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
