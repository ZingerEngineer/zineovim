-- ============================================================
--   Git integration — three layers
--
--   gitsigns.nvim   → line-level: gutter signs, inline blame,
--                     stage/reset individual hunks
--
--   neogit          → project-level: status, commit, push/pull,
--                     branch management (think: Magit for Neovim)
--
--   diffview.nvim   → visual: side-by-side diffs and file
--                     history tree — the "collapsible right pane"
--                     equivalent to the VSCode source control view
--
--   Key layout:
--     <leader>gg   → open Neogit (full git UI)
--     <leader>gd   → toggle Diffview (changed files + diff)
--     <leader>gh   → file history in Diffview
--     <leader>gb   → blame current line (float)
--     <leader>gp   → preview hunk inline
--     <leader>gs   → stage hunk
--     <leader>gr   → reset hunk
--     <leader>gS   → stage entire buffer
--     <leader>gR   → reset entire buffer
--     <leader>tb   → toggle inline git blame on current line
--     ]c / [c      → jump to next / previous hunk
-- ============================================================

-- ── gitsigns ─────────────────────────────────────────────────
local gitsigns = {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts  = {
    signs = {
      add          = { text = '▎' },
      change       = { text = '▎' },
      delete       = { text = '' },
      topdelete    = { text = '' },
      changedelete = { text = '▎' },
      untracked    = { text = '▎' },
    },
    signs_staged = {
      add          = { text = '▎' },
      change       = { text = '▎' },
      delete       = { text = '' },
      topdelete    = { text = '' },
      changedelete = { text = '▎' },
    },
    signs_staged_enable = true,
    signcolumn          = true,
    numhl               = false,
    linehl              = false,
    word_diff           = false,

    current_line_blame       = false, -- toggle with <leader>tb
    current_line_blame_opts  = {
      virt_text         = true,
      virt_text_pos     = 'eol',
      delay             = 500,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = ' <author>, <author_time:%d/%m/%Y> · <summary>',

    on_attach = function(bufnr)
      local gs  = require('gitsigns')
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- ── Hunk navigation ───────────────────────────────
      -- ]c / [c jump to the next / previous changed hunk.
      -- When in a diff buffer (e.g. fugitive), fall back to
      -- Vim's built-in ]c / [c behaviour.
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, 'Next git hunk')

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, 'Previous git hunk')

      -- ── Staging ───────────────────────────────────────
      -- Stage / reset work on the visual selection in visual mode,
      -- or on the hunk under the cursor in normal mode.
      map({ 'n', 'v' }, '<leader>gs', gs.stage_hunk,  'Git stage hunk')
      map({ 'n', 'v' }, '<leader>gr', gs.reset_hunk,  'Git reset hunk')
      map('n', '<leader>gS', gs.stage_buffer,          'Git stage buffer')
      map('n', '<leader>gR', gs.reset_buffer,          'Git reset buffer')
      map('n', '<leader>gu', gs.undo_stage_hunk,       'Git undo stage hunk')

      -- ── Inspection ───────────────────────────────────
      map('n', '<leader>gp', gs.preview_hunk,          'Git preview hunk')
      map('n', '<leader>gb', gs.blame_line,            'Git blame line (float)')

      -- ── Toggles ───────────────────────────────────────
      map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle inline git blame')
      map('n', '<leader>tw', gs.toggle_word_diff,          'Toggle word diff')
    end,
  },
}

-- ── neogit ───────────────────────────────────────────────────
local neogit = {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',   -- neogit uses diffview for its diff view
    'nvim-telescope/telescope.nvim',
  },
  cmd  = 'Neogit',
  keys = {
    {
      '<leader>gg',
      function() require('neogit').open() end,
      desc = 'Open Neogit',
    },
    {
      '<leader>gc',
      function() require('neogit').open({ 'commit' }) end,
      desc = 'Git commit',
    },
    {
      '<leader>gP',
      function() require('neogit').open({ 'push' }) end,
      desc = 'Git push',
    },
    {
      '<leader>gl',
      function() require('neogit').open({ 'pull' }) end,
      desc = 'Git pull',
    },
  },
  opts = {
    -- Open neogit in a full-screen tab so it doesn't fight with
    -- your editor splits. Press q inside neogit to close the tab.
    kind = 'tab',

    -- Use diffview.nvim for diffs inside neogit (richer UI)
    integrations = {
      diffview  = true,
      telescope = true,
    },

    -- Graph style for the log view
    graph_style = 'unicode',

    -- Signs in the neogit status buffer
    signs = {
      hunk   = { '', '' },
      item   = { '>', 'v' },
      section = { '>', 'v' },
    },

    commit_editor = {
      kind          = 'tab',
      show_staged_diff = true,
    },

    commit_select_view = { kind = 'tab' },
    log_view           = { kind = 'tab' },
    rebase_editor      = { kind = 'tab' },
    reflog_view        = { kind = 'tab' },
    merge_editor       = { kind = 'tab' },
    tag_editor         = { kind = 'tab' },
    preview_buffer     = { kind = 'split' },
    popup              = { kind = 'split' },

    -- Sections shown in the status buffer (order = display order)
    sections = {
      untracked   = { folded = false, hidden = false },
      unstaged    = { folded = false, hidden = false },
      staged      = { folded = false, hidden = false },
      stashes     = { folded = true  },
      unpulled_upstream  = { folded = true },
      unmerged_upstream  = { folded = false },
      unpulled_pushRemote = { folded = true },
      unmerged_pushRemote = { folded = false },
      recent      = { folded = true },
      rebase      = { folded = true, hidden = false },
    },
  },
}

-- ── diffview ─────────────────────────────────────────────────
local diffview = {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd  = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles' },
  keys = {
    -- Toggle: open diffview if closed, close it if open.
    -- This is the "collapsible pane" behaviour the user wants.
    {
      '<leader>gd',
      function()
        local lib = require('diffview.lib')
        if next(lib.views) then
          vim.cmd('DiffviewClose')
        else
          vim.cmd('DiffviewOpen')
        end
      end,
      desc = 'Toggle Diffview (current changes)',
    },
    -- File history for the current file (log + per-commit diff)
    {
      '<leader>gh',
      '<cmd>DiffviewFileHistory %<CR>',
      desc = 'Git file history',
    },
    -- File history for the whole project
    {
      '<leader>gH',
      '<cmd>DiffviewFileHistory<CR>',
      desc = 'Git project history',
    },
    -- Close diffview from anywhere
    {
      '<leader>gx',
      '<cmd>DiffviewClose<CR>',
      desc = 'Close Diffview',
    },
  },
  opts = {
    enhanced_diff_hl   = true,   -- more granular intra-line highlights
    show_help_hints    = true,
    use_icons          = true,

    icons = {
      folder_closed = '',
      folder_open   = '',
    },

    signs = {
      fold_closed = '',
      fold_open   = '',
      done        = '✓',
    },

    -- Panel on the left lists all changed files.
    -- The right side shows the diff.
    -- q closes the whole diffview tab.
    view = {
      default = {
        layout      = 'diff2_horizontal',  -- side-by-side diff
        winbar_info = false,
      },
      merge_tool = {
        layout     = 'diff3_horizontal',   -- 3-way merge view
        disable_diagnostics = true,
      },
      file_history = {
        layout = 'diff2_horizontal',
      },
    },

    file_panel = {
      listing_style     = 'tree',   -- show as directory tree, not flat list
      tree_options = {
        flatten_dirs            = true,
        folder_statuses         = 'only_folded',
      },
      win_config = {
        position = 'left',
        width    = 35,
      },
    },

    hooks = {
      -- When diffview opens, disable diagnostics in the diff buffers
      -- so lint/LSP noise doesn't clutter the diff view.
      diff_buf_read = function(bufnr)
        vim.diagnostic.enable(false, { bufnr = bufnr })
      end,
    },

    keymaps = {
      disable_defaults = false,
      view = {
        { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' } },
      },
      file_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' } },
      },
      file_history_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' } },
      },
    },
  },
}

return { gitsigns, neogit, diffview }
