return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buffer)
        -- easly close diffview with q
        vim.keymap.set("n", "q", function()
          local has_diff = vim.wo.diff
          local target_win

          if not has_diff then
            return "q"
          end

          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local buf = vim.api.nvim_win_get_buf(win)
            local bufname = vim.api.nvim_buf_get_name(buf)
            if bufname:find("^gitsigns://") then
              target_win = win
              break
            end
          end
          if target_win then
            vim.schedule(function()
              vim.api.nvim_win_close(target_win, true)
            end)
            return ""
          end

          return "q"
        end, { expr = true, silent = true })
      end,
    },
    keys = {
      -- Navigation
      {
        "]c",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            require('gitsigns').nav_hunk('next', { navigation_message = false })
          end
        end,
        desc = "Go to next git change"
      },
      {
        "[c",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            require('gitsigns').nav_hunk('prev', { navigation_message = false })
          end
        end,
        desc = "Go to previous git change"
      },

      -- Git operations (gh* namespace - git hunk)
      { "<leader>gsh", function() require('gitsigns').stage_hunk() end,                                       desc = "Git stage hunk",           mode = "n" },
      { "<leader>grh", function() require('gitsigns').reset_hunk() end,                                       desc = "Git reset hunk",           mode = "n" },
      { "<leader>gsh", function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = "Git stage hunk",           mode = "v" },
      { "<leader>grh", function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = "Git reset hunk",           mode = "v" },
      { "<leader>gsb", function() require('gitsigns').stage_buffer() end,                                     desc = "Git stage buffer" },
      { "<leader>grb", function() require('gitsigns').reset_buffer() end,                                     desc = "Git reset buffer" },
      { "<leader>gph", function() require('gitsigns').preview_hunk() end,                                     desc = "Git preview hunk" },
      { "<leader>gpi", function() require('gitsigns').preview_hunk_inline() end,                              desc = "Git preview hunk inline" },
      { "<leader>gb",  function() require('gitsigns').blame_line({ full = true }) end,                        desc = "Git blame line" },
      { "<leader>gd",  function() require('gitsigns').diffthis() end,                                         desc = "Git diff this" },
      { "<leader>gD",  function() require('gitsigns').diffthis('~') end,                                      desc = "Git diff this ~" },
      { "<leader>ghQ", function() require('gitsigns').setqflist('all') end,                                   desc = "Git all hunks to quickfix" },
      { "<leader>ghq", function() require('gitsigns').setqflist() end,                                        desc = "Git hunks to quickfix" },

      -- Toggle operations (t* namespace)
      { "<leader>gtb", function() require('gitsigns').toggle_current_line_blame() end,                        desc = "Toggle git blame line" },
      { "<leader>gtw", function() require('gitsigns').toggle_word_diff() end,                                 desc = "Toggle git word diff" },

      -- Text object
      { "ih",          function() require('gitsigns').select_hunk() end,                                      desc = "Select hunk",              mode = { "o", "x" } },
    },
  },
}
