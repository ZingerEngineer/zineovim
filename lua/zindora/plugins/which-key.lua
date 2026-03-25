-- ============================================================
--   which-key — keybind hint popup
--
--   After pressing a prefix key (e.g. <leader>) and pausing,
--   which-key shows a popup listing all available continuations.
--   It also lets us attach human-readable group names to
--   prefixes so the popup is organised, not just a flat list.
--
--   We register ALL leader groups here — even for plugins not
--   yet installed — so the popup always shows the full map.
-- ============================================================

return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  ---@module 'which-key'
  ---@type wk.Opts
  opts = {
    -- How long to wait after a prefix before showing the popup.
    -- 0 = show immediately; raise if you find it distracting.
    delay = 400,

    icons = {
      mappings = vim.g.have_nerd_font,
      keys = vim.g.have_nerd_font and {} or {
        Up    = '<Up> ', Down  = '<Down> ',
        Left  = '<Left> ', Right = '<Right> ',
        C     = '<C-…>', M = '<M-…>', S = '<S-…>',
        CR    = '<CR> ', Esc = '<Esc> ',
        BS    = '<BS> ', Tab = '<Tab> ',
        Space = '<Space> ',
      },
    },

    spec = {
      -- ── Buffer ───────────────────────────────────────────
      { '<leader>b',  group = 'Buffers',                 icon = '󰓩' },
      { '<leader>bd', desc  = 'Delete buffer' },
      { '<leader>bD', desc  = 'Force delete buffer' },
      { '<leader>bp', desc  = 'Pick buffer' },
      { '<leader>bc', desc  = 'Pick buffer to close' },

      -- ── Diagnostics ──────────────────────────────────────
      { '<leader>d',  group = 'Diagnostics',             icon = '' },
      { '<leader>dd', desc  = 'Show diagnostic float' },
      { '<leader>dq', desc  = 'Diagnostics → quickfix' },

      -- ── Explorer ─────────────────────────────────────────
      { '<leader>e',  desc  = 'Toggle file explorer',   icon = '' },
      { '<leader>E',  desc  = 'Reveal file in explorer' },

      -- ── Format ───────────────────────────────────────────
      { '<leader>f',  desc  = 'Format buffer',          icon = '󰉿' },

      -- ── Git ──────────────────────────────────────────────
      { '<leader>g',  group = 'Git',                        icon = '' },
      { '<leader>gg', desc  = 'Open Neogit (git UI)' },
      { '<leader>gc', desc  = 'Git commit' },
      { '<leader>gP', desc  = 'Git push' },
      { '<leader>gl', desc  = 'Git pull' },
      { '<leader>gd', desc  = 'Toggle Diffview (current changes)' },
      { '<leader>gh', desc  = 'Git file history' },
      { '<leader>gH', desc  = 'Git project history' },
      { '<leader>gx', desc  = 'Close Diffview' },
      { '<leader>gb', desc  = 'Blame line (float)' },
      { '<leader>gp', desc  = 'Preview hunk' },
      { '<leader>gs', desc  = 'Stage hunk' },
      { '<leader>gr', desc  = 'Reset hunk' },
      { '<leader>gS', desc  = 'Stage buffer' },
      { '<leader>gR', desc  = 'Reset buffer' },
      { '<leader>gu', desc  = 'Undo stage hunk' },

      -- ── Search (telescope) ───────────────────────────────
      { '<leader>s',  group = 'Search',                 icon = '' },
      { '<leader>sf', desc  = 'Find files' },
      { '<leader>sg', desc  = 'Grep in project' },
      { '<leader>sw', desc  = 'Grep current word' },
      { '<leader>sb', desc  = 'Search in buffer' },
      { '<leader>sh', desc  = 'Search help tags' },
      { '<leader>sk', desc  = 'Search keymaps' },
      { '<leader>sr', desc  = 'Resume last search' },
      { '<leader>sd', desc  = 'Search diagnostics' },
      { '<leader>sn', desc  = 'Search nvim config files' },

      -- ── Toggle ───────────────────────────────────────────
      { '<leader>t',  group = 'Toggle',                 icon = '' },
      { '<leader>th', desc  = 'Toggle inlay hints' },
      { '<leader>tb', desc  = 'Toggle inline git blame' },
      { '<leader>tw', desc  = 'Toggle word diff' },
      { '<leader>tl', desc  = 'Toggle linting' },

      -- ── Windows / splits ─────────────────────────────────
      { '<leader>w',  group = 'Windows',                icon = '󱂬' },
      { '<leader>wv', desc  = 'Split vertical' },
      { '<leader>wh', desc  = 'Split horizontal' },
      { '<leader>we', desc  = 'Equalize splits' },
      { '<leader>wx', desc  = 'Close split' },

      -- ── Quickfix ─────────────────────────────────────────
      { '<leader>c',  group = 'Quickfix',               icon = '' },
      { '<leader>co', desc  = 'Open quickfix list' },
      { '<leader>cc', desc  = 'Close quickfix list' },

      -- ── LSP (gr prefix, built-in nvim 0.10+) ────────────
      { 'gr',         group = 'LSP Actions',            icon = '󰒋' },
      { 'grn',        desc  = 'Rename symbol' },
      { 'gra',        desc  = 'Code action' },
      { 'grr',        desc  = 'References' },
      { 'grd',        desc  = 'Definition' },
      { 'gri',        desc  = 'Implementation' },
      { 'grt',        desc  = 'Type definition' },
      { 'grD',        desc  = 'Declaration' },

      -- ── Buffer jump by number ────────────────────────────
      { '<leader>1',  desc  = 'Buffer 1' },
      { '<leader>2',  desc  = 'Buffer 2' },
      { '<leader>3',  desc  = 'Buffer 3' },
      { '<leader>4',  desc  = 'Buffer 4' },
      { '<leader>5',  desc  = 'Buffer 5' },
      { '<leader>6',  desc  = 'Buffer 6' },
      { '<leader>7',  desc  = 'Buffer 7' },
      { '<leader>8',  desc  = 'Buffer 8' },
      { '<leader>9',  desc  = 'Buffer 9' },
    },
  },
}
