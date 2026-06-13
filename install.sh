#!/bin/bash

set -e

REPO_RAW_BASE="https://raw.githubusercontent.com/Lynxz411/Lynxz-ohmyposh/main"
THEME_NAME="lynxz.omp.json"
TARGET_DIR="$HOME/.config/ohmyposh"
TARGET_THEME="$TARGET_DIR/$THEME_NAME"

echo "======================================"
echo "⚡ Lynxz OhMyPosh Theme Installer"
echo "======================================"
echo ""

# -----------------------------
# Detect Distro
# -----------------------------
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    echo "✔ Detected distro: $DISTRO"
else
    echo "❌ Cannot detect Linux distro."
    exit 1
fi

echo ""

# -----------------------------
# Install dependencies
# -----------------------------
install_deps() {
    case "$DISTRO" in
        arch|cachyos|manjaro)
            sudo pacman -Sy --needed curl unzip fontconfig
        ;;
        ubuntu|debian)
            sudo apt update
            sudo apt install -y curl unzip fontconfig
        ;;
        fedora)
            sudo dnf install -y curl unzip fontconfig
        ;;
        *)
            echo "⚠️  Unsupported distro for auto-deps. Install curl unzip fontconfig manually."
        ;;
    esac
}

# -----------------------------
# Detect Shell
# -----------------------------
CURRENT_SHELL=$(basename "$SHELL")

# Fallback to bash if shell detection fails
if [ -z "$CURRENT_SHELL" ]; then
    CURRENT_SHELL="bash"
fi

echo "✔ Detected shell: $CURRENT_SHELL"
echo ""

# -----------------------------
# Check & Auto Install Oh My Posh
# -----------------------------
if ! command -v oh-my-posh &> /dev/null; then
    echo "⚠️  oh-my-posh not found. Installing dependencies..."
    install_deps
    
    echo "📦 Installing oh-my-posh..."
    case "$DISTRO" in
        arch|cachyos|manjaro)
            sudo pacman -S --needed oh-my-posh
        ;;
        ubuntu|debian)
            curl -s https://ohmyposh.dev/install.sh | bash
        ;;
        fedora)
            sudo dnf install -y oh-my-posh
        ;;
        *)
            curl -s https://ohmyposh.dev/install.sh | bash
        ;;
    esac
    
    # Verify installation
    if ! command -v oh-my-posh &> /dev/null; then
        echo "❌ oh-my-posh installation failed."
        echo "Try installing manually: curl -s https://ohmyposh.dev/install.sh | bash"
        exit 1
    fi
    
    echo "✔ oh-my-posh installed"
else
    echo "✔ oh-my-posh already installed"
fi

echo ""

# -----------------------------
# Install JetBrainsMono Nerd Font (if missing)
# -----------------------------
if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd"; then
    echo "✔ JetBrainsMono Nerd Font already installed."
else
    echo "🧠 Installing JetBrainsMono Nerd Font..."

    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"

    TEMP_DIR="$(mktemp -d)"
    cd "$TEMP_DIR" || exit 1

    echo "   Downloading font..."
    curl -fsSL -o JetBrainsMono.zip \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

    unzip -q JetBrainsMono.zip -d JetBrainsMono
    cp JetBrainsMono/*.ttf "$FONT_DIR" 2>/dev/null || true

    cd - > /dev/null || exit 1
    rm -rf "$TEMP_DIR"

    fc-cache -fv > /dev/null 2>&1 || true

    echo "✔ JetBrainsMono Nerd Font installed."
fi

echo ""

# -----------------------------
# Create Config Directory
# -----------------------------
mkdir -p "$TARGET_DIR"

# Backup existing theme if present
if [ -f "$TARGET_THEME" ]; then
    echo "💾 Backing up existing theme..."
    mv "$TARGET_THEME" "$TARGET_THEME.bak.$(date +%s)"
fi

# -----------------------------
# Download Theme
# -----------------------------
echo "📥 Downloading theme..."
curl -fsSL "$REPO_RAW_BASE/$THEME_NAME" -o "$TARGET_THEME"

echo "✔ Theme installed to $TARGET_THEME"
echo ""

# -----------------------------
# Inject Config
# -----------------------------
case "$CURRENT_SHELL" in
    bash)
        CONFIG_FILE="$HOME/.bashrc"
        INIT_LINE="eval \"\$(oh-my-posh init bash --config $TARGET_THEME)\""
        ;;
    zsh)
        CONFIG_FILE="$HOME/.zshrc"
        INIT_LINE="eval \"\$(oh-my-posh init zsh --config $TARGET_THEME)\""
        ;;
    fish)
        CONFIG_FILE="$HOME/.config/fish/config.fish"
        INIT_LINE="oh-my-posh init fish --config $TARGET_THEME | source"
        mkdir -p "$HOME/.config/fish"
        ;;
    *)
        echo "⚠️  Unsupported shell. Add manually:"
        echo "oh-my-posh init SHELL --config $TARGET_THEME"
        exit 0
        ;;
esac

# Create config file if missing
touch "$CONFIG_FILE"

if grep -Fxq "$INIT_LINE" "$CONFIG_FILE" 2>/dev/null; then
    echo "ℹ️  Theme already configured in $CURRENT_SHELL."
else
    echo "🔧 Injecting theme into shell config..."
    echo "" >> "$CONFIG_FILE"
    echo "# Lynxz OhMyPosh Theme" >> "$CONFIG_FILE"
    echo "$INIT_LINE" >> "$CONFIG_FILE"
    echo "✔ Config injected into $CONFIG_FILE"
fi

echo ""

# -----------------------------
# Configure Kitty Terminal (if installed)
# -----------------------------
KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"

if command -v kitty &> /dev/null; then
    echo "🐱 Configuring Kitty terminal..."
    
    mkdir -p "$HOME/.config/kitty"
    touch "$KITTY_CONFIG"
    
    # Check if font is already configured
    if grep -q "^font_family.*JetBrainsMono" "$KITTY_CONFIG" 2>/dev/null; then
        echo "ℹ️  Kitty font already configured."
    else
        echo "🔧 Setting Kitty font..."
        echo "" >> "$KITTY_CONFIG"
        echo "# OhMyPosh Font Configuration" >> "$KITTY_CONFIG"
        echo "font_family JetBrainsMono Nerd Font" >> "$KITTY_CONFIG"
        echo "font_size 11" >> "$KITTY_CONFIG"
        echo "✔ Kitty configured with JetBrainsMono Nerd Font"
    fi
    
    echo ""
else
    echo "ℹ️  Kitty not detected. Install it to auto-configure fonts."
fi

echo ""
echo "======================================"
echo "✅ Installation Complete!"
echo "======================================"
echo ""
echo "🎉 Lynxz OhMyPosh theme is ready!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source $CONFIG_FILE"
if command -v kitty &> /dev/null; then
    echo "  2. Restart Kitty to apply font changes"
    echo "  3. Customize theme: nano ~/.config/ohmyposh/lynxz.omp.json"
else
    echo "  2. Customize theme: nano ~/.config/ohmyposh/lynxz.omp.json"
fi
echo "  3. Check docs: https://ohmyposh.dev/docs/configuration/overview"
echo ""
