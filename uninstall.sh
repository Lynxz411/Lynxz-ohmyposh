#!/bin/bash

set -e

TARGET_DIR="$HOME/.config/ohmyposh"
THEME_NAME="lynxz.omp.json"

echo "======================================"
echo "🗑️  Lynxz OhMyPosh Theme Uninstaller"
echo "======================================"
echo ""

# -----------------------------
# Detect Shell
# -----------------------------
CURRENT_SHELL=$(basename "$SHELL")

# Fallback to bash if shell detection fails
if [ -z "$CURRENT_SHELL" ]; then
    CURRENT_SHELL="bash"
fi

case "$CURRENT_SHELL" in
    bash)
        CONFIG_FILE="$HOME/.bashrc"
        ;;
    zsh)
        CONFIG_FILE="$HOME/.zshrc"
        ;;
    fish)
        CONFIG_FILE="$HOME/.config/fish/config.fish"
        ;;
    *)
        echo "⚠️  Unsupported shell: $CURRENT_SHELL"
        echo "📝 Please specify your shell (bash/zsh/fish):"
        read -r SHELL_CHOICE
        case "$SHELL_CHOICE" in
            bash)
                CONFIG_FILE="$HOME/.bashrc"
                CURRENT_SHELL="bash"
                ;;
            zsh)
                CONFIG_FILE="$HOME/.zshrc"
                CURRENT_SHELL="zsh"
                ;;
            fish)
                CONFIG_FILE="$HOME/.config/fish/config.fish"
                CURRENT_SHELL="fish"
                ;;
            *)
                echo "❌ Invalid shell choice. Exiting."
                exit 1
                ;;
        esac
        ;;
esac

echo "✔ Detected shell: $CURRENT_SHELL"
echo ""

# -----------------------------
# Remove OhMyPosh Theme
# -----------------------------
if [ -d "$TARGET_DIR" ]; then
    echo "📂 Removing OhMyPosh theme directory..."
    rm -rf "$TARGET_DIR"
    echo "✔ Theme removed from $TARGET_DIR"
else
    echo "ℹ️  Theme directory not found at $TARGET_DIR"
fi

echo ""

# -----------------------------
# Remove Shell Integration
# -----------------------------
if [ -f "$CONFIG_FILE" ]; then
    echo "🔍 Removing theme integration from shell..."
    
    # Create backup before modifying
    cp "$CONFIG_FILE" "$CONFIG_FILE.bak.$(date +%s)"
    echo "💾 Backed up config to $CONFIG_FILE.bak.*"
    
    # Remove Lynxz OhMyPosh Theme section
    if grep -q "# Lynxz OhMyPosh Theme" "$CONFIG_FILE" 2>/dev/null; then
        sed -i '/# Lynxz OhMyPosh Theme/d' "$CONFIG_FILE"
        sed -i '/oh-my-posh init/d' "$CONFIG_FILE"
        echo "✔ Removed theme integration from $CONFIG_FILE"
    else
        echo "ℹ️  No Lynxz OhMyPosh Theme integration found in $CONFIG_FILE"
    fi
else
    echo "⚠️  Shell config file not found at $CONFIG_FILE"
fi

echo ""

# -----------------------------
# Ask about removing Oh My Posh
# -----------------------------
echo "❓ Would you like to remove Oh My Posh completely?"
read -p "   Note: This may break other prompt configurations. (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️  Removing Oh My Posh..."
    
    if command -v oh-my-posh &> /dev/null; then
        # Try to remove via package manager
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID
            
            case "$DISTRO" in
                arch|cachyos|manjaro)
                    sudo pacman -R oh-my-posh --noconfirm || echo "⚠️  Could not remove via pacman"
                    ;;
                ubuntu|debian)
                    sudo apt remove -y oh-my-posh || echo "⚠️  Could not remove via apt"
                    ;;
                fedora)
                    sudo dnf remove -y oh-my-posh || echo "⚠️  Could not remove via dnf"
                    ;;
                *)
                    echo "⚠️  Manual removal required for your distro"
                    ;;
            esac
            echo "✔ Oh My Posh removal attempted"
        fi
    else
        echo "ℹ️  Oh My Posh already not installed"
    fi
else
    echo "ℹ️  Keeping Oh My Posh installed"
fi

echo ""

# -----------------------------
# Ask about removing Fonts
# -----------------------------
FONT_DIR="$HOME/.local/share/fonts"
echo "❓ Would you like to remove JetBrainsMono Nerd Font?"
read -p "   Note: Other apps may use this font. (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️  Removing JetBrainsMono Nerd Font..."
    
    if [ -d "$FONT_DIR" ]; then
        rm -f "$FONT_DIR"/JetBrainsMono*.ttf 2>/dev/null || true
        
        # Rebuild font cache
        if command -v fc-cache &> /dev/null; then
            fc-cache -fv > /dev/null 2>&1 || true
            echo "✔ Font cache rebuilt"
        fi
        
        echo "✔ JetBrainsMono Nerd Font removed"
    else
        echo "⚠️  Font directory not found at $FONT_DIR"
    fi
else
    echo "ℹ️  Keeping JetBrainsMono Nerd Font"
fi

echo ""
echo "======================================"
echo "✅ Uninstallation Complete!"
echo "======================================"
echo ""
echo "📋 Summary:"
echo "   ✔ OhMyPosh theme removed from $TARGET_DIR"
echo "   ✔ Shell integration removed from $CONFIG_FILE"
echo "   ✔ Config backup saved to $CONFIG_FILE.bak.*"
echo ""
echo "🙏 Thank you for using Lynxz OhMyPosh!"
echo "   Feedback: https://github.com/Lynxz411/Lynxz-ohmyposh"
echo ""
