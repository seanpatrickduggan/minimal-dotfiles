# Minimal Portable Dotfiles

Plugin-free configs for neovim, tmux, and zsh.

## What's Included

- **nvim** — plugin-free `init.lua` with LSP keymaps, ripgrep integration, netrw
- **tmux** — vi mode, Ctrl+hjkl pane navigation, simple status bar
- **zsh** — git branch in prompt, fzf/zoxide integration, history search, tab completion
- **Dockerfile** — Rocky Linux 8 container for testing
- **deploy.sh** — symlinks configs into place

## Usage

```bash
# Test in container
docker build -t minimal-dotfiles .
docker run -it -v $(pwd):/home/devuser/configs minimal-dotfiles

# Deploy on a real machine
./deploy.sh
```

## Ideas / TODO

- [ ] `Ctrl+Z` toggle between shell and backgrounded nvim
- [ ] `mkcd` function (mkdir + cd)
- [ ] Directory bookmark aliases
- [ ] Neovim: trailing whitespace highlighting autocmd
- [ ] Neovim: `:w!!` sudo-save
- [ ] Tmux: session startup script (predefined layout)
- [ ] Tmux: `prefix + f` to fzf-find sessions/windows
- [ ] Git: work `.gitconfig` with aliases (`gl`, `gds`)
- [ ] `.inputrc` for readline (python REPL, etc.)
- [ ] `bat` config (default theme, paging)
- [ ] `.ripgreprc` (default flags)
