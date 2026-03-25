-- ============================================================
--   Telescope — fuzzy finder
--
--   Finds files, greps the entire project, searches help,
--   lists keymaps, diagnostics, buffers, and more.
--   telescope-fzf-native gives it a Rust-speed fuzzy core.
--   telescope-ui-select replaces vim.ui.select (used by LSP
--   code actions, etc.) with a Telescope picker.
--
--   Keymaps:
--     <leader>sf   → find files in project
--     <leader>sg   → live grep  (search text across all files)
--     <leader>sw   → grep the word under the cursor
--     <leader>sb   → fuzzy search inside the current buffer
--     <leader>s/   → live grep only in open buffers
--     <leader>sr   → resume the last search
--     <leader>sd   → search LSP diagnostics
--     <leader>sh   → search Neovim :help tags
--     <leader>sk   → search keymaps
--     <leader>sn   → search files inside this nvim config
--     <leader>st   → search TODO / FIXME / NOTE comments
--     <leader><leader> → switch between open buffers
--
--   Inside any Telescope picker:
--     <C-j> / <C-k>  → move down / up
--     <C-q>          → send ALL results to quickfix list
--     <M-q>          → send SELECTED results to quickfix list
--     <C-v>          → open in vertical split
--     <C-x>          → open in horizontal split
--     <Esc>          → close
-- ============================================================

return {
  'nvim-telescope/telescope.nvim',
  event        = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      -- Native FZF sorter written in C — much faster than the Lua sorter
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond  = function() return vim.fn.executable('make') == 1 end,
    },
    -- Use Telescope for vim.ui.select() calls (e.g. LSP code actions)
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local telescope = require('telescope')
    local actions   = require('telescope.actions')
    local builtin   = require('telescope.builtin')

    telescope.setup({
      defaults = {
        -- ── Prompt ──────────────────────────────────────
        prompt_prefix   = '   ',
        selection_caret = ' ',
        entry_prefix    = '  ',
        multi_icon      = '  ',

        -- ── Layout ──────────────────────────────────────
        sorting_strategy = 'ascending',
        layout_strategy  = 'horizontal',
        layout_config    = {
          horizontal = {
            prompt_position = 'top',
            preview_width   = 0.50,
            results_width   = 0.50,
          },
          width         = 0.90,
          height        = 0.85,
          preview_cutoff = 120,  -- don't show preview on narrow terminals
        },

        -- ── Files to ignore ─────────────────────────────
        -- These patterns are applied to file paths.
        -- lua patterns, not globs.
        file_ignore_patterns = {
          'node_modules',
          '%.git/',
          'dist/',
          'build/',
          '%.cache/',
          '%.lock$',
          'lazy%-lock%.json',
          '__pycache__/',
          '%.pyc$',
          '%.venv/',
          'vendor/',      -- Go vendor directory
        },

        -- ── Keymaps inside the picker ────────────────────
        mappings = {
          i = {
            ['<C-j>']  = actions.move_selection_next,
            ['<C-k>']  = actions.move_selection_previous,
            ['<C-q>']  = actions.send_to_qflist + actions.open_qflist,
            ['<M-q>']  = actions.send_selected_to_qflist + actions.open_qflist,
            ['<Esc>']  = actions.close,
            ['<C-u>']  = false,   -- don't clear prompt on <C-u>
            ['<C-d>']  = false,
          },
          n = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['q']     = actions.close,
          },
        },
      },

      -- ── Picker-specific settings ─────────────────────
      pickers = {
        find_files = {
          hidden      = true,   -- show dotfiles
          follow      = true,   -- follow symlinks
        },
        live_grep = {
          additional_args = { '--hidden', '--glob', '!.git/' },
        },
        buffers = {
          sort_lastused = true,
          ignore_current_buffer = true,
          mappings = {
            i = { ['<C-d>'] = actions.delete_buffer },
            n = { ['dd']    = actions.delete_buffer },
          },
        },
        grep_string = {
          additional_args = { '--hidden', '--glob', '!.git/' },
        },
      },

      -- ── Extensions ───────────────────────────────────
      extensions = {
        fzf = {
          fuzzy                   = true,
          override_generic_sorter = true,
          override_file_sorter    = true,
          case_mode               = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({
            winblend = 10,
            width    = 0.5,
            height   = 0.4,
          }),
        },
      },
    })

    -- Load extensions (pcall so nvim doesn't hard-crash if make failed)
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')

    -- ── Keymaps ──────────────────────────────────────────
    -- File finding
    vim.keymap.set('n', '<leader>sf', builtin.find_files,  { desc = 'Search Files' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep,   { desc = 'Search by Grep' })
    vim.keymap.set({ 'n', 'v' }, '<leader>sw',
      builtin.grep_string, { desc = 'Search current Word' })

    -- Buffer-local fuzzy search (search inside the file you're editing)
    vim.keymap.set('n', '<leader>sb', function()
      builtin.current_buffer_fuzzy_find(
        require('telescope.themes').get_dropdown({
          winblend  = 10,
          previewer = false,
          width     = 0.7,
        })
      )
    end, { desc = 'Search in current Buffer' })

    -- Grep across only the files that are currently open
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep({
        grep_open_files  = true,
        prompt_title     = 'Grep in Open Buffers',
      })
    end, { desc = 'Search / in open buffers' })

    -- Meta
    vim.keymap.set('n', '<leader>sr', builtin.resume,      { desc = 'Search Resume' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search Diagnostics' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags,   { desc = 'Search Help' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps,     { desc = 'Search Keymaps' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles,    { desc = 'Search Recent files' })

    -- Search this config directory
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end, { desc = 'Search Nvim config files' })

    -- Buffer switcher (shows open buffers as a picker)
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Switch Buffers' })

    -- TODOs (requires todo-comments which is in editing.lua)
    vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<CR>', { desc = 'Search TODOs' })

    -- LSP pickers — registered here so they override the defaults
    -- set in lsp.lua when telescope is available.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('telescope-lsp', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('grr', builtin.lsp_references,              '[G]oto [R]eferences')
        map('grd', builtin.lsp_definitions,             '[G]oto [D]efinition')
        map('gri', builtin.lsp_implementations,         '[G]oto [I]mplementation')
        map('grt', builtin.lsp_type_definitions,        '[G]oto [T]ype definition')
        map('gO',  builtin.lsp_document_symbols,        'Document Symbols')
        map('gW',  builtin.lsp_dynamic_workspace_symbols,'Workspace Symbols')
      end,
    })
  end,
}
