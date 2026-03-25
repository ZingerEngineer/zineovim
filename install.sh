#!/usr/bin/env bash
# ============================================================
#   zindora — Neovim config installer
#
#   Usage on a fresh machine:
#     curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/nvim/main/install.sh | bash
#   Or after cloning:
#     bash install.sh
#
#   What it does:
#     1. Checks required system dependencies
#     2. Backs up any existing Neovim config
#     3. Clones this repo into ~/.config/nvim
#     4. On first nvim launch, lazy.nvim bootstraps itself
#        and installs all plugins + LSP servers automatically
# ============================================================

set -e

# ── Colours ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Colour

info()    { echo -e "${BLUE}[info]${NC}  $*"; }
success() { echo -e "${GREEN}[ok]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC}  $*"; }
error()   { echo -e "${RED}[error]${NC} $*"; exit 1; }

# ── Repo URL — update this to your GitHub repo ───────────────
REPO="https://github.com/YOUR_USERNAME/nvim.git"
NVIM_CONFIG="$HOME/.config/nvim"

echo ""
echo "  ╔══════════════════════════════════╗"
echo "  ║   zindora nvim config installer  ║"
echo "  ╚══════════════════════════════════╝"
echo ""

# ── 1. Check required dependencies ───────────────────────────
info "Checking dependencies..."

check_dep() {
  if command -v "$1" &>/dev/null; then
    success "$1 found"
  else
    warn "$1 not found — $2"
  fi
}

# Hard requirements
command -v nvim  &>/dev/null || error "Neovim not found. Install nvim >= 0.11 first."
command -v git   &>/dev/null || error "git not found. Install git first."
command -v node  &>/dev/null || error "Node.js not found. Install node >= 18 (required for Copilot + some LSPs)."

# Soft requirements (warn but don't abort)
check_dep "make"     "needed to compile telescope-fzf-native"
check_dep "rg"       "ripgrep — needed for live grep in Telescope"
check_dep "unzip"    "needed by Mason to extract some packages"
check_dep "curl"     "needed by Mason"

echo ""

# ── 2. Backup existing config ─────────────────────────────────
if [ -d "$NVIM_CONFIG" ]; then
  BACKUP="${NVIM_CONFIG}.bak.$(date +%Y%m%d_%H%M%S)"
  warn "Existing config found. Backing up to: $BACKUP"
  mv "$NVIM_CONFIG" "$BACKUP"
  success "Backup created at $BACKUP"
fi

# ── 3. Clone the repo ─────────────────────────────────────────
info "Cloning zindora config into $NVIM_CONFIG ..."
git clone "$REPO" "$NVIM_CONFIG"
success "Repo cloned."

# ── 4. Done — launch nvim to trigger bootstrap ────────────────
echo ""
success "Installation complete!"
echo ""
echo "  Next steps:"
echo "  1. Open nvim — lazy.nvim will bootstrap and install all plugins"
echo "  2. Wait for Mason to finish installing LSP servers (:Mason to check)"
echo "  3. Authenticate Copilot: run  :Copilot auth  inside nvim"
echo ""
echo "  Tip: run  :checkhealth  inside nvim to verify your setup."
echo ""
