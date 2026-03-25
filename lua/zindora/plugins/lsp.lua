-- ============================================================
--   LSP — Language Server Protocol
--
--   Stack:
--     mason.nvim             → GUI installer for LSP servers,
--                              formatters, and linters
--     mason-lspconfig.nvim   → bridges Mason ↔ nvim-lspconfig
--     mason-tool-installer   → ensures formatters/linters are
--                              installed alongside LSP servers
--     nvim-lspconfig         → per-server default configs
--                              (cmd, root patterns, filetypes…)
--     fidget.nvim            → LSP progress spinner (bottom-right)
--
--   How it works at runtime:
--     1. Mason ensures every server in `servers` is installed.
--     2. For each server we call lspconfig[name].setup(config).
--     3. lspconfig watches for files of matching filetypes and
--        starts the server the first time you open one.
--     4. When the server connects, the LspAttach autocommand
--        below fires and registers buffer-local keymaps.
-- ============================================================

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Mason must be set up before mason-lspconfig
    { 'mason-org/mason.nvim', opts = { ui = { border = 'rounded' } } },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- LSP progress indicator in the bottom-right corner
    { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },
  },
  config = function()
    -- ── Capabilities ───────────────────────────────────────
    -- Start with Neovim's built-in capabilities and then let
    -- blink.cmp upgrade them with completion-item extras
    -- (snippets, labelDetails, resolve support, etc.).
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, blink = pcall(require, 'blink.cmp')
    if ok then
      capabilities = blink.get_lsp_capabilities(capabilities)
    end

    -- ── LspAttach — per-buffer keymaps ─────────────────────
    -- This autocommand fires every time a language server
    -- successfully attaches to a buffer. Keymaps registered
    -- here are buffer-local so they only work in that buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('zindora-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or 'n', keys, func, {
            buffer = event.buf,
            desc   = 'LSP: ' .. desc,
          })
        end

        -- Navigation
        map('grd', vim.lsp.buf.definition,     '[G]oto [D]efinition')
        map('grD', vim.lsp.buf.declaration,    '[G]oto [D]eclaration')
        map('gri', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        map('grt', vim.lsp.buf.type_definition,'[G]oto [T]ype definition')
        map('grr', vim.lsp.buf.references,     '[G]oto [R]eferences')

        -- Code actions
        map('grn', vim.lsp.buf.rename,       '[R]e[n]ame symbol')
        map('gra', vim.lsp.buf.code_action,  '[G]oto Code [A]ction', { 'n', 'x' })

        -- Documentation
        map('K',      vim.lsp.buf.hover,          'Hover documentation')
        map('<C-k>',  vim.lsp.buf.signature_help, 'Signature help', 'i')

        -- Symbols
        map('gO', vim.lsp.buf.document_symbol,  'Document symbols')
        map('gW', vim.lsp.buf.workspace_symbol, 'Workspace symbols')

        -- Inlay hints toggle (only if the server supports them)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
              { bufnr = event.buf }
            )
          end, '[T]oggle Inlay [H]ints')
        end

        -- Highlight symbol under cursor while it rests there.
        -- Cleared when the cursor moves.
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local hl_group = vim.api.nvim_create_augroup('zindora-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group  = hl_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer   = event.buf,
            group    = hl_group,
            callback = vim.lsp.buf.clear_references,
          })
          -- Clean up when the server detaches
          vim.api.nvim_create_autocmd('LspDetach', {
            buffer = event.buf,
            group  = vim.api.nvim_create_augroup('zindora-lsp-detach', { clear = true }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = 'zindora-lsp-highlight', buffer = ev.buf })
            end,
          })
        end
      end,
    })

    -- ── Server configurations ───────────────────────────────
    -- Each key is the lspconfig server name.
    -- The value is the table passed to lspconfig[name].setup().
    -- An empty table {} means "use lspconfig defaults".
    ---@type table<string, table>
    local servers = {

      -- ── Web ─────────────────────────────────────────────
      html = {},

      cssls = {
        settings = {
          css  = { validate = true, lint = { unknownAtRules = 'ignore' } },
          scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
          less = { validate = true },
        },
      },

      -- TypeScript / JavaScript (handles .ts .tsx .js .jsx)
      ts_ls = {
        filetypes = {
          'javascript', 'javascriptreact',
          'typescript', 'typescriptreact',
        },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints         = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints          = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints  = true,
              includeInlayEnumMemberValueHints         = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints         = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints          = true,
            },
          },
        },
      },

      -- Vue 3 — handles .vue files only.
      -- ts_ls handles the TypeScript side; volar handles the template/script.
      volar = {
        filetypes    = { 'vue' },
        init_options = { vue = { hybridMode = false } },
      },

      -- Angular — needs the project's node_modules to find @angular/language-server
      angularls = {
        filetypes = { 'typescript', 'html', 'typescriptreact' },
        on_new_config = function(new_config, new_root_dir)
          local node_modules = new_root_dir .. '/node_modules'
          new_config.cmd = {
            'ngserver', '--stdio',
            '--tsProbeLocations',  node_modules,
            '--ngProbeLocations',  node_modules,
          }
        end,
      },

      -- Emmet — HTML/CSS/JSX tag expansion
      emmet_ls = {
        filetypes = {
          'html', 'css', 'scss', 'sass', 'less',
          'javascript', 'javascriptreact',
          'typescript', 'typescriptreact',
          'vue',
        },
      },

      -- Tailwind CSS — class name completions and hover docs
      tailwindcss = {
        filetypes = {
          'html', 'css', 'scss',
          'javascript', 'javascriptreact',
          'typescript', 'typescriptreact',
          'vue',
        },
      },

      -- ── Python ──────────────────────────────────────────
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths       = true,
              diagnosticMode        = 'openFilesOnly',
              useLibraryCodeForTypes = true,
              typeCheckingMode      = 'standard',
            },
          },
        },
      },

      -- ── Go (only when Go is installed on this machine) ──
      gopls = vim.fn.executable('go') == 1 and {
        settings = {
          gopls = {
            analyses   = { unusedparams = true, shadow = true },
            staticcheck = true,
            gofumpt    = true,
            hints = {
              assignVariableTypes    = true,
              compositeLiteralFields = true,
              compositeLiteralTypes  = true,
              constantValues         = true,
              functionTypeParameters = true,
              parameterNames         = true,
              rangeVariableTypes     = true,
            },
          },
        },
      } or nil,

      -- ── C / C++ ─────────────────────────────────────────
      clangd = {
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--completion-style=detailed',
          '--function-arg-placeholders',
        },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
      },

      -- ── Lua ─────────────────────────────────────────────
      lua_ls = {
        -- on_init: teach lua_ls about Neovim's Lua runtime so it
        -- can resolve `vim.*` without showing "undefined global" errors.
        -- Only applies inside this Neovim config directory; if the
        -- project has its own .luarc.json we leave it alone.
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config')
              and (vim.uv.fs_stat(path .. '/.luarc.json')
                or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end
          client.config.settings.Lua = vim.tbl_deep_extend(
            'force',
            client.config.settings.Lua or {},
            {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                },
              },
            }
          )
        end,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            telemetry   = { enable = false },
          },
        },
      },
    }

    -- ── Mason: ensure servers are installed ────────────────
    require('mason-lspconfig').setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    -- mason-tool-installer: ensure formatters/linters are installed.
    -- (These are used by conform.nvim and nvim-lint in Phase 4.)
    local tools = {
      'stylua',            -- Lua formatter
      'biome',             -- JS / TS / JSX / TSX / JSON / CSS formatter + linter
      'prettierd',         -- HTML formatter (biome doesn't support HTML yet)
      'clang-format',      -- C / C++ formatter
      'markdownlint-cli2', -- Markdown linter
    }
    -- goimports requires Go — only install it when Go is available
    if vim.fn.executable('go') == 1 then
      table.insert(tools, 'goimports')
    end
    require('mason-tool-installer').setup({ ensure_installed = tools })

    -- ── Register all servers with the new vim.lsp API ─────
    -- nvim-lspconfig v3 + Neovim 0.11 use vim.lsp.config / vim.lsp.enable
    -- instead of require('lspconfig')[server].setup().
    -- lspconfig still ships default cmd/filetypes/root_patterns for each
    -- server — vim.lsp.config() merges our overrides on top of those defaults.
    for name, config in pairs(servers) do
      config.capabilities = capabilities
      vim.lsp.config(name, config)
    end
    vim.lsp.enable(vim.tbl_keys(servers))
  end,
}
