# Minimal .zshrc — no frameworks, no plugins

# -------------------------------------------------------------------
# Prompt
# -------------------------------------------------------------------
# Simple prompt: user@host:path (branch) $
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{blue}%n@%m%f:%F{cyan}%~%f%F{yellow}${vcs_info_msg_0_}%f $ '

# -------------------------------------------------------------------
# Options
# -------------------------------------------------------------------
setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS   # remove older duplicate when new one is added
setopt HIST_REDUCE_BLANKS     # trim whitespace
setopt HIST_SAVE_NO_DUPS      # no dupes written to file
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY        # save timestamp + duration

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# Emacs keybindings
bindkey -e

# Completion system
autoload -Uz compinit && compinit
eval "$(dircolors -b 2>/dev/null)" # sets LS_COLORS
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select                    # tab cycles, arrows navigate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive matching

# History-based suggestions (inline ghost text)
# zsh-autosuggestions needs a plugin, but we can approximate with history search:
# Up/Down search history filtered by what you've typed so far
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# -------------------------------------------------------------------
# Environment
# -------------------------------------------------------------------
# Ensure 256color support (Docker/SSH can pass weird TERM values)
[[ "$TERM" != *256color* ]] && export TERM="xterm-256color"

export EDITOR="nvim"
export PATH="$HOME/bin:$PATH"

# Ripgrep shorthand (don't shadow grep — scripts depend on grep's output format)
if command -v rg &>/dev/null; then
    alias rg='rg --smart-case'
fi

# -------------------------------------------------------------------
# Aliases — Git
# -------------------------------------------------------------------
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'

# -------------------------------------------------------------------
# Aliases — ls (plain, no eza)
# -------------------------------------------------------------------
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lah'
alias l1='ls -1'

# -------------------------------------------------------------------
# Aliases — Utilities
# -------------------------------------------------------------------
alias n='nvim'
alias nf='nvim $(fzf)'                          # fuzzy find file → open in nvim
alias rgf='rg --line-number . | fzf'             # fuzzy search file contents
alias nrf='nvim $(rg --line-number . | fzf | cut -d: -f1)'  # search contents → open in nvim
alias t='tmux'

# -------------------------------------------------------------------
# FZF integration (if available)
# -------------------------------------------------------------------
if command -v fzf &>/dev/null; then
    # Ctrl+T: paste selected file, Ctrl+R: search history, Alt+C: cd to dir
    if [[ -f /usr/share/fzf/shell/key-bindings.zsh ]]; then
        source /usr/share/fzf/shell/key-bindings.zsh
    elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
        source /usr/share/fzf/key-bindings.zsh
    fi
fi

# -------------------------------------------------------------------
# Zoxide (if available — bring static binary)
# -------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd=z
fi

# -------------------------------------------------------------------
# Local overrides (not tracked in git)
# -------------------------------------------------------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
