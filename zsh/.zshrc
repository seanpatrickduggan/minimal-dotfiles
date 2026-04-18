# Minimal .zshrc — no frameworks, no plugins

# -------------------------------------------------------------------
# Prompt
# -------------------------------------------------------------------
# Simple prompt: user@host:path (branch) $
setopt PROMPT_SUBST
# Override these to hardcode your prompt identity:
# user_display="sean"
# host_display="myhost"
user_display="${user_display:-%n}"
host_display="${host_display:-%m}"

# Branch name via git plumbing (one fork, no status/dirty/action checks).
# Falls back to short SHA when detached so we never show a misleading state.
git_branch() {
    local ref
    ref=$(git symbolic-ref --short HEAD 2>/dev/null) \
        || ref=$(git rev-parse --short HEAD 2>/dev/null) \
        || return
    print -n " (${ref})"
}

precmd() {
    local venv=""
    [[ -n "$VIRTUAL_ENV" ]] && venv="%F{green}(${VIRTUAL_ENV:t})%f "
    PROMPT="${venv}%F{blue}${user_display}@${host_display}%f:%F{cyan}%~%f$(git_branch) $ "
}

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

# Fix Ctrl+arrows (word navigation) and Delete key
bindkey '^[[1;5C' forward-word       # Ctrl+Right
bindkey '^[[1;5D' backward-word      # Ctrl+Left
bindkey '^[[3~'   delete-char        # Delete
bindkey '^[[H'    beginning-of-line  # Home
bindkey '^[[F'    end-of-line        # End
bindkey '^[[Z'    reverse-menu-complete  # Shift+Tab (cycle completions backward)

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
bindkey "^[[A" up-line-or-beginning-search    # Up arrow (CSI)
bindkey "^[[B" down-line-or-beginning-search  # Down arrow (CSI)
bindkey "^[OA" up-line-or-beginning-search    # Up arrow (SS3, application mode)
bindkey "^[OB" down-line-or-beginning-search  # Down arrow (SS3, application mode)

# -------------------------------------------------------------------
# Environment
# -------------------------------------------------------------------
# Ensure 256color support (Docker/SSH can pass weird TERM values)
[[ "$TERM" != *256color* ]] && export TERM="xterm-256color"

export EDITOR="nvim"
export VIRTUAL_ENV_DISABLE_PROMPT=1
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
