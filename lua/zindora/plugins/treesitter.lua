-- ============================================================
--   Treesitter — concrete syntax trees for every language
--
--   What treesitter gives you vs the old regex highlighting:
--     • Accurate, context-aware syntax highlighting
--       (a string inside a template literal is coloured
--        differently from a keyword — regex can't do that)
--     • Correct indentation for deeply nested structures
--     • Structural selections (expand/shrink by AST node)
--     • The foundation that LSP, indent-blankline, and
--       many other plugins build on
--
--   We use the `main` branch of nvim-treesitter which uses
--   the new native Neovim treesitter API directly:
--     - require('nvim-treesitter').install() → downloads parsers
--     - vim.treesitter.start()              → activates highlighting
--     - nvim-treesitter.indentexpr()        → smart indentation
-- ============================================================

return {
  'nvim-treesitter/nvim-treesitter',
  lazy  = false,
  build = ':TSUpdate',
  branch = 'main',
  config = function()

    -- ── Parsers to install ────────────────────────────────
    -- These cover every language in your tech stack plus
    -- common config / markup formats you'll encounter.
    local parsers = {
      -- Web core
      'html', 'css', 'scss',

      -- JavaScript ecosystem
      'javascript', 'typescript', 'tsx',
      'jsdoc',

      -- Frameworks
      'vue', 'angular',

      -- Python
      'python',

      -- Go
      'go', 'gomod', 'gosum', 'gowork',

      -- Systems
      'c', 'cpp',

      -- Lua (for editing this config)
      'lua', 'luadoc',

      -- Data / config formats
      'json', 'jsonc', 'yaml', 'toml',

      -- Markup
      'markdown', 'markdown_inline',

      -- Shell
      'bash',

      -- Git
      'gitignore', 'gitcommit', 'diff',

      -- Regex (highlighted inside strings)
      'regex',

      -- Vim / Neovim
      'vim', 'vimdoc', 'query',
    }

    require('nvim-treesitter').install(parsers)

    -- ── Per-buffer activation ─────────────────────────────
    -- The new main-branch API activates highlighting and
    -- indentation per-buffer via a FileType autocmd rather
    -- than a global enable flag.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-attach', { clear = true }),
      callback = function(args)
        local buf      = args.buf
        local filetype = args.match

        -- Map filetype → treesitter language name
        -- (e.g. "javascript.jsx" → "javascript")
        local language = vim.treesitter.language.get_lang(filetype)
        if not language then return end

        -- Only activate if the parser is actually installed
        if not vim.treesitter.language.add(language) then return end

        -- Activate syntax highlighting
        vim.treesitter.start(buf, language)

        -- Activate treesitter-based indentation.
        -- Falls back to vim's built-in indent if treesitter
        -- can't figure out the indent for a given line.
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
      desc = 'Activate treesitter highlighting + indentation per buffer',
    })

    -- ── Folding (opt-in per window) ───────────────────────
    -- Treesitter-based folding is more accurate than indent-based
    -- folding, but can be slow on very large files.
    -- Uncomment to enable globally, or toggle per-buffer with:
    --   :set foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()
    --
    -- vim.o.foldmethod = 'expr'
    -- vim.o.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
  end,
}
