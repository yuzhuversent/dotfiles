# dotfiles

Personal dotfiles for a productive terminal environment, managed as symlinks so every machine stays in sync.

## Contents

| File | Purpose |
|------|---------|
| `.bashrc` | Interactive shell settings – aliases, prompt with git branch, history, completions, PATH |
| `.bash_profile` | Login-shell entry point; sources `.bashrc` |
| `.gitconfig` | Git user settings, aliases, colors, and sane defaults |
| `.gitignore_global` | Machine-wide gitignore (OS junk, editor temp files, common build artifacts) |
| `.vimrc` | Vim settings – indentation, search, key mappings, persistent undo |
| `.tmux.conf` | tmux settings – vi keys, mouse, status bar, sane splits |
| `install.sh` | Symlink all dotfiles into `$HOME` |

## Quick Start

```bash
# Clone the repo
git clone https://github.com/yuzhuversent/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Preview what will happen (no changes made)
bash install.sh --dry-run

# Install (symlinks any missing files)
bash install.sh

# Install and overwrite existing files (backs them up first)
bash install.sh --force
```

After installation, reload your shell:

```bash
source ~/.bashrc
```

## Machine-local overrides

Sensitive or machine-specific settings (work email, private tokens, etc.) should **not** be committed.  
Each dotfile checks for a local override file that you create once per machine:

| Override file | Sourced by |
|---|---|
| `~/.bashrc.local` | `.bashrc` |
| `~/.bash_profile.local` | `.bash_profile` |
| `~/.gitconfig.local` | `.gitconfig` (via `[include]`) |
| `~/.vimrc.local` | `.vimrc` |

Example `~/.gitconfig.local` for work machines:

```ini
[user]
    email = you@work.example.com
```

## Structure

```
dotfiles/
├── .bash_profile
├── .bashrc
├── .gitconfig
├── .gitignore_global
├── .tmux.conf
├── .vimrc
├── install.sh
└── README.md
```

## Adding new dotfiles

1. Add the file to this repository.
2. Add its name to the `DOTFILES` array in `install.sh`.
3. Run `bash install.sh` on each machine.
