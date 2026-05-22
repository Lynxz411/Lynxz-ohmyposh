# 🎨 Lynxz OhMyPosh Theme

> Custom OhMyPosh theme for Fish shell with elegant prompt design

<div align="center">

[![Shell](https://img.shields.io/badge/Shell-100%25-brightgreen?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![OhMyPosh](https://img.shields.io/badge/OhMyPosh-Latest-blue?logo=powershell&logoColor=white)](https://ohmyposh.dev)
[![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE)
[![Stars](https://img.shields.io/github/stars/Lynxz411/Lynxz-ohmyposh?style=social)](https://github.com/Lynxz411/Lynxz-ohmyposh)

</div>

---

## 📸 Preview

This theme provides a beautiful and informative prompt for your shell with:
- **Clean minimal design** - Focused on readability
- **Git integration** - Shows branch and status
- **Directory info** - Current path with nerd font icons
- **Time display** - Timestamp on the right
- **Multi-shell support** - Works with Bash, Zsh, and Fish

*For a complete visual example, check out [Lynxz-fastfetch](https://github.com/Lynxz411/Lynxz-fastfetch)*

---

## ✨ Features

- 🎯 **Minimal & Elegant** - Clean prompt without clutter
- 🐚 **Multi-shell support** - Bash, Zsh, Fish
- 🧬 **Git integration** - Branch name & status indicators
- 🔤 **Nerd Font icons** - Beautiful glyphs & symbols
- ⏰ **Time display** - Right-aligned timestamp
- 📁 **Path shortening** - Smart directory abbreviation
- 🎨 **Customizable colors** - Easy theme modifications
- 💾 **One-liner install** - Quick setup with automatic dependencies
- 🗑️ **Clean uninstall** - Complete removal with backups

---

## 📋 Requirements

| Component | Purpose | Auto-Install |
|-----------|---------|:--------------:|
| **OhMyPosh** | Prompt engine | ✅ Yes |
| **Nerd Font** | Icons & glyphs | ✅ Yes |
| **curl** | Download files | ✅ Yes |
| **unzip** | Extract archives | ✅ Yes |
| **fontconfig** | Font management | ✅ Yes |

### Supported Distros
- ✅ **Arch Linux** (pacman)
- ✅ **Manjaro** (pacman)
- ✅ **CachyOS** (pacman)
- ✅ **Ubuntu/Debian** (apt)
- ✅ **Fedora** (dnf)

---

## 🚀 Quick Start

### One-liner Installation
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Lynxz411/Lynxz-ohmyposh/main/install.sh)"
```

### Manual Installation
```bash
git clone https://github.com/Lynxz411/Lynxz-ohmyposh.git
cd Lynxz-ohmyposh
chmod +x install.sh
./install.sh
```

---

## 🛠️ Installation Details

The installer automatically:

1. ✅ **Detects your Linux distro** - Identifies your package manager
2. ✅ **Installs dependencies** - curl, unzip, fontconfig
3. ✅ **Installs OhMyPosh** - Latest version for your distro
4. ✅ **Installs fonts** - JetBrainsMono Nerd Font
5. ✅ **Detects your shell** - Bash, Zsh, or Fish
6. ✅ **Configures shell** - Injects theme initialization
7. ✅ **Tests configuration** - Verifies setup success

---

## ⚙️ Configuration

The theme config is located at:
```
~/.config/ohmyposh/lynxz.omp.json
```

### Customizing the Theme
```bash
# Edit the theme configuration
nano ~/.config/ohmyposh/lynxz.omp.json

# Common customizations:
# - Change colors in "palette" section
# - Modify segments in "blocks" array
# - Adjust spacing & symbols
# - Add/remove information modules
```

### JSON Structure
```json
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "palette": {},        // Colors used in theme
  "blocks": [],         // Prompt segments
  "transient": {}       // (Optional) Previous command prompt
}
```

---

## 🗑️ Uninstallation

### Quick Uninstall
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Lynxz411/Lynxz-ohmyposh/main/uninstall.sh)"
```

### Manual Uninstall
```bash
cd Lynxz-ohmyposh
chmod +x uninstall.sh
./uninstall.sh
```

### What Gets Removed

The uninstaller will:
- ❌ Remove theme from `~/.config/ohmyposh/`
- ❌ Remove shell integration from `.bashrc`/`.zshrc`/`config.fish`
- ❌ Backup shell config files (with timestamp)
- ❓ Ask about removing OhMyPosh (optional)
- ❓ Ask about removing fonts (optional)

---

## 🔧 Troubleshooting

### Theme not appearing on shell startup
```bash
# Reload your shell configuration
source ~/.bashrc   # for bash
source ~/.zshrc    # for zsh
# Fish auto-reloads on config change
```

### Fonts not rendering correctly
```bash
# Rebuild font cache
fc-cache -fv

# Check if font is installed
fc-list | grep -i jetbrains
```

### OhMyPosh command not found
```bash
# Verify installation
which oh-my-posh

# Try to install manually
curl -s https://ohmyposh.dev/install.sh | bash
```

### Permission denied when running scripts
```bash
# Make scripts executable
chmod +x install.sh uninstall.sh
```

### Different prompts on different shells
```bash
# Each shell has its own config file
~/.bashrc          # Bash
~/.zshrc           # Zsh
~/.config/fish/config.fish  # Fish

# Make sure theme init is in all configs
```

---

## 📁 Directory Structure

```
Lynxz-ohmyposh/
├── install.sh              # Installation script
├── uninstall.sh            # Uninstallation script
├── lynxz.omp.json          # Theme configuration
├── README.md               # This file
├── LICENSE                 # MIT License
└── .gitignore              # Git ignore rules
```

---

## 💡 Tips & Tricks

### Backup your theme before editing
```bash
cp ~/.config/ohmyposh/lynxz.omp.json ~/.config/ohmyposh/lynxz.omp.json.backup
```

### Test theme changes without reloading shell
```bash
oh-my-posh print-config --config ~/.config/ohmyposh/lynxz.omp.json
```

### View available themes for inspiration
```bash
oh-my-posh init fish --print-themes
```

### Speed up shell startup
```bash
# If startup is slow, check what's taking time
time bash -i -c echo  # Bash
time zsh -i -c echo   # Zsh
```

---

## 🎨 Theme Customization Examples

### Changing prompt symbol
```bash
# Edit the symbol in lynxz.omp.json
# Look for "symbol" property and change to your preference
# Popular choices: ❯ λ ➜ $ ➪ 🐚
```

### Adding new information segment
```bash
# Add new segment to "blocks" array
# Available segment types: git, battery, env, time, os, etc.
```

### Using different color scheme
```bash
# Modify the "palette" section
# Use hex colors: "#FF5733", "#28A745", etc.
```

---

## 🤝 Integration Tips

### Kitty Terminal + OhMyPosh
```bash
# Set font in kitty config
font_family JetBrainsMono Nerd Font
```

### Fish Shell Specific
```bash
# Use abbreviations instead of aliases
abbr -a ll 'ls -la'
abbr -a gs 'git status'
```

### SSH Sessions
```bash
# OhMyPosh works over SSH
# Make sure OhMyPosh is installed on remote
# And nerd fonts are available locally
```

---

## 📚 Resources

- 🌐 [OhMyPosh Documentation](https://ohmyposh.dev)
- 🎨 [OhMyPosh Theme Documentation](https://ohmyposh.dev/docs/configuration/overview)
- 🔤 [Nerd Fonts](https://www.nerdfonts.com)
- 🐚 [Fish Shell](https://fishshell.com)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Credits

- **OhMyPosh** - Modern prompt engine
- **Nerd Fonts** - Font collection with icons
- **Lynxz** - Custom theme & installation scripts

---

<div align="center">

**Made with ❤️ by [Lynxz](https://github.com/Lynxz411)**

⭐ If you like this project, please give it a star!

[Report Issue](https://github.com/Lynxz411/Lynxz-ohmyposh/issues) • [Request Feature](https://github.com/Lynxz411/Lynxz-ohmyposh/issues/new) • [Discussions](https://github.com/Lynxz411/Lynxz-ohmyposh/discussions)

</div>
