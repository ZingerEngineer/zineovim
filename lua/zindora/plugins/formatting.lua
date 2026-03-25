-- ============================================================
--   Formatting — conform.nvim
--
--   Runs a formatter on the buffer when you save or press
--   <leader>f. conform.nvim tries formatters in order and
--   stops at the first one that succeeds (stop_after_first).
--
--   Formatter map:
--     Lua                → stylua
--     JS / TS / JSX / TSX → biome  (falls back to prettierd)
--     JSON / JSONC       → biome
--     CSS                → biome   (falls back to prettierd)
--     HTML               → prettierd  (biome doesn't support HTML yet)
--     SCSS / SASS        → prettierd
--     Vue                → prettierd  (biome doesn't support Vue yet)
--     Python             → ruff_format
--     Go                 → goimports  (formats + organises imports)
--     C / C++            → clang_format  (disabled on-save; use <leader>f)
--
--   Why biome over prettier for JS/TS?
--     • ~35× faster (written in Rust)
--     • Replaces both eslint AND prettier for the JS ecosystem
--     • Requires a biome.json in the project root.
--       If none is found, biome uses built-in defaults and
--       conform falls back to prettierd automatically.
-- ============================================================

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd   = { 'ConformInfo' },
  keys  = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer (or selection)',
    },
  },
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    notify_on_error = true,

    -- ── Format on save ────────────────────────────────────
    -- Runs synchronously on BufWritePre (before the file is written).
    -- C/C++ is excluded because clang-format is very opinionated
    -- and you may not always want it running automatically.
    -- Use <leader>f to format those manually.
    format_on_save = function(bufnr)
      local excluded = { c = true, cpp = true }
      if excluded[vim.bo[bufnr].filetype] then
        return nil
      end
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',  -- fall back to LSP if no formatter found
      }
    end,

    -- ── Formatters by filetype ────────────────────────────
    formatters_by_ft = {
      -- Lua
      lua = { 'stylua' },

      -- JavaScript ecosystem — try biome first, prettierd as fallback.
      -- `stop_after_first = true` means: run biome; if it exits with an
      -- error (e.g. no biome.json), try prettierd instead.
      javascript      = { 'biome', 'prettierd', stop_after_first = true },
      javascriptreact = { 'biome', 'prettierd', stop_after_first = true },
      typescript      = { 'biome', 'prettierd', stop_after_first = true },
      typescriptreact = { 'biome', 'prettierd', stop_after_first = true },

      -- Data formats — biome handles these well
      json  = { 'biome', 'prettierd', stop_after_first = true },
      jsonc = { 'biome', 'prettierd', stop_after_first = true },

      -- CSS — biome supports it, prettierd as fallback
      css = { 'biome', 'prettierd', stop_after_first = true },

      -- HTML — prettierd only (biome doesn't support HTML)
      html = { 'prettierd' },

      -- SCSS / SASS — prettierd only
      scss = { 'prettierd' },
      sass = { 'prettierd' },

      -- Vue — prettierd only (biome doesn't support .vue files)
      vue = { 'prettierd' },

      -- Angular templates are HTML
      htmlangular = { 'prettierd' },

      -- Python
      python = { 'ruff_format' },

      -- Go — goimports does everything gofmt does AND organises imports
      go = { 'goimports' },

      -- C / C++ — available via <leader>f, excluded from on-save above
      c   = { 'clang_format' },
      cpp = { 'clang_format' },
    },

    -- ── Custom formatter overrides ────────────────────────
    -- Tweak individual formatter behaviour here.
    formatters = {
      -- biome: pass --indent-style=space so it respects our 2-space
      -- indent even if there's no biome.json in the project.
      biome = {
        args = function(_, ctx)
          return {
            'format',
            '--indent-style=space',
            '--indent-width=2',
            '--stdin-file-path', ctx.filename,
          }
        end,
      },
    },
  },
}
