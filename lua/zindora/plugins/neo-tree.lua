-- ============================================================
--   Neo-tree — file system explorer
--
--   Left sidebar showing the project directory tree with
--   file icons, git status indicators, and folder hierarchy.
--
--   Keymaps:
--     <leader>e  → toggle the explorer (open / close)
--     <leader>E  → reveal the current file in the tree
--     \          → reveal current file (same as <leader>E)
--
--   Inside the neo-tree window:
--     o / <CR>   → open file or expand folder
--     a          → add file or directory (end with / for dir)
--     d          → delete
--     r          → rename
--     y          → copy
--     x          → cut
--     p          → paste
--     q / <Esc>  → close the tree
-- ============================================================

return {
  'nvim-neo-tree/neo-tree.nvim',
  version      = '*',
  lazy         = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>e', '<cmd>Neotree toggle<CR>',  desc = 'Toggle file explorer' },
    { '<leader>E', '<cmd>Neotree reveal<CR>',  desc = 'Reveal file in explorer' },
    { '\\',        '<cmd>Neotree reveal<CR>',  desc = 'Reveal file in explorer' },
  },
  opts = {
    close_if_last_window = true,  -- close neo-tree if it's the only window left
    popup_border_style   = 'rounded',
    enable_git_status    = true,
    enable_diagnostics   = true,

    default_component_configs = {
      indent = {
        indent_size         = 2,
        padding             = 1,
        with_markers        = true,
        indent_marker       = '│',
        last_indent_marker  = '└',
        highlight           = 'NeoTreeIndentMarker',
        with_expanders      = true,
        expander_collapsed  = '',
        expander_expanded   = '',
        expander_highlight  = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open   = '',
        folder_empty  = '󰜌',
        default       = '*',
      },
      modified = {
        symbol    = '[+]',
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash      = false,
        use_git_status_colors = true,
        highlight           = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          added     = '',
          modified  = '',
          deleted   = '✖',
          renamed   = '󰁕',
          untracked = '',
          ignored   = '',
          unstaged  = '󰄱',
          staged    = '',
          conflict  = '',
        },
      },
    },

    window = {
      position = 'left',
      width    = 35,
      mapping_options = {
        noremap = true,
        nowait  = true,
      },
      mappings = {
        ['\\'] = 'close_window',
        ['q']  = 'close_window',
      },
    },

    filesystem = {
      filtered_items = {
        visible         = false,  -- hidden files are hidden by default
        hide_dotfiles   = true,
        hide_gitignored = true,
        hide_by_name    = { 'node_modules', '.git' },
        never_show      = { '.DS_Store', 'thumbs.db' },
      },
      follow_current_file = {
        enabled              = true,  -- auto-focus the tree on the file you're editing
        leave_dirs_open      = false,
      },
      group_empty_dirs         = true,  -- collapse empty dirs into one line
      hijack_netrw_behavior    = 'open_default',  -- replace netrw
      use_libuv_file_watcher   = true,  -- watch for file changes outside nvim
    },

    buffers = {
      follow_current_file = {
        enabled = true,
      },
    },

    git_status = {
      window = {
        position = 'float',
      },
    },
  },
}
