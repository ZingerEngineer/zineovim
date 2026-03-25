-- ============================================================
--   lazy.nvim bootstrap + plugin loader
--
--   lazy.nvim lives in ~/.local/share/nvim/lazy/lazy.nvim.
--   If it isn't there, we clone it from GitHub on first start.
--   After that, require('lazy').setup() reads every .lua file
--   inside lua/zindora/plugins/ and registers the plugins.
-- ============================================================

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.notify('Bootstrapping lazy.nvim — please wait...', vim.log.levels.INFO)
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Add the site directory so nvim-treesitter parsers are found at runtime.
vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/site')

require('lazy').setup({
  -- Import every file in lua/zindora/plugins/*.lua automatically.
  -- No need to register plugins here manually — just add a file there.
  spec = {
    { import = 'zindora.plugins' },
  },

  defaults = {
    lazy = false,   -- load plugins at startup unless they specify otherwise
    version = false, -- always use the latest git commit, not semver tags
  },

  -- Disable luarocks/hererocks integration — we don't use any rocks packages.
  rocks = { enabled = false },

  install = {
    -- Fallback colorscheme while plugins are being installed
    colorscheme = { 'ayu-dark', 'habamax' },
  },

  checker = {
    enabled = true,  -- background check for plugin updates
    notify = false,  -- don't pop a notification on every check
  },

  performance = {
    rtp = {
      -- Disable default Neovim plugins we don't use.
      -- netrwPlugin is disabled because neo-tree handles file browsing.
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },

  ui = {
    border = 'rounded',
    -- Use Nerd Font icons when available, fall back to unicode symbols.
    icons = vim.g.have_nerd_font and {} or {
      cmd     = '⌘',
      config  = '🛠',
      event   = '📅',
      ft      = '📂',
      init    = '⚙',
      keys    = '🗝',
      plugin  = '🔌',
      runtime = '💻',
      require = '🌙',
      source  = '📄',
      start   = '🚀',
      task    = '📌',
      lazy    = '💤',
    },
  },
})
