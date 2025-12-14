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
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      gitbrowse = { enable = true },
    },
    keys = {
      {
        "<leader>go",
        function()
          -- Check if current branch exists on remote, fallback to default branch if not
          local current_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")

          -- Check if branch exists on origin remote
          local remote_check = vim.fn.system("git ls-remote --heads origin " .. current_branch)
          local branch_exists_on_remote = remote_check ~= ""

          local opts = {
            notify = false,
            what = "file",
          }

          -- If branch doesn't exist on remote, use default branch instead
          if not branch_exists_on_remote then
            -- Auto-detect default branch
            local default_branch = nil

            -- Try to get default branch from symbolic-ref
            local symbolic_ref = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null"):gsub("%s+", "")
            if vim.v.shell_error == 0 and symbolic_ref ~= "" then
              -- Extract branch name from refs/remotes/origin/main -> main
              default_branch = symbolic_ref:match("refs/remotes/origin/(.+)")
            end

            -- Fallback: check if main or master exists on remote
            if not default_branch then
              local main_check = vim.fn.system("git ls-remote --heads origin main")
              if main_check ~= "" then
                default_branch = "main"
              else
                local master_check = vim.fn.system("git ls-remote --heads origin master")
                if master_check ~= "" then
                  default_branch = "master"
                end
              end
            end

            if default_branch then
              opts.branch = default_branch
              vim.notify(
                string.format("Branch '%s' not on remote, using '%s' instead", current_branch, default_branch),
                vim.log.levels.INFO
              )
            else
              vim.notify(
                string.format("Branch '%s' not on remote and couldn't detect default branch", current_branch),
                vim.log.levels.WARN
              )
            end
          end

          Snacks.gitbrowse.open(opts)
        end,
        desc = "Open in GitHub",
        mode = { "n", "v" }
      },
    },
  },
  { 'akinsho/git-conflict.nvim', version = "*", config = true }
}
