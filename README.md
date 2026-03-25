# zindora

Personal Neovim configuration. Ayu dark theme. Rich UI. Built for web, systems, and scripting work.

## Stack

| Layer | Plugin |
|---|---|
| Plugin manager | lazy.nvim |
| Colorscheme | Ayu dark |
| File explorer | neo-tree |
| Fuzzy finder | Telescope + fzf-native |
| Statusline | lualine |
| Buffer tabs | bufferline |
| LSP | nvim-lspconfig + Mason |
| Completion | blink.cmp |
| AI completions | GitHub Copilot |
| Syntax | nvim-treesitter |
| Formatting | conform.nvim (biome, stylua, ruff, goimports) |
| Linting | nvim-lint (biome, ruff, markdownlint) |
| Git gutter | gitsigns |
| Git UI | neogit + diffview |
| Comments | Comment.nvim + ts-context-commentstring |
| Surround | nvim-surround |
| Pairs | nvim-autopairs + nvim-ts-autotag |
| Markdown | render-markdown.nvim |

## Languages

`HTML` `CSS` `SCSS/SASS` `JavaScript` `TypeScript` `React (JSX/TSX)` `Vue` `Angular` `Python` `Go` `Lua` `C` `C++`

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ZingerEngineer/zineovim/main/install.sh)
```

### Requirements

| Tool | Purpose |
|---|---|
| `nvim >= 0.11` | Required |
| `git` | Required |
| `node >= 18` | Copilot + some LSPs |
| `make` | Build telescope-fzf-native |
| `rg` (ripgrep) | Telescope live grep |
| `unzip` | Mason package extraction |

## Key bindings

Leader key: `Space`

### Navigation
| Key | Action |
|---|---|
| `<leader>sf` | Find files |
| `<leader>sg` | Grep across project |
| `<leader>sw` | Grep current word |
| `<leader>sb` | Search in current buffer |
| `<leader><leader>` | Switch buffers |
| `<leader>e` | Toggle file explorer |
| `\` | Reveal current file in explorer |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>1`–`9` | Jump to buffer by number |

### LSP
| Key | Action |
|---|---|
| `grd` | Go to definition |
| `grr` | References |
| `grn` | Rename symbol |
| `gra` | Code action |
| `K` | Hover documentation |
| `<leader>th` | Toggle inlay hints |
| `[d` / `]d` | Previous / next diagnostic |

### Git
| Key | Action |
|---|---|
| `<leader>gg` | Open Neogit |
| `<leader>gd` | Toggle Diffview |
| `<leader>gh` | File history |
| `<leader>gc` | Commit |
| `<leader>tb` | Toggle inline blame |
| `]c` / `[c` | Next / previous hunk |

### Editing
| Key | Action |
|---|---|
| `gcc` | Toggle line comment |
| `gc` + motion | Comment region |
| `ysiw"` | Surround word with `"` |
| `ds"` | Delete surrounding `"` |
| `cs"'` | Change `"` to `'` |
| `<Tab>` | Accept Copilot suggestion |
| `<M-]>` / `<M-[>` | Next / previous Copilot suggestion |
| `<A-j>` / `<A-k>` | Move line up / down |

### Copilot first-time auth
```
:Copilot auth
```

## Structure

```
~/.config/nvim/
├── init.lua
└── lua/zindora/
    ├── lazy.lua
    ├── core/
    │   ├── options.lua
    │   ├── keymaps.lua
    │   └── autocmds.lua
    └── plugins/
        ├── colorscheme.lua
        ├── ui.lua
        ├── which-key.lua
        ├── neo-tree.lua
        ├── telescope.lua
        ├── lsp.lua
        ├── completion.lua
        ├── copilot.lua
        ├── treesitter.lua
        ├── formatting.lua
        ├── linting.lua
        ├── git.lua
        ├── editing.lua
        └── markdown.lua
```
