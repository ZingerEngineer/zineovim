-- ============================================================
--   Base autocommands — no plugin dependencies
--
--   Autocommands are event listeners. Each nvim_create_autocmd
--   call registers a callback that fires when the named event
--   occurs. We group related autocmds with nvim_create_augroup
--   so they can be safely cleared on re-source without stacking.
-- ============================================================

local augroup  = vim.api.nvim_create_augroup
local autocmd  = vim.api.nvim_create_autocmd

-- ── Auto-reload files changed outside Neovim ─────────────────
--
-- vim.o.autoread = true (set in options.lua) tells Neovim to reload
-- the buffer automatically, but it only acts on it when Neovim gets
-- a chance to check the file. The events below provide those checks:
--
--   FocusGained    → when the Neovim window gets focus
--   BufEnter       → when switching to a buffer
--   CursorHold     → after updatetime ms of no cursor movement
--   CursorHoldI    → same, but in insert mode
--
-- This gives the "live reload" behavior needed when Claude Code (or any
-- external process) modifies files you have open.
autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group    = augroup('auto_reload', { clear = true }),
  callback = function()
    -- Don't run :checktime while the command-line is open (mode == 'c')
    -- or for unnamed/scratch buffers (bufname == '').
    if vim.fn.mode() ~= 'c' and vim.fn.bufname('%') ~= '' then
      vim.cmd('checktime')
    end
  end,
  desc = 'Reload buffer when file changes on disk',
})

-- Notify the user when a buffer is reloaded due to an external change.
autocmd('FileChangedShellPost', {
  group    = augroup('file_changed_notify', { clear = true }),
  callback = function()
    vim.notify(
      'File changed on disk — buffer reloaded.',
      vim.log.levels.WARN,
      { title = 'zindora' }
    )
  end,
  desc = 'Notify when a buffer is auto-reloaded',
})

-- ── Highlight on yank ────────────────────────────────────────
-- Briefly flashes the yanked region so you can see exactly what was copied.
autocmd('TextYankPost', {
  group    = augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = 'IncSearch', timeout = 150 })
  end,
  desc = 'Flash yanked region',
})

-- ── Remove trailing whitespace on save ───────────────────────
-- Keeps files clean without requiring a formatter for every filetype.
-- winsaveview/winrestview prevents the cursor from jumping.
autocmd('BufWritePre', {
  group    = augroup('trim_whitespace', { clear = true }),
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
  desc = 'Strip trailing whitespace before saving',
})

-- ── Resize splits when the Neovim window is resized ──────────
-- Without this, splits keep their old pixel sizes when you resize
-- the terminal / Kitty window.
autocmd('VimResized', {
  group    = augroup('resize_splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
  desc = 'Equalize splits on terminal resize',
})

-- ── Filetype-specific settings ───────────────────────────────
-- Enable soft wrap and spell-checking for prose filetypes.
-- (Code files keep wrap = false from options.lua.)
autocmd('FileType', {
  group   = augroup('prose_settings', { clear = true }),
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function()
    vim.opt_local.wrap      = true
    vim.opt_local.spell     = true
    vim.opt_local.linebreak = true  -- wrap at word boundaries, not mid-word
  end,
  desc = 'Wrap + spell for prose filetypes',
})

-- ── Close utility windows with q ─────────────────────────────
-- Many built-in and plugin windows (help, quickfix, LSP info) benefit
-- from a quick 'q' to close. We also unlist them so they don't pollute
-- the buffer list.
autocmd('FileType', {
  group   = augroup('close_with_q', { clear = true }),
  pattern = {
    'help', 'qf', 'notify', 'lspinfo',
    'checkhealth', 'man', 'startuptime',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<CR>', {
      buffer  = event.buf,
      silent  = true,
      nowait  = true,
      desc    = 'Close window',
    })
  end,
  desc = 'Map q → close for utility windows',
})

-- ── Restore cursor position ───────────────────────────────────
-- Jump to the last known cursor position when reopening a file,
-- unless it's a git commit message or an event-based filetype.
autocmd('BufReadPost', {
  group    = augroup('restore_cursor', { clear = true }),
  callback = function(event)
    local ft = vim.bo[event.buf].filetype
    if ft == 'gitcommit' then return end

    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
  desc = 'Restore cursor to last known position',
})
