return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim", },
    config = function()
      local lspconfig = require("lspconfig")
      local schemas = require('schemastore')

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

      -- Configure biome with project-specific binary detection
      local biome_cmd = find_project_binary("biome")
      if biome_cmd then
        vim.lsp.config('biome', {
          cmd = { biome_cmd, "lsp-proxy" },
          root_dir = lspconfig.util.root_pattern("biome.json", "biome.jsonc"),
          single_file_support = false,
          on_attach = function(client, bufnr)
            -- Force enable formatting for biome since it should support it
            if client.name == "biome" then
              client.server_capabilities.documentFormattingProvider = true
              client.server_capabilities.documentRangeFormattingProvider = true
            end
          end,
        })
        vim.lsp.enable('biome')
      end

      -- Configure eslint with project-specific binary detection
      local eslint_cmd = find_project_binary("eslint")
      if eslint_cmd then
        vim.lsp.config('eslint', {
          cmd = { "vscode-eslint-language-server", "--stdio" },
          settings = {
            eslint = {
              nodePath = vim.fn.fnamemodify(eslint_cmd, ":h:h"), -- node_modules directory
            }
          },
          root_markers = { ".eslintrc.json", ".eslintrc.js", "eslint.config.json" },
          workspace_required = true,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              -- eslint uses a special command to format, boo
              command = "EslintFixAll",
            })
          end,
        })
        vim.lsp.enable('eslint')
      end

      vim.lsp.config('golangci_lint_ls', {})
      vim.lsp.enable('golangci_lint_ls')

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
      vim.lsp.enable('gopls')

      vim.lsp.config('jsonls', {
        settings = {
          json = {
            schemas = schemas.json.schemas(),
            validate = { enable = true },
          },
        },
      })
      vim.lsp.enable('jsonls')

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
      vim.lsp.enable('lua_ls')

      vim.lsp.config('ruby_lsp', {})
      vim.lsp.enable('ruby_lsp')

      vim.lsp.config('terraformls', {
        filetypes = { 'terraform', 'tf' }
      })
      vim.lsp.enable('terraformls')

      vim.lsp.config('tflint', {
        filetypes = { 'terraform', 'tf' },
      })
      vim.lsp.enable('tflint')

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
      vim.lsp.enable('yamlls')

      vim.lsp.config('ts_ls', {
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
        workspace_required = true,
        init_options = {
          preferences = {
            includeCompletionsForImportStatements = true,
            includeCompletionsWithSnippetText = true,
            includeAutomaticOptionalChainCompletions = true,
            includeCompletionsWithInsertText = true,
          }
        },
        on_attach = function(client, bufnr)
          -- Create a timer to defer the formatting capability check
          -- This ensures all LSP clients have attached before we decide
          vim.defer_fn(function()
            local formatter_active = false
            for _, c in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
              if c.name == "eslint" or c.name == "biome" then
                formatter_active = true
                break
              end
            end

            -- Disable ts_ls formatting only if eslint or biome is present
            if formatter_active then
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end
          end, 100) -- 100ms delay to allow other LSPs to attach
        end
      })
      vim.lsp.enable('ts_ls')
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
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
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
}
