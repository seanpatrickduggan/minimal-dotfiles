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

## Windows Client Notes

These dotfiles live on the remote Linux box. The client (Windows) setup is out of scope for this repo,
but a few notes for Alacritty users:

**Shell:** Alacritty defaults to PowerShell on Windows. For a pure SSH workflow (open terminal → ssh → done),
the local shell doesn't matter — PowerShell is fine. Git Bash and MSYS2 won't improve copy/paste or
any SSH-related experience; both run through a POSIX emulation layer that makes local commands noticeably
slow. Only worth considering if you want Unix coreutils available locally and can accept that tradeoff.

**Paste keybinding:** Alacritty's default paste shortcut is `Ctrl+Shift+V` (unlike Windows Terminal's `Ctrl+V`).
To remap to `Ctrl+V` in `alacritty.toml`:
```toml
[keyboard]
bindings = [
  { key = "V", mods = "Control", action = "Paste" },
]
```

## Ideas / TODO

- [ ] If remote nvim is 0.10+, replace the manual OSC 52 clipboard implementation in `nvim/init.lua`
      with the built-in provider: `vim.g.clipboard = require("vim.clipboard.osc52")` (check with `nvim --version`)

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
