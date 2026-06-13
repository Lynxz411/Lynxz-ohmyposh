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

# Get the actual login shell from /etc/passwd (more reliable)
CURRENT_SHELL=$(basename $(grep "^$USER" /etc/passwd | cut -d: -f7))

if [ -z "$CURRENT_SHELL" ] || [ "$CURRENT_SHELL" = "sh" ]; then
    CURRENT_SHELL=$(basename "$SHELL")
fi

if [ -z "$CURRENT_SHELL" ] || [ "$CURRENT_SHELL" = "sh" ]; then
    CURRENT_SHELL="bash"
fi

echo "✔ Login shell: $CURRENT_SHELL"
echo ""

# Offer to change shell if not one of the supported ones
if [ "$CURRENT_SHELL" != "bash" ] && [ "$CURRENT_SHELL" != "zsh" ] && [ "$CURRENT_SHELL" != "fish" ]; then
    echo "⚠️  Your shell ($CURRENT_SHELL) is not in supported list (bash, zsh, fish)"
    read -p "Do you want to switch to fish? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        chsh -s /usr/bin/fish
        CURRENT_SHELL="fish"
        echo "✔ Shell switched to fish. Please re-run installer in new session."
        exit 0
    fi
fi

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

# Check if oh-my-posh is installed but broken
if command -v oh-my-posh &> /dev/null; then
    echo "🔍 Checking oh-my-posh installation..."
    if ! oh-my-posh --version &> /dev/null; then
        echo "⚠️  oh-my-posh found but appears broken. Reinstalling..."
        
        case "$DISTRO" in
            arch|cachyos|manjaro)
                sudo pacman -R --noconfirm oh-my-posh 2>/dev/null || true
                sudo pacman -S --needed oh-my-posh
            ;;
            ubuntu|debian)
                sudo apt remove -y oh-my-posh 2>/dev/null || true
                curl -s https://ohmyposh.dev/install.sh | bash
            ;;
            fedora)
                sudo dnf remove -y oh-my-posh 2>/dev/null || true
                sudo dnf install -y oh-my-posh
            ;;
            *)
                curl -s https://ohmyposh.dev/install.sh | bash
            ;;
        esac
    else
        echo "✔ oh-my-posh already installed: $(oh-my-posh --version)"
    fi
else
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
fi

# Final verification
if ! command -v oh-my-posh &> /dev/null; then
    echo "❌ oh-my-posh installation failed."
    echo "Try installing manually: curl -s https://ohmyposh.dev/install.sh | bash"
    exit 1
fi

echo "✔ oh-my-posh installed successfully"
echo ""

# Get oh-my-posh path and version
OH_MY_POSH_PATH=$(which oh-my-posh)
OH_MY_POSH_VERSION=$(oh-my-posh --version 2>/dev/null || echo "unknown")
echo "ℹ️  Path: $OH_MY_POSH_PATH"
echo "ℹ️  Version: $OH_MY_POSH_VERSION"
echo ""

# Ensure PATH is updated for this session
export PATH="/usr/local/bin:$PATH:$HOME/bin"

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

# Verify theme file
if [ ! -f "$TARGET_THEME" ]; then
    echo "❌ Failed to download theme!"
    exit 1
fi

echo "🧪 Validating theme configuration..."
if $OH_MY_POSH_PATH print primary --config="$TARGET_THEME" > /dev/null 2>&1; then
    echo "✔ Theme configuration is valid"
else
    echo "⚠️  Theme may need adjustments, continuing anyway..."
fi

echo ""

# -----------------------------
# Inject Config
# -----------------------------
case "$CURRENT_SHELL" in
    bash)
        CONFIG_FILE="$HOME/.bashrc"
        INIT_LINE="eval \"\$($OH_MY_POSH_PATH init bash --config $TARGET_THEME)\""
        ;;
    zsh)
        CONFIG_FILE="$HOME/.zshrc"
        INIT_LINE="eval \"\$($OH_MY_POSH_PATH init zsh --config $TARGET_THEME)\""
        ;;
    fish)
        CONFIG_FILE="$HOME/.config/fish/config.fish"
        INIT_LINE="$OH_MY_POSH_PATH init fish --config $TARGET_THEME | source"
        mkdir -p "$HOME/.config/fish"
        ;;
    *)
        echo "⚠️  Unsupported shell: $CURRENT_SHELL"
        echo "Add manually:"
        echo "$OH_MY_POSH_PATH init SHELL --config $TARGET_THEME"
        exit 0
        ;;
esac

# Create config file if missing
touch "$CONFIG_FILE"

# Remove old oh-my-posh init lines to avoid duplicates (properly handled)
if [ -f "$CONFIG_FILE" ]; then
    grep -v "oh-my-posh" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" 2>/dev/null || true
    if [ -f "$CONFIG_FILE.tmp" ]; then
        mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    fi
fi

# Inject new configuration
echo "🔧 Injecting theme into $CURRENT_SHELL config..."
echo "" >> "$CONFIG_FILE"
echo "# Lynxz OhMyPosh Theme" >> "$CONFIG_FILE"
echo "$INIT_LINE" >> "$CONFIG_FILE"
echo "✔ Config injected into $CONFIG_FILE"

echo ""

# Verify injection
if ! grep -q "oh-my-posh" "$CONFIG_FILE"; then
    echo "⚠️  WARNING: Failed to inject theme into $CONFIG_FILE"
    echo "Please add manually:"
    echo "$INIT_LINE"
    exit 1
fi

echo "✔ Configuration verified"
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
    if grep -q "^font_family" "$KITTY_CONFIG" 2>/dev/null; then
        echo "ℹ️  Kitty font already configured."
    else
        echo "🔧 Setting Kitty font..."
        echo "" >> "$KITTY_CONFIG"
        echo "# OhMyPosh Font Configuration" >> "$KITTY_CONFIG"
        echo "font_family JetBrainsMono Nerd Font" >> "$KITTY_CONFIG"
        echo "font_size 11.0" >> "$KITTY_CONFIG"
        echo "✔ Kitty configured with JetBrainsMono Nerd Font"
    fi
    
    echo ""
else
    echo "ℹ️  Kitty not detected (optional)."
fi

echo ""
echo "======================================"
echo "✅ Installation Complete!"
echo "======================================"
echo ""
echo "🎉 Lynxz OhMyPosh theme is ready!"
echo ""
echo "📝 IMPORTANT - Next steps:"
echo ""
echo "  Option 1 - Reload current session:"
if [ "$CURRENT_SHELL" = "bash" ]; then
    echo "    $ source ~/.bashrc"
elif [ "$CURRENT_SHELL" = "zsh" ]; then
    echo "    $ source ~/.zshrc"
elif [ "$CURRENT_SHELL" = "fish" ]; then
    echo "    $ source ~/.config/fish/config.fish"
fi
echo ""
echo "  Option 2 - Close and open a new terminal window"
echo ""
if command -v kitty &> /dev/null; then
    echo "  ⚠️  Restart Kitty for font changes to take effect"
fi
echo ""
echo "  📝 Customize theme:"
echo "    $ nano ~/.config/ohmyposh/lynxz.omp.json"
echo ""
echo "  📚 Documentation:"
echo "    https://ohmyposh.dev/docs/configuration/overview"
echo ""
echo "  🐛 Debug configuration:"
echo "    $ $OH_MY_POSH_PATH print primary --config=\"$TARGET_THEME\""
echo ""
