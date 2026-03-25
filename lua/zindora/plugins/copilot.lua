-- ============================================================
--   GitHub Copilot
--
--   We use the pure-Lua copilot.lua instead of the official
--   copilot.vim because it integrates cleanly with blink.cmp
--   as a completion source (via blink-cmp-copilot).
--
--   IMPORTANT: first-time setup requires authentication.
--   Run  :Copilot auth  after nvim starts and follow the
--   browser flow. Your token is cached in:
--     ~/.config/github-copilot/
--
--   Ghost text (inline suggestions):
--     Copilot's virtual-text inline suggestion is ENABLED.
--     Press <Tab> to accept the full ghost-text suggestion.
--     Press <M-]> / <M-[> to cycle through alternatives.
--     Press <C-]> to dismiss.
--
--   Copilot also feeds into blink.cmp's completion popup
--   via blink-cmp-copilot, so you get both experiences.
-- ============================================================

return {
  'zbirenbaum/copilot.lua',
  cmd   = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup({
      suggestion = {
        enabled    = true,
        auto_trigger = true,   -- show ghost text automatically as you type
        hide_during_completion = true, -- hide ghost text when blink.cmp menu is open
        debounce   = 75,
        keymap = {
          accept        = '<Tab>',    -- accept the full ghost-text suggestion
          accept_word   = '<C-Right>',-- accept one word at a time
          accept_line   = '<C-Down>', -- accept one line at a time
          next          = '<M-]>',    -- next suggestion
          prev          = '<M-[>',    -- previous suggestion
          dismiss       = '<C-]>',    -- dismiss current suggestion
        },
      },
      panel = { enabled = false },    -- panel is redundant when using blink.cmp

      filetypes = {
        ['*']     = true,
        help      = false,
        gitcommit = false,
        gitrebase = false,
        ['.']     = false,
      },

      copilot_node_command = 'node',  -- must be Node.js >= 18
    })
  end,
}
