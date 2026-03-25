-- ============================================================
--   Linting — nvim-lint
--
--   Runs linters asynchronously and pushes their output into
--   Neovim's diagnostic system (the same place LSP errors go).
--   Results appear as underlines + gutter signs + virtual text.
--
--   Linter map:
--     JS / TS / JSX / TSX → biomejs   (lint rules + type-aware checks)
--     JSON / JSONC        → biomejs
--     CSS                 → biomejs
--     Python              → ruff      (fast, replaces flake8/pylint)
--     Markdown            → markdownlint_cli2
--
--   Note on biome + LSP overlap:
--     basedpyright handles Python type errors via LSP.
--     ruff catches style / lint violations (unused imports,
--     shadowed names, etc.) — they complement each other.
--
--     Similarly, ts_ls catches TypeScript type errors via LSP
--     while biomejs catches code quality issues (no-unused-vars,
--     no-console, etc.).
--
--   Trigger events:
--     BufEnter      → when you enter a buffer (first open)
--     BufWritePost  → after saving
--     InsertLeave   → when leaving insert mode
--     (NOT on every keystroke — that would be too slow)
-- ============================================================

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')

    -- ── Linters by filetype ───────────────────────────────
    lint.linters_by_ft = {
      -- JavaScript ecosystem
      javascript      = { 'biomejs' },
      javascriptreact = { 'biomejs' },
      typescript      = { 'biomejs' },
      typescriptreact = { 'biomejs' },
      json            = { 'biomejs' },
      jsonc           = { 'biomejs' },
      css             = { 'biomejs' },

      -- Python
      python = { 'ruff' },

      -- Markdown
      markdown = { 'markdownlint_cli2' },
    }

    -- ── Trigger autocmd ───────────────────────────────────
    -- Runs linting on the events listed above.
    -- The `modifiable` guard prevents running linters on
    -- read-only buffers like LSP hover windows or :help pages.
    local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

    vim.api.nvim_create_autocmd(
      { 'BufEnter', 'BufWritePost', 'InsertLeave' },
      {
        group    = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
        desc = 'Run linter on buffer events',
      }
    )

    -- ── Toggle linting keymap ────────────────────────────
    -- Useful when you want to silence lint noise temporarily
    -- (e.g. mid-refactor when the file is in a broken state).
    local lint_enabled = true
    vim.keymap.set('n', '<leader>tl', function()
      lint_enabled = not lint_enabled
      if lint_enabled then
        lint.try_lint()
        vim.notify('Linting enabled', vim.log.levels.INFO, { title = 'zindora' })
      else
        -- Clear all diagnostics from the lint namespace
        vim.diagnostic.reset(
          vim.api.nvim_create_namespace('vim_lint'),
          0
        )
        vim.notify('Linting disabled', vim.log.levels.WARN, { title = 'zindora' })
      end
    end, { desc = '[T]oggle [L]inting' })
  end,
}
