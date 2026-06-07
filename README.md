# dotfiles

Personal configuration for macOS and Linux.

## Install

```sh
git clone git@github.com:Marcus-TG/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` detects the OS, installs packages, then symlinks the configs into
place. Existing `~/.zshrc` and `~/.gitconfig` are backed up to `*.backup`
before linking. Package sources by platform:

- **macOS** — Homebrew
- **Arch** — `yay`
- **Ubuntu/Debian** — `apt` for what's packaged, plus the official installers
  (starship, atuin), `cargo` (yazi, tree-sitter-cli), and GitHub release
  binaries (lazygit, lazydocker) for the rest. `bat` is symlinked from
  `batcat`. Ghostty has no apt package — install it manually.

## What's here

| Path    | Symlinked to       | Purpose                                  |
| ------- | ------------------ | ---------------------------------------- |
| `zsh/`  | `~/.zshrc`         | Shell aliases, completion, tool init     |
| `git/`  | `~/.gitconfig`     | Git identity and URL rewrites            |
| `nvim/` | `~/.config/nvim`   | Neovim config (kickstart.nvim based)     |
| `ghostty/` | `~/.config/ghostty` | Ghostty terminal config + GLSL shaders |
| `starship/` | `~/.config/starship.toml` | Catppuccin Mocha prompt          |
| `bat/`  | `~/.config/bat`    | `bat` theme (Catppuccin Mocha)           |

## Aliases & functions

Defined in `zsh/.zshrc`:

| Alias / fn | Expands to        | Purpose                                  |
| ---------- | ----------------- | ---------------------------------------- |
| `ls`       | `eza --icons`     | Directory listing with file-type icons   |
| `tree`     | `eza -T`          | Recursive tree view                      |
| `grep`     | `grep --color=auto` | Colorized matches                      |
| `cat`      | `bat`             | Syntax-highlighted, paged `cat`          |
| `cd`       | `z`               | zoxide jump (frecency-based `cd`)        |
| `cds`      | `zi`              | zoxide interactive directory picker      |
| `lg`       | `lazygit`         | Git TUI                                  |
| `ld`       | `lazydocker`      | Docker TUI                               |
| `..`       | `cd ..`           | Up one directory                         |
| `...`      | `cd ../..`        | Up two directories                       |
| `....`     | `cd ../../..`     | Up three directories                     |
| `.....`    | `cd ../../../..`  | Up four directories                      |
| `y`        | function          | Open `yazi`; `cd` to its dir on quit     |

## Tools

Installed via `install.sh`:

- **eza** — `ls` replacement
- **bat** — `cat` replacement
- **zoxide** — smarter `cd`
- **starship** — shell prompt
- **atuin** — shell history
- **yazi** — terminal file manager (`y` to cd on quit)
- **fastfetch** — system info on shell start
- **lazygit** / **lazydocker** — git and docker TUIs
- **colima** + **docker** / **docker-compose** — container runtime
- **ghostty** — terminal emulator
