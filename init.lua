-- ============================================================
--   zindora — Neovim configuration
--   Entry point: load core settings first, then plugins.
--
--   Load order:
--     1. options   → vim settings (mapleader must be first)
--     2. keymaps   → base keymaps with no plugin dependencies
--     3. autocmds  → base autocommands
--     4. lazy      → bootstrap lazy.nvim, then all plugins
-- ============================================================

require('zindora.core.options')
require('zindora.core.keymaps')
require('zindora.core.autocmds')
require('zindora.lazy')
