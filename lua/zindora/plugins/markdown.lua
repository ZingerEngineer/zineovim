-- ============================================================
--   Markdown — render-markdown.nvim
--
--   Renders markdown syntax directly inside the Neovim buffer:
--   headings become styled banners, code blocks get background
--   shading, checkboxes render as ✅/☐, tables draw real borders.
--   No browser, no split — everything in the editor itself.
--
--   Activates automatically on .md files.
--   Toggle with <leader>tm to turn rendering off when you need
--   to see raw markdown syntax (e.g. when editing complex tables).
-- ============================================================

return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  ft   = { 'markdown', 'Avante' },
  keys = {
    {
      '<leader>tm',
      '<cmd>RenderMarkdown toggle<CR>',
      ft   = 'markdown',
      desc = 'Toggle Markdown rendering',
    },
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    enabled = true,

    -- ── Headings ─────────────────────────────────────────
    -- Each heading level gets a full-width highlight band and
    -- a Nerd Font icon prefix.
    heading = {
      enabled   = true,
      sign      = true,
      position  = 'overlay',
      icons     = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      width     = 'full',
    },

    -- ── Code blocks ──────────────────────────────────────
    -- Fenced code blocks get a highlighted background so they
    -- stand out from prose. The language label is shown on the
    -- top-right of the block.
    code = {
      enabled   = true,
      sign      = true,
      style     = 'full',       -- highlight the entire block, not just the fence
      position  = 'left',
      width     = 'full',
      language_pad = 0,
      disable_background = { 'diff' },
    },

    -- ── Bullets ──────────────────────────────────────────
    bullet = {
      enabled = true,
      icons   = { '●', '○', '◆', '◇' },
    },

    -- ── Checkboxes ───────────────────────────────────────
    checkbox = {
      enabled   = true,
      unchecked = { icon = '󰄱 ' },
      checked   = { icon = '󰱒 ' },
      custom    = {
        todo        = { raw = '[-]',  rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
        in_progress = { raw = '[~]',  rendered = '󰜎 ', highlight = 'RenderMarkdownWarn' },
      },
    },

    -- ── Tables ───────────────────────────────────────────
    -- Draw proper box-drawing character borders around tables.
    pipe_table = {
      enabled   = true,
      preset    = 'double',     -- double-line borders
      alignment_indicator = '━',
    },

    -- ── Block quotes ─────────────────────────────────────
    quote = {
      enabled = true,
      icon    = '▋',
    },

    -- ── Callouts (GitHub-flavoured > [!NOTE] etc.) ───────
    callout = {
      note    = { raw = '[!NOTE]',    rendered = '󰋽 Note',    highlight = 'RenderMarkdownInfo' },
      tip     = { raw = '[!TIP]',     rendered = '󰌶 Tip',     highlight = 'RenderMarkdownSuccess' },
      important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
      warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
      caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
    },

    -- ── Links ────────────────────────────────────────────
    link = {
      enabled     = true,
      image       = '󰥶 ',
      email       = '󰀓 ',
      hyperlink   = '󰌹 ',
    },

    -- ── Horizontal rules ─────────────────────────────────
    dash = {
      enabled = true,
      icon    = '─',
      width   = 'full',
    },
  },
}
