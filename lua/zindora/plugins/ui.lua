-- ============================================================
--   UI layer — statusline, bufferline, indent guides
--
--   Three plugins in one file because they are purely visual
--   with no keymaps or cross-plugin logic between them.
-- ============================================================

-- ── lualine — statusline ─────────────────────────────────────
--
--   Sections layout:
--     left  │ mode │ branch + diff + diagnostics │ filename │
--     right │ LSP server │ filetype │ progress │ location │
local lualine = {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event        = 'VimEnter',
  config = function()
    local lualine = require('lualine')

    -- Show the active LSP server(s) for the current buffer.
    -- Displayed on the right side so you always know what's attached.
    local function lsp_name()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then return '' end
      local names = {}
      for _, c in ipairs(clients) do
        -- Skip null-ls / none-ls since it aggregates many tools
        if c.name ~= 'null-ls' and c.name ~= 'none-ls' then
          table.insert(names, c.name)
        end
      end
      return #names > 0 and ('  ' .. table.concat(names, ', ')) or ''
    end

    lualine.setup({
      options = {
        theme                = 'ayu_dark',
        component_separators = { left = '', right = '' },
        section_separators   = { left = '', right = '' },
        globalstatus         = true,   -- one statusline for all windows
        disabled_filetypes   = {
          statusline = { 'neo-tree', 'lazy', 'mason' },
        },
      },

      sections = {
        lualine_a = {
          { 'mode', separator = { left = '' }, right_padding = 2 },
        },
        lualine_b = {
          { 'branch', icon = '' },
          {
            'diff',
            symbols = { added = ' ', modified = ' ', removed = ' ' },
          },
          {
            'diagnostics',
            symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰠠 ' },
          },
        },
        lualine_c = {
          {
            'filename',
            path = 1,             -- show relative path
            symbols = {
              modified = ' ●',
              readonly = ' ',
              unnamed  = '[No Name]',
            },
          },
        },
        lualine_x = {
          { lsp_name },
          { 'filetype', icon_only = false },
        },
        lualine_y = { 'progress' },
        lualine_z = {
          { 'location', separator = { right = '' }, left_padding = 2 },
        },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },

      extensions = { 'neo-tree', 'lazy', 'quickfix' },
    })
  end,
}

-- ── bufferline — buffer tabs ──────────────────────────────────
--
--   Shows open buffers as clickable tabs along the top, just
--   like VSCode. The neo-tree offset keeps the tabs aligned
--   with the editor area, not behind the file tree.
--
--   Keymaps (also set below in keys = {}):
--     <S-h> / <S-l>        → previous / next buffer  (from keymaps.lua)
--     <leader>1 … <leader>9 → jump to buffer by position
--     <leader>bd            → delete current buffer   (from keymaps.lua)
local bufferline = {
  'akinsho/bufferline.nvim',
  version      = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event        = 'VimEnter',
  keys = {
    { '<leader>1', '<cmd>BufferLineGoToBuffer 1<CR>', desc = 'Go to buffer 1' },
    { '<leader>2', '<cmd>BufferLineGoToBuffer 2<CR>', desc = 'Go to buffer 2' },
    { '<leader>3', '<cmd>BufferLineGoToBuffer 3<CR>', desc = 'Go to buffer 3' },
    { '<leader>4', '<cmd>BufferLineGoToBuffer 4<CR>', desc = 'Go to buffer 4' },
    { '<leader>5', '<cmd>BufferLineGoToBuffer 5<CR>', desc = 'Go to buffer 5' },
    { '<leader>6', '<cmd>BufferLineGoToBuffer 6<CR>', desc = 'Go to buffer 6' },
    { '<leader>7', '<cmd>BufferLineGoToBuffer 7<CR>', desc = 'Go to buffer 7' },
    { '<leader>8', '<cmd>BufferLineGoToBuffer 8<CR>', desc = 'Go to buffer 8' },
    { '<leader>9', '<cmd>BufferLineGoToBuffer 9<CR>', desc = 'Go to buffer 9' },
    { '<leader>bp', '<cmd>BufferLinePick<CR>',        desc = 'Pick buffer' },
    { '<leader>bc', '<cmd>BufferLinePickClose<CR>',   desc = 'Pick buffer to close' },
  },
  opts = {
    options = {
      mode             = 'buffers',
      numbers          = 'ordinal',     -- show position number on each tab
      close_command    = 'bdelete! %d',
      separator_style  = 'slant',
      show_buffer_icons      = true,
      show_buffer_close_icons = true,
      show_close_icon        = false,
      show_tab_indicators    = true,
      persist_buffer_sort    = true,
      always_show_bufferline = false,   -- hide when only one buffer is open
      diagnostics        = 'nvim_lsp',  -- show LSP error/warn counts on tabs
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level)
        local icon = level:match('error') and ' ' or ' '
        return ' ' .. icon .. count
      end,
      -- Offset the bufferline to the right of the neo-tree window.
      -- When neo-tree is open its width is 35 (set in neo-tree.lua).
      offsets = {
        {
          filetype   = 'neo-tree',
          text       = '  File Explorer',
          text_align = 'left',
          separator  = true,
          highlight  = 'Directory',
        },
      },
    },
  },
}

-- ── indent-blankline — indentation guides ─────────────────────
--
--   Draws a vertical │ line at each indentation level.
--   The current scope (the block your cursor is in) is
--   highlighted in a different colour so you always know
--   where you are in nested code.
local indent_guides = {
  'lukas-reineke/indent-blankline.nvim',
  main  = 'ibl',
  event = { 'BufReadPost', 'BufNewFile' },
  opts  = {
    indent = {
      char      = '│',
      tab_char  = '│',
      highlight = 'IblIndent',
    },
    scope = {
      enabled        = true,
      show_start     = false,   -- no underline at the start of scope
      show_end       = false,
      highlight      = 'IblScope',
    },
    exclude = {
      filetypes = {
        'help', 'lazy', 'mason', 'neo-tree',
        'notify', 'toggleterm', 'markdown',
      },
    },
  },
}

return { lualine, bufferline, indent_guides }
