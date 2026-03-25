-- ============================================================
--   Editing plugins — four quality-of-life tools
--
--   nvim-autopairs       → auto-close (), [], {}, "", '', ``
--   nvim-ts-autotag      → auto-close + auto-rename HTML/JSX/Vue tags
--   Comment.nvim         → toggle line/block comments (gcc / gbc)
--   nvim-ts-context-commentstring → correct comment style per
--                           cursor context (JSX {/* */} vs // etc.)
--   nvim-surround        → add/change/delete surrounding chars
--   todo-comments.nvim   → highlight + navigate TODO/FIXME/NOTE
-- ============================================================

-- ── nvim-autopairs ───────────────────────────────────────────
--
--   Inserts the closing character whenever you type an opening one:
--     ( → ()    [ → []    { → {}    " → ""    ' → ''    ` → ``
--
--   Uses treesitter to detect context: won't insert a closing quote
--   if you're already inside a string, and won't pair inside comments.
local autopairs = {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup({
      check_ts        = true,   -- use treesitter for context detection
      ts_config = {
        lua        = { 'string' },           -- don't pair inside Lua strings
        javascript = { 'template_string' },  -- don't pair inside JS template strings
      },
      fast_wrap = {
        -- <M-e> wraps the next token with the last typed pair.
        -- Example: type `func(` then press <M-e> to wrap the next word.
        map            = '<M-e>',
        chars          = { '{', '[', '(', '"', "'" },
        pattern        = [=[[%'%"%>%]%)%}%,]]=],
        end_key        = '$',
        keys           = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma    = true,
        manual_position = true,
        highlight      = 'Search',
        highlight_grey = 'Comment',
      },
    })
  end,
}

-- ── nvim-ts-autotag ──────────────────────────────────────────
--
--   Automatically closes and renames HTML / JSX / Vue / Angular tags.
--
--   Type  <div  →  <div></div>  with cursor between tags.
--   Rename opening tag  →  closing tag renames automatically.
--
--   Supports: html, xml, jsx, tsx, vue, astro, svelte, php, markdown
local autotag = {
  'windwp/nvim-ts-autotag',
  event = { 'BufReadPost', 'BufNewFile' },
  opts  = {
    opts = {
      enable_close        = true,   -- auto-close tags
      enable_rename       = true,   -- rename closing tag when you rename opening
      enable_close_on_slash = true, -- close tag on </
    },
  },
}

-- ── Comment.nvim ─────────────────────────────────────────────
--
--   Toggle line and block comments with a single keymap.
--   nvim-ts-context-commentstring makes it context-aware:
--   inside a JSX expression it uses {/* */}, outside it uses //.
--   Inside a <style> block in a Vue file it uses /* */, etc.
--
--   Keymaps (normal mode):
--     gcc   → toggle current line comment
--     gbc   → toggle current line block comment
--     gc{motion} → comment region (e.g. gc3j = comment 3 lines down)
--
--   Keymaps (visual mode):
--     gc    → toggle comment on selection
--     gb    → toggle block comment on selection
local comment = {
  'numToStr/Comment.nvim',
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    -- ts-context-commentstring must be set up first and told to
    -- not register its own autocmd (Comment.nvim calls it directly).
    require('ts_context_commentstring').setup({
      enable_autocmd = false,
    })

    require('Comment').setup({
      -- Hook into ts-context-commentstring for per-context comment strings
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),

      -- Keep the default gcc / gbc / gc / gb keymaps.
      -- Set to false and define your own below if you want changes.
      mappings = {
        basic   = true,
        extra   = true,
      },
    })
  end,
}

-- ── nvim-surround ────────────────────────────────────────────
--
--   Add, change, and delete surrounding characters.
--
--   Normal mode:
--     ys{motion}{char}  → add surrounding
--       ysiw"           → surround inner word with "double quotes"
--       ysa"'           → surround around " with 'single quotes'
--       ysip}           → surround paragraph with { }
--       yss)            → surround entire line with ()
--
--     ds{char}          → delete surrounding
--       ds"             → remove surrounding "quotes"
--       ds(             → remove surrounding (parens)
--
--     cs{old}{new}      → change surrounding
--       cs"'            → change "double" → 'single'
--       cs)]            → change (parens) → [brackets]
--       cst<p>          → change any tag → <p>tag</p>
--
--   Visual mode:
--     S{char}           → surround selection
--       S"              → surround selected text with "
--       S<div>          → wrap selection in <div></div>
local surround = {
  'kylechui/nvim-surround',
  version = '*',
  event   = { 'BufReadPost', 'BufNewFile' },
  opts    = {},
}

-- ── todo-comments ────────────────────────────────────────────
--
--   Highlights special comment keywords and lets you jump
--   between them or search all of them with Telescope.
--
--   Recognised keywords (case-insensitive):
--     TODO   → blue   — something to do
--     FIXME  → red    — broken, needs a fix
--     BUG    → red    — confirmed bug
--     HACK   → orange — a workaround, not a real fix
--     WARN   → yellow — be careful here
--     NOTE   → green  — informational
--     PERF   → purple — performance consideration
--
--   Keymaps:
--     ]t / [t        → jump to next / previous TODO
--     <leader>st     → search all TODOs with Telescope
local todo = {
  'folke/todo-comments.nvim',
  event        = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      ']t',
      function() require('todo-comments').jump_next() end,
      desc = 'Next TODO comment',
    },
    {
      '[t',
      function() require('todo-comments').jump_prev() end,
      desc = 'Previous TODO comment',
    },
  },
  opts = {
    signs      = true,    -- show icons in the sign column
    sign_priority = 8,
    keywords   = {
      FIX  = { icon = ' ', color = 'error',   alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning', alt = { 'TRICK', 'WORKAROUND' } },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = ' ', color = 'default', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = ' ', color = 'hint',    alt = { 'INFO', 'REMINDER' } },
      TEST = { icon = '⏲ ', color = 'test',   alt = { 'TESTING', 'PASSED', 'FAILED' } },
    },
    highlight = {
      multiline        = true,
      before           = '',
      keyword          = 'wide',
      after            = 'fg',
      pattern          = [[.*<(KEYWORDS)\s*:]],
      comments_only    = true,
      max_line_len     = 400,
      exclude          = {},
    },
    search = {
      command = 'rg',
      args    = {
        '--color=never', '--no-heading',
        '--with-filename', '--line-number',
        '--column', '--hidden', '--glob', '!.git/',
      },
      pattern = [[\b(KEYWORDS):]],
    },
  },
}

return { autopairs, autotag, comment, surround, todo }
