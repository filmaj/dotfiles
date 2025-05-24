return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      -- Navigation
      {
        "]c",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            require('gitsigns').nav_hunk('next')
          end
        end,
        desc = "Next hunk"
      },
      {
        "[c",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            require('gitsigns').nav_hunk('prev')
          end
        end,
        desc = "Previous hunk"
      },

      -- Actions
      { "<leader>hs", function() require('gitsigns').stage_hunk() end,                                       desc = "Stage hunk",           mode = "n" },
      { "<leader>hr", function() require('gitsigns').reset_hunk() end,                                       desc = "Reset hunk",           mode = "n" },
      { "<leader>hs", function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = "Stage hunk",           mode = "v" },
      { "<leader>hr", function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = "Reset hunk",           mode = "v" },
      { "<leader>hS", function() require('gitsigns').stage_buffer() end,                                     desc = "Stage buffer" },
      { "<leader>hR", function() require('gitsigns').reset_buffer() end,                                     desc = "Reset buffer" },
      { "<leader>hp", function() require('gitsigns').preview_hunk() end,                                     desc = "Preview hunk" },
      { "<leader>hi", function() require('gitsigns').preview_hunk_inline() end,                              desc = "Preview hunk inline" },
      { "<leader>hb", function() require('gitsigns').blame_line({ full = true }) end,                        desc = "Blame line" },
      { "<leader>hd", function() require('gitsigns').diffthis() end,                                         desc = "Diff this" },
      { "<leader>hD", function() require('gitsigns').diffthis('~') end,                                      desc = "Diff this ~" },
      { "<leader>hQ", function() require('gitsigns').setqflist('all') end,                                   desc = "All hunks to quickfix" },
      { "<leader>hq", function() require('gitsigns').setqflist() end,                                        desc = "Hunks to quickfix" },

      -- Toggles
      { "<leader>tb", function() require('gitsigns').toggle_current_line_blame() end,                        desc = "Toggle blame line" },
      { "<leader>tw", function() require('gitsigns').toggle_word_diff() end,                                 desc = "Toggle word diff" },

      -- Text object
      { "ih",         function() require('gitsigns').select_hunk() end,                                      desc = "Select hunk",          mode = { "o", "x" } },
    },
  },
}
