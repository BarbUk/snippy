# Snippy

A powerful Linux snippet manager for enhanced productivity and workflow automation.

![snippy](img/snippy.png)

## Overview

Snippy is a versatile command-line snippet manager that seamlessly integrates with your desktop environment to provide quick access to frequently used text snippets, commands, and templates.

## Table of Contents

- [Installation](#installation)
  - [Arch Linux](#arch-linux)
  - [Manual Installation](#manual-installation)
  - [Prerequisites](#prerequisites)
  - [Initial Setup](#initial-setup)
- [Features](#features)
  - [Intelligent Clipboard Management](#intelligent-clipboard-management)
  - [Smart Cursor Positioning](#smart-cursor-positioning)
  - [Dynamic Content Processing](#dynamic-content-processing)
  - [Snippet Headers](#snippet-headers)
  - [Visual Organization](#visual-organization)
- [Usage](#usage)
  - [Command Line Interface](#command-line-interface)
  - [Examples](#examples)
  - [Bash Completion](#bash-completion)
- [Creating Snippets](#creating-snippets)
  - [Basic Snippet](#basic-snippet)
  - [Snippet with Variables](#snippet-with-variables)
  - [Snippet with Placeholders](#snippet-with-placeholders)
  - [Executable Snippet](#executable-snippet)
  - [Script Snippet](#script-snippet)
  - [No-Parse Snippet](#no-parse-snippet)
  - [Rich Snippet (HTML)](#rich-snippet-html)
- [Keyboard Shortcuts](#keyboard-shortcuts)
- [Platform Support](#platform-support)
  - [Display Servers](#display-servers)
  - [Desktop Environments](#desktop-environments)
- [Configuration](#configuration)
  - [Environment Variables](#environment-variables)
  - [Snippet Location](#snippet-location)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Installation

### Arch Linux

[![snippy on AUR](https://img.shields.io/aur/version/snippy-snippet?label=snippy-snippet)](https://aur.archlinux.org/packages/snippy-snippet/)

Snippy is available in the [AUR](https://wiki.archlinux.org/index.php/Arch_User_Repository) as [snippy-snippet](https://aur.archlinux.org/packages/snippy-snippet/).

Install using your preferred [AUR helper](https://wiki.archlinux.org/index.php/AUR_helpers):

```bash
yay -S snippy-snippet
```

### Manual Installation

**For local user installation:**

```bash
curl -fsSL https://github.com/barbuk/snippy/releases/latest/download/snippy \
  --create-dirs --output ~/.bin/snippy
chmod +x ~/.bin/snippy
```

Ensure `~/.bin` is in your `PATH`.

**For system-wide installation:**

```bash
sudo curl -fsSL https://github.com/barbuk/snippy/releases/latest/download/snippy \
  --output /usr/bin/snippy
sudo chmod +x /usr/bin/snippy
```

### Prerequisites

Snippy requires the following dependencies to be installed:

**Core dependencies:**

- `rofi` - Application launcher and menu
- `fzf` - Command-line fuzzy finder
- `jq` - JSON processor

**For X11:**

- `xsel` - Command-line clipboard utility
- `xclip` - Clipboard interface
- `xdotool` - X11 automation tool

**For Wayland:**

- `wtype` - Text input automation
- `wl-clipboard` (`wl-copy` and `wl-paste`)

**Optional (for enhanced features):**

- `bat` or `highlight` - Syntax highlighting in preview
- `perl` - Required for certain text processing features

### Initial Setup

On first run, Snippy will automatically create the configuration directory at `~/.config/snippy` with a sample snippet.

## Features

### Intelligent Clipboard Management

Snippy provides advanced clipboard handling that preserves your workflow:

- **Automatic clipboard restoration** - Your original clipboard content is automatically restored after pasting a snippet
- **Dynamic clipboard integration** - Use `{clipboard}` placeholder to embed current clipboard content into snippets

```mysql
CREATE DATABASE `{clipboard}` CHARACTER SET utf8 COLLATE utf8_general_ci;
```

- **URL-encoded clipboard** - Use `{clipboard_urlencode}` for web-safe clipboard content

```text
https://cachedview.nl/#{clipboard_urlencode}
```

### Smart Cursor Positioning

Control exactly where the cursor lands after snippet insertion using the `{cursor}` placeholder:

**Single-line positioning:**

```html
<pre>{cursor}</pre>
```

**Multi-line positioning:**

```html
<pre>
  {cursor}
</pre>
```

Snippy intelligently handles cursor movement in both CLI and GUI contexts, including special support for Vim.

### Dynamic Content Processing

**Variable expansion:**
Snippy processes snippets through a bash-like template engine, allowing you to use variables and command substitution:

```bash
Current date: $(date +%Y-%m-%d)
Username: $USER
```

**Command execution:**
Snippets starting with `$` are executed as commands, and their output is pasted:

```bash
$(date +%Y-%m-%d-%Hh%Mm%S)
```

**Script execution:**
Bash scripts stored in `$snippets_directory/scripts` are automatically executed when selected.

**Raw content mode:**
Use `Ctrl+Return` to paste the snippet source code instead of its processed output.

### Snippet Headers

Control snippet behavior with special headers:

- `##noparse` - Disable variable expansion and command execution

```bash
##noparse
date --date="$(date +%F) -1 month" +%F
```

- `##tmpfile` - Access temporary file path via `$tmpfile` variable
- `##richsnippet` - Enable HTML clipboard support for rich text pasting

### Visual Organization

Organize your snippets with directory-based categorization. The top-level directory name is used as an icon identifier in rofi:

```text
terminal/
├── commands/
│   └── date
└── scripts/
    └── backup
```

![icons](img/icons.png)

## Usage

### Command Line Interface

```bash
/usr/bin/snippy-snippet 1.0.11

Usage:
  /usr/bin/snippy-snippet [OPTION] ACTION
  Snippy snippets manager
Options
  -h, --help: Show help
  -s, --sort: true or false Sort snippet in rofi (default)
  -m, --sorting-method: fzf (default) or levenshtein
Actions
  gui  Browse snippet and paste it in the focused window (default)
  cli  list snippet in cli mode, only copy snippet in the paste buffer
  edit   Browse snippet and edit it
  add snippet_name   Add a new snippet
  list   list snippet
  cat  list category
  completion   bash completion
```

### Examples

**Browse and paste snippets (GUI mode):**

```bash
snippy
# or explicitly
snippy gui
```

**Browse snippets in terminal:**

```bash
snippy cli
```

**Create a new snippet:**

```bash
snippy add database/mysql-create
```

**Edit an existing snippet:**

```bash
snippy edit
```

**List all snippets:**

```bash
snippy list
```

### Bash Completion

Enable tab completion for Snippy commands and options by adding this line to your `~/.bashrc`:

```bash
eval "$(snippy completion)"
```

## Creating Snippets

Snippets are stored as plain text files in `~/.config/snippy`. The directory structure you create becomes your snippet organization system.

### Basic Snippet

Create a file with your desired content:

```bash
mkdir -p ~/.config/snippy/greetings
echo "Hello from Snippy!" > ~/.config/snippy/greetings/hello
```

### Snippet with Variables

Use bash variable expansion and command substitution:

```bash
mkdir -p ~/.config/snippy/dates
cat > ~/.config/snippy/dates/current-datetime << 'EOF'
Current date and time: $(date '+%Y-%m-%d %H:%M:%S')
User: $USER
EOF
```

### Snippet with Placeholders

Use Snippy's special placeholders:

```bash
mkdir -p ~/.config/snippy/sql
cat > ~/.config/snippy/sql/create-database << 'EOF'
CREATE DATABASE `{clipboard}`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE `{clipboard}`;
{cursor}
EOF
```

### Executable Snippet

Create a snippet that executes a command:

```bash
echo '$(date +%Y-%m-%d-%Hh%Mm%S)' > ~/.config/snippy/dates/timestamp
```

### Script Snippet

Create an executable bash script in the `scripts` directory:

```bash
mkdir -p ~/.config/snippy/scripts
cat > ~/.config/snippy/scripts/system-info << 'EOF'
#!/bin/bash
echo "System Information"
echo "=================="
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
EOF
```

### No-Parse Snippet

Prevent processing of special characters:

```bash
cat > ~/.config/snippy/examples/raw << 'EOF'
##noparse
This will be pasted as-is: $(date) $USER {cursor} {clipboard}
EOF
```

### Rich Snippet (HTML)

Enable HTML clipboard support:

```bash
cat > ~/.config/snippy/html/bold-text << 'EOF'
##richsnippet
<strong>{clipboard}</strong>
EOF
```

## Keyboard Shortcuts

When using the GUI mode with rofi:

- **Enter** - Paste processed snippet (variables expanded, commands executed)
- **Ctrl+Return** - Paste raw snippet content without processing
- **Escape** - Cancel snippet selection

## Platform Support

### Display Servers

- **X11** - Full support with xdotool, xsel, and xclip
- **Wayland** - Full support with wl-clipboard and wtype

### Desktop Environments

Snippy has been tested and works with:

- **Wayland compositors:**

  - Sway
  - Hyprland
  - Niri

- **X11 window managers:**

  - All X11 window managers should be supported

## Configuration

Snippy uses a convention-over-configuration approach. Most behavior is controlled through snippet headers and directory structure rather than configuration files.

### Environment Variables

- `XDG_CONFIG_HOME` - If set, snippets are stored in `$XDG_CONFIG_HOME/snippy`
- `EDITOR` - Used for editing snippets (defaults to `vim`)

### Snippet Location

Default: `~/.config/snippy`

You can organize snippets in subdirectories. The top-level directory name is used as the icon identifier in rofi.

## Contributing

Contributions are welcome! Here are ways you can help:

- Report bugs and request features via [GitHub Issues](https://github.com/barbuk/snippy/issues)
- Submit pull requests for bug fixes and enhancements
- Improve documentation
- Share your snippet collections and use cases

## License

Snippy is licensed under the [GNU General Public License v3.0](LICENSE).

## Acknowledgments

Snippy builds upon the work of several contributors:

- **barbuk** - Current maintainer ([GitHub](https://github.com/barbuk))
- **opennomad** - Major enhancements ([Gist](https://gist.github.com/opennomad/15c4d624dce99066a82d))
- **mhwombat** - Original concept ([Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?id=71938&p=2))
- **sessy** - Initial implementation ([Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?id=71938))

Special thanks to the open-source community for the excellent tools that make Snippy possible: rofi, fzf, and all the clipboard and automation utilities.
