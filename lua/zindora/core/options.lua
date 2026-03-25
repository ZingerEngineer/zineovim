-- ============================================================
--   Editor options
--
--   IMPORTANT: vim.g.mapleader must be set before lazy.nvim
--   loads plugins, because plugins register <leader> keymaps
--   at load time. That's why this file is required first in
--   init.lua before require('zindora.lazy').
-- ============================================================

-- Leader keys
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- Tell plugins (and our own config) that a Nerd Font is available.
-- Set to false if your terminal font doesn't support Nerd Font glyphs.
vim.g.have_nerd_font = true

local opt = vim.opt

-- ── Line numbers ─────────────────────────────────────────────
opt.number         = true   -- absolute line number on the current line
opt.relativenumber = true   -- relative numbers on all other lines (fast j/k jumping)

-- ── Tabs & indentation ───────────────────────────────────────
opt.tabstop     = 2     -- a <Tab> displays as 2 columns
opt.shiftwidth  = 2     -- >> / << shift by 2 columns
opt.expandtab   = true  -- insert spaces instead of a real Tab character
opt.autoindent  = true  -- copy indent from previous line on <Enter>
opt.smartindent = true  -- add an extra indent after {, (, etc.

-- ── Line wrapping ────────────────────────────────────────────
-- Disabled globally; enabled per-filetype in autocmds for markdown / prose.
opt.wrap = false

-- ── Search ───────────────────────────────────────────────────
opt.ignorecase = true  -- /foo matches Foo, FOO, foo
opt.smartcase  = true  -- /Foo only matches Foo (capital → case-sensitive)
opt.hlsearch   = true  -- highlight all matches while typing
opt.incsearch  = true  -- jump to first match as you type

-- ── Appearance ───────────────────────────────────────────────
opt.termguicolors = true       -- 24-bit RGB color (required by most themes)
opt.background    = 'dark'
opt.signcolumn    = 'yes'      -- always show the gutter; avoids layout shift when LSP adds signs
opt.cursorline    = true       -- highlight the entire line the cursor is on
opt.showmode      = false      -- mode is shown in lualine; no need for the echo line
opt.scrolloff     = 8          -- keep 8 lines visible above/below the cursor
opt.sidescrolloff = 8          -- keep 8 columns visible left/right of the cursor
opt.colorcolumn   = '120'      -- soft guide at column 120 (matches stylua width)

-- Whitespace visualization (tabs, trailing spaces, non-breaking spaces)
opt.list      = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- ── Splits ───────────────────────────────────────────────────
opt.splitright = true   -- vertical split opens to the right
opt.splitbelow = true   -- horizontal split opens below

-- ── Files & undo ─────────────────────────────────────────────
opt.undofile = true    -- persist undo history across sessions (~/.local/state/nvim/undo/)
opt.swapfile = false   -- no .swp files; undo history + git is enough
opt.backup   = false   -- no ~ backup files
opt.autoread = true    -- reload the buffer automatically when the file changes on disk
                       -- (the actual polling is done by autocommands in autocmds.lua)

-- ── Timing ───────────────────────────────────────────────────
opt.updatetime  = 250   -- ms before CursorHold fires (used by LSP document highlights)
opt.timeoutlen  = 300   -- ms to wait for the next key in a mapped sequence (which-key window)

-- ── Completion ───────────────────────────────────────────────
-- blink.cmp overrides this, but set a sane default anyway.
opt.completeopt = 'menu,menuone,noselect'

-- ── Folding ──────────────────────────────────────────────────
-- Start with all folds open. Treesitter will upgrade this to
-- expr-based folding once nvim-treesitter is loaded.
opt.foldmethod = 'indent'
opt.foldlevel  = 99

-- ── Misc ─────────────────────────────────────────────────────
opt.mouse      = 'a'              -- enable mouse in all modes (useful for resizing splits)
opt.clipboard  = 'unnamedplus'    -- sync yank/paste with the system clipboard
opt.confirm    = true             -- ask to save instead of erroring on :q with unsaved changes
opt.inccommand = 'split'          -- live preview of :s substitutions in a split window
opt.breakindent = true            -- wrapped lines preserve their indentation

-- ── Diagnostics ──────────────────────────────────────────────
-- Centralised here so it's easy to adjust without hunting through plugin files.
vim.diagnostic.config({
  update_in_insert = false,     -- don't flicker diagnostics while typing
  severity_sort    = true,      -- show errors before warnings before hints
  float            = { border = 'rounded', source = 'if_many' },
  underline        = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text     = true,      -- inline text at end of line
  virtual_lines    = false,     -- (alternative) text below the line — off by default
  jump             = { float = true },  -- auto-open float when jumping to a diagnostic
})
