-- ============================================================
--   Base keymaps — no plugin dependencies
--
--   Plugin-specific keymaps live inside each plugin's spec
--   file in lua/zindora/plugins/ so they're co-located with
--   the plugin they belong to.
--
--   Convention used throughout this config:
--     <leader>b  → buffer operations
--     <leader>d  → diagnostics
--     <leader>f  → format / find (context-dependent)
--     <leader>g  → git
--     <leader>s  → search (telescope)
--     <leader>t  → toggle
--     <leader>w  → window / split operations
--     gr         → LSP code actions (built-in nvim 0.10+)
-- ============================================================

local map = vim.keymap.set

-- ── General ──────────────────────────────────────────────────

-- Clear search highlight with Escape in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Save from normal, insert, and visual modes
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR><Esc>', { desc = 'Save file' })

-- Quit current window / force-quit all
map('n', '<leader>q',  '<cmd>q<CR>',   { desc = 'Quit window' })
map('n', '<leader>Q',  '<cmd>qa!<CR>', { desc = 'Force quit all' })

-- ── Window navigation ────────────────────────────────────────
-- Move between splits with Ctrl+hjkl (same as tmux pane navigation)
map('n', '<C-h>', '<C-w>h', { desc = 'Focus left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Focus lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Focus upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Focus right window' })

-- Resize splits with Ctrl+arrow keys
map('n', '<C-Up>',    '<cmd>resize +2<CR>',          { desc = 'Resize window up' })
map('n', '<C-Down>',  '<cmd>resize -2<CR>',          { desc = 'Resize window down' })
map('n', '<C-Left>',  '<cmd>vertical resize -2<CR>', { desc = 'Resize window left' })
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Resize window right' })

-- Split operations
map('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = 'Split vertical' })
map('n', '<leader>wh', '<cmd>split<CR>',  { desc = 'Split horizontal' })
map('n', '<leader>we', '<C-w>=',          { desc = 'Equalize split sizes' })
map('n', '<leader>wx', '<cmd>close<CR>',  { desc = 'Close split' })

-- ── Buffer navigation ────────────────────────────────────────
-- Shift+h/l to cycle buffers (feels natural next to hjkl)
map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<S-l>', '<cmd>bnext<CR>',     { desc = 'Next buffer' })

-- Buffer deletion
map('n', '<leader>bd', '<cmd>bdelete<CR>',  { desc = 'Delete buffer' })
map('n', '<leader>bD', '<cmd>bdelete!<CR>', { desc = 'Force delete buffer' })

-- ── Line movement ────────────────────────────────────────────
-- Alt+j/k to move the current line (or selection) up/down
map('n', '<A-j>', '<cmd>m .+1<CR>==',        { desc = 'Move line down' })
map('n', '<A-k>', '<cmd>m .-2<CR>==',        { desc = 'Move line up' })
map('i', '<A-j>', '<Esc><cmd>m .+1<CR>==gi', { desc = 'Move line down' })
map('i', '<A-k>', '<Esc><cmd>m .-2<CR>==gi', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv",        { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv",        { desc = 'Move selection up' })

-- ── Visual mode improvements ─────────────────────────────────
-- Stay in visual mode after indenting
map('v', '<', '<gv', { desc = 'Indent left (stay in visual)' })
map('v', '>', '>gv', { desc = 'Indent right (stay in visual)' })

-- Paste over a selection without overwriting the unnamed register.
-- Without this, pasting over selected text puts the deleted text in the
-- register, breaking the next paste.
map('v', 'p', '"_dP', { desc = 'Paste without overwriting register' })

-- ── Diagnostics ──────────────────────────────────────────────
map('n', '[d',        vim.diagnostic.goto_prev,  { desc = 'Previous diagnostic' })
map('n', ']d',        vim.diagnostic.goto_next,  { desc = 'Next diagnostic' })
map('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Show diagnostic float' })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Diagnostics → quickfix' })

-- ── Terminal ─────────────────────────────────────────────────
-- Double-Escape to leave terminal mode (default <C-\><C-n> is hard to hit)
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ── Quickfix ─────────────────────────────────────────────────
map('n', ']q', '<cmd>cnext<CR>',     { desc = 'Next quickfix item' })
map('n', '[q', '<cmd>cprevious<CR>', { desc = 'Previous quickfix item' })
map('n', '<leader>co', '<cmd>copen<CR>',  { desc = 'Open quickfix list' })
map('n', '<leader>cc', '<cmd>cclose<CR>', { desc = 'Close quickfix list' })
