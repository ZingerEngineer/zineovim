-- ============================================================
--   Completion — blink.cmp + LuaSnip + Copilot source
--
--   blink.cmp is faster than nvim-cmp (written in Rust for
--   the fuzzy matching core) and has first-class snippet and
--   LSP support out of the box.
--
--   Sources used (shown in completion menu):
--     lsp       → language server completions
--     copilot   → GitHub Copilot (via blink-cmp-copilot)
--     snippets  → LuaSnip snippet expansions
--     path      → file system paths
--
--   Key bindings:
--     <Tab>       → accept ghost-text (copilot.lua handles this)
--                   OR move to next snippet placeholder
--     <C-y>       → accept the selected completion item
--     <C-n>/<C-p> → next / previous item in the menu
--     <C-b>/<C-f> → scroll documentation window
--     <C-Space>   → force open / show documentation
--     <C-e>       → close the menu
--     <C-k>       → toggle signature help
-- ============================================================

return {
  'saghen/blink.cmp',
  event        = 'VimEnter',
  version      = '1.*',
  dependencies = {
    -- Snippet engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      -- Build regex support for snippets (requires `make`)
      build = (function()
        if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      opts = {},
    },
    -- Copilot completion source for blink.cmp
    'giuxtaposition/blink-cmp-copilot',
    -- copilot.lua must be loaded so the source can query it
    'zbirenbaum/copilot.lua',
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- ── Keymap ─────────────────────────────────────────────
    -- 'default' preset: standard Vim insert-mode completion keys.
    -- We keep Tab free for Copilot ghost-text acceptance and only
    -- use it here for moving between snippet placeholders.
    keymap = {
      preset = 'default',
      -- Override Tab / S-Tab to navigate snippet placeholders only
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          end
        end,
        'fallback',  -- falls through to copilot.lua's <Tab> binding
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },

    -- ── Appearance ─────────────────────────────────────────
    appearance = {
      nerd_font_variant = 'mono',
      -- Kind icons shown next to each completion item
      kind_icons = {
        Text          = '󰉿',
        Method        = '󰆧',
        Function      = '󰊕',
        Constructor   = '',
        Field         = '󰜢',
        Variable      = '󰀫',
        Class         = '󰠱',
        Interface     = '',
        Module        = '',
        Property      = '󰜢',
        Unit          = '󰑭',
        Value         = '󰎠',
        Enum          = '',
        Keyword       = '󰌋',
        Snippet       = '',
        Color         = '󰏘',
        File          = '󰈙',
        Reference     = '󰈇',
        Folder        = '󰉋',
        EnumMember    = '',
        Constant      = '󰏿',
        Struct        = '󰙅',
        Event         = '',
        Operator      = '󰆕',
        TypeParameter = '',
        Copilot       = '',
      },
    },

    -- ── Completion menu ────────────────────────────────────
    completion = {
      -- Show documentation automatically after a short delay
      documentation = {
        auto_show          = true,
        auto_show_delay_ms = 200,
        window = { border = 'rounded' },
      },
      menu = {
        border = 'rounded',
        draw = {
          -- Column layout: icon + label | kind | source
          columns = {
            { 'kind_icon', gap = 1 },
            { 'label', 'label_description', gap = 1 },
            { 'kind', gap = 1 },
            { 'source_name' },
          },
          components = {
            -- Colour the source name so Copilot stands out
            source_name = {
              text = function(ctx)
                local map = {
                  LSP     = '[LSP]',
                  Copilot = '[Copilot]',
                  Snippets = '[Snip]',
                  Path    = '[Path]',
                }
                return map[ctx.source_name] or ('[' .. ctx.source_name .. ']')
              end,
            },
          },
        },
      },
    },

    -- ── Sources ────────────────────────────────────────────
    sources = {
      -- Load order also affects default priority
      default = { 'lsp', 'copilot', 'snippets', 'path' },

      providers = {
        copilot = {
          name        = 'copilot',
          module      = 'blink-cmp-copilot',
          score_offset = 90,   -- appear near the top but below LSP exact matches
          async       = true,
        },
        lsp = {
          score_offset = 100,
        },
      },
    },

    -- ── Snippets ───────────────────────────────────────────
    snippets = { preset = 'luasnip' },

    -- ── Fuzzy matching ────────────────────────────────────
    -- Use the Lua implementation; switch to 'prefer_rust_with_warning'
    -- if you want the optional Rust-based faster matcher.
    fuzzy = { implementation = 'lua' },

    -- ── Signature help ────────────────────────────────────
    signature = {
      enabled = true,
      window  = { border = 'rounded' },
    },
  },
}
