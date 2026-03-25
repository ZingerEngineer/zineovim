-- ============================================================
--   Colorscheme — Ayu Dark
--
--   Shatur/neovim-ayu is the best maintained Lua port of the
--   Ayu theme. It provides three variants:
--     ayu-dark   → deep dark background (what we use)
--     ayu-mirage → softer dark background
--     ayu-light  → light background
--
--   priority = 1000 ensures this loads before every other
--   start plugin so the colors are in place from the first frame.
-- ============================================================

return {
  'Shatur/neovim-ayu',
  lazy     = false,
  priority = 1000,
  config = function()
    require('ayu').setup({
      mirage   = false,  -- use the full dark variant, not mirage
      terminal = true,   -- also set terminal buffer colors to match
      overrides = {
        -- Add theme overrides here later if needed.
        -- Example: Normal = { bg = '#0a0e14' }
      },
    })

    vim.cmd.colorscheme('ayu-dark')
  end,
}
