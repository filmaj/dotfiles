return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load lazy.nvim and all plugins in data directory lazily on-demand
        { path = "lazy.nvim", words = { "Lazy" } },
        { path = vim.fn.stdpath("data") .. "/lazy", words = { "opts", "config", "setup" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim", "folke/lazydev.nvim" },
    config = function()
      local schemas = require('schemastore')

      -- Formatter Precedence Strategy:
      -- For TypeScript/JavaScript files, formatting is handled in this order:
      --   1. Biome (if biome.json/biome.jsonc exists) - fastest, handles both linting and formatting
      --   2. ESLint (if .eslintrc exists and Biome not present) - formatting via EslintFixAll
      --   3. TypeScript-tools explicitly disables formatting to avoid conflicts
      -- For other languages, native LSP formatting is used (gopls, ruby_lsp, etc.)

      -- Helper function to safely enable LSP with error handling
      local function safe_lsp_enable(server_name)
        local success, err = pcall(vim.lsp.enable, server_name)
        if not success then
          vim.notify(
            string.format("Failed to enable LSP server '%s': %s", server_name, err),
            vim.log.levels.ERROR
          )
        end
        return success
      end

      -- Helper function to find local project binary
      local function find_project_binary(binary_name)
        -- Check common local paths in order of preference
        local paths_to_check = {
          "./node_modules/.bin/" .. binary_name,
          "./.bin/" .. binary_name,
          "./bin/" .. binary_name,
        }

        for _, path in ipairs(paths_to_check) do
          if vim.fn.executable(path) == 1 then
            return vim.fn.fnamemodify(path, ":p") -- Return absolute path
          end
        end

        -- Fall back to system/Mason binary
        if vim.fn.executable(binary_name) == 1 then
          return binary_name
        end

        return nil
      end

      -- Configure biome with dynamic project-specific binary detection
      vim.lsp.config('biome', {
        -- Use a shell command to dynamically find biome per-project
        -- When LSP starts, cwd will be root_dir, so relative paths work correctly
        cmd = vim.fn.has('win32') == 1
            and { 'cmd.exe', '/C', 'node_modules\\.bin\\biome.cmd lsp-proxy || biome lsp-proxy' }
            or
            { 'sh', '-c',
              'if [ -x node_modules/.bin/biome ]; then exec node_modules/.bin/biome lsp-proxy; else exec biome lsp-proxy; fi' },
        root_markers = { 'biome.json', 'biome.jsonc' },
        single_file_support = false,
        on_attach = function(client, bufnr)
          -- Force enable formatting for biome since it should support it
          if client.name == "biome" then
            client.server_capabilities.documentFormattingProvider = true
            client.server_capabilities.documentRangeFormattingProvider = true
          end
        end,
      })
      safe_lsp_enable('biome')

      -- Configure eslint - language server will find eslint binary per-project
      -- The vscode-eslint-language-server is smart enough to locate eslint in the project's node_modules
      vim.lsp.config('eslint', {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        root_markers = { ".eslintrc.json", ".eslintrc.js", "eslint.config.json", ".eslintrc.cjs", "eslint.config.js", "eslint.config.mjs" },
        single_file_support = false,
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            -- eslint uses a special command to format, boo
            command = "EslintFixAll",
          })
        end,
      })
      safe_lsp_enable('eslint')

      vim.lsp.config('golangci_lint_ls', {})
      safe_lsp_enable('golangci_lint_ls')

      vim.lsp.config('gopls', {
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
              params.context = { only = { "source.organizeImports" } }
              -- buf_request_sync defaults to a 1000ms timeout. Depending on your
              -- machine and codebase, you may want longer. Add an additional
              -- argument after params if you find that you have to write the file
              -- twice for changes to be saved.
              -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
              local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
              for cid, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                  if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                  end
                end
              end
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      })
      safe_lsp_enable('gopls')

      vim.lsp.config('jsonls', {
        settings = {
          json = {
            schemas = schemas.json.schemas(),
            validate = { enable = true },
          },
        },
      })
      safe_lsp_enable('jsonls')

      vim.lsp.config('lua_ls', {
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
        on_new_config = function(config, root_dir)
          -- Don't start LSP in lazy plugin directories
          if root_dir:match("/lazy/") or root_dir:match("/site/pack/") then
            return false
          end
        end,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT'
            },
            diagnostics = {
              globals = { 'vim' }
            },
            workspace = {
              -- lazydev.nvim will dynamically add plugin libraries on-demand
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
            completion = {
              callSnippet = "Replace"
            },
          },
        },
      })
      safe_lsp_enable('lua_ls')

      vim.lsp.config('ruby_lsp', {})
      safe_lsp_enable('ruby_lsp')

      vim.lsp.config('terraformls', {
        filetypes = { 'terraform', 'tf' }
      })
      safe_lsp_enable('terraformls')

      vim.lsp.config('tflint', {
        filetypes = { 'terraform', 'tf' },
      })
      safe_lsp_enable('tflint')

      vim.lsp.config('yamlls', {
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
            schemas = schemas.yaml.schemas(),
          },
        },
      })
      safe_lsp_enable('yamlls')
    end,
  },
  {
    "williamboman/mason.nvim",
    tag = "v2.0.0",
    lazy = false,
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      },
    },
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { "folke/lazydev.nvim" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- Prioritize lazydev completions
          },
        },
      },
      keymap = {
        preset = 'enter',
      },
      cmdline = {
        keymap = { preset = 'inherit' },
        completion = {
          list = {
            selection = { preselect = false, auto_insert = false },
          },
          menu = { auto_show = true }
        },
      },
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
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      on_attach = function(client, bufnr)
        vim.keymap.set('n', '<leader>rf', "<cmd>TSToolsRenameFile<cr>", { desc = 'Rename file' })
        -- Disable formatting to let biome/eslint handle it (see Formatter Precedence Strategy above)
        -- TypeScript-tools provides LSP features (completions, diagnostics) but not formatting
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end
    },
  },
}
