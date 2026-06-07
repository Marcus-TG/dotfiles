# dotfiles

Personal configuration for macOS and Linux.

## Install

```sh
git clone git@github.com:Marcus-TG/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` detects the OS, installs packages (Homebrew on macOS, `yay` on
Linux), then symlinks the configs into place. Existing `~/.zshrc` and
`~/.gitconfig` are backed up to `*.backup` before linking.

## What's here

| Path    | Symlinked to       | Purpose                                  |
| ------- | ------------------ | ---------------------------------------- |
| `zsh/`  | `~/.zshrc`         | Shell aliases, completion, tool init     |
| `git/`  | `~/.gitconfig`     | Git identity and URL rewrites            |
| `nvim/` | `~/.config/nvim`   | Neovim config (kickstart.nvim based)     |

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
