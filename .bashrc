# ~/.bashrc: executed by bash for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ── History ───────────────────────────────────────────────────────────────────
HISTCONTROL=ignoreboth        # ignore duplicate lines & lines starting with space
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend           # append to history file, don't overwrite

# ── Shell options ─────────────────────────────────────────────────────────────
shopt -s checkwinsize         # update LINES and COLUMNS after each command
shopt -s globstar 2>/dev/null # enable ** glob pattern (bash 4+)
shopt -s cdspell  2>/dev/null # auto-correct minor typos in cd
shopt -s autocd   2>/dev/null # type a directory name to cd into it

# ── Prompt ────────────────────────────────────────────────────────────────────
# Colors
_bold='\[\e[1m\]'
_reset='\[\e[0m\]'
_cyan='\[\e[36m\]'
_green='\[\e[32m\]'
_yellow='\[\e[33m\]'
_red='\[\e[31m\]'

# Show git branch in prompt if inside a git repo
_git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || \
    branch=$(git rev-parse --short HEAD 2>/dev/null)   || \
    return
    printf ' (%s)' "$branch"
}

PS1="${_green}\u@\h${_reset}:${_cyan}\w${_yellow}\$(_git_branch)${_reset}\$ "

# ── Color support ─────────────────────────────────────────────────────────────
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ── Aliases ───────────────────────────────────────────────────────────────────
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Listing
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Convenience
alias c='clear'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'

# Git shortcuts (complements .gitconfig aliases)
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate --all'

# Python
alias py='python3'
alias pip='pip3'

# Editor
alias vi='vim'

# ── Environment ───────────────────────────────────────────────────────────────
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LESS='-R'

# Prefer US English and UTF-8
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# ── PATH additions ────────────────────────────────────────────────────────────
# Local bin
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Node Version Manager
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# pyenv
if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command -v pyenv &>/dev/null; then
        eval "$(pyenv init -)"
    fi
fi

# ── Completion ────────────────────────────────────────────────────────────────
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        # shellcheck source=/dev/null
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        # shellcheck source=/dev/null
        . /etc/bash_completion
    fi
fi

# ── Local overrides ───────────────────────────────────────────────────────────
# Source machine-local settings that should not be version-controlled
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
