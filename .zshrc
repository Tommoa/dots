# set the umask
umask 022

autoload -U colors && colors

# set some basic environment variables
export EDITOR=nvim
export MAIL=/var/mail/$USER

{
    # Technically not strictly POSIX because "local", but `dash` supports it
    if [ -z "$SSH_CLIENT" -a -z "$VIMRUNTIME" -a -z "$TMUX" ]; then
        # Only launch TMUX if we're not in an SSH session
        # and we're not in a VIM session
        # and we're not already in a TMUX session
        local tmux=$(/usr/bin/env which tmux)
        [ -z $tmux ] && return
        local ns=$($tmux list-sessions | wc -l)
        if [ "$ns" -gt 0 ]; then
            exec $tmux attach
        else
            exec $tmux new-session
        fi
    fi
}

export PATH=$HOME/.local/bin:$HOME/scripts:$PATH
prompt_git() {
    # This can't actually be turned into a flly POSIX function because it
    # shifts the RPROMPT
    # For future reference, here are the necessary colours
    #
    # blue="\e[38;5;4m"
    # green="\e[38;5;85m"
    # red="\e[38;5;1m"
    # reset="\e[m"
    # bold="\e[1m"

    if [ "$GIT_PROMPT" = "1" ] && git rev-parse --is-inside-work-tree -q >/dev/null 2>&1; then
        eval $(git diff-files --numstat -r 2>/dev/null | awk '{add+=$1; remove+=$2} END {printf "num_added='%d';num_removed='%d';total='%d';", add, remove, NR}')
        totals="";
        if [ "$total" -gt 0 ]; then
            totals=":%%F{blue}$total"
            if [ "$num_added" -gt 0 ]; then
                totals="$totals%%F{85}+$num_added"
            fi
            if [ "$num_removed" -gt 0 ]; then
                totals="$totals%%F{red}-$num_removed"
            fi
        fi
        printf "%%B[%%F{red}$(git symbolic-ref --short -q HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)%%f$totals%%f] %%b"
    fi
}
setopt prompt_subst
PROMPT=%F{85}%B%n${SSH_CLIENT:+%F{red}@%F{cyan}%U%m%u}%f:%F{75}%~%f\#%b\ \$(prompt_git)
RPROMPT=%T
# some convienience settings
export PYTHONSTARTUP=$HOME/.pyrc
# make less more friendly for non-text input files, see lesspipe(1)
export PAGER=less
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# some example (and useful) aliases
alias ls="exa --color=auto"

# zsh options - see zshoptions(1)
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_NO_STORE INTERACTIVE_COMMENTS
setopt LONG_LIST_JOBS PRINT_EXIT_VALUE RC_QUOTES
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# key bindings
# tab completion
bindkey '^[=' expand-cmd-path
# arrow keys
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "${terminfo[kcuu1]}" history-beginning-search-backward-end
bindkey "${terminfo[kcud1]}" history-beginning-search-forward-end
# ^U kills the entire line, not just back from cursor
bindkey '^U' kill-whole-line
bindkey '^R' history-incremental-search-backward

bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

# Disable core dumps
limit coredumpsize 0

LS_COLORS="pi=00;33:cd=01;33:di=01;34:so=01;31:ln=00;36:ex=01;32:bd=01;33:or=00;31:fi=00;00"

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=long

ZLS_COLOURS="${(s.:.)LS_COLORS}"
autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit

export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

if [ "$(uname)" = "FreeBSD" ]
then
	export CARGO_HOME="$HOME/.cargo_freebsd"
	export RUSTUP_HOME= "$HOME/.rustup_freebsd"
elif [ "$(uname -m)" = "i686" ]
then
	export CARGO_HOME="$HOME/.cargox32"
	export RUSTUP_HOME="$HOME/.rustupx32"
fi

if [ -e $CARGO_HOME/env ]
then
	. $CARGO_HOME/env
fi

mux() {
    local tmux=$(/usr/bin/env which tmux)
    local fd=$(/usr/bin/env which fd || /usr/bin/env which fdfind)
    [ -z $tmux ] && return
    [ -z $fd ] && return
    local dir=$($fd --no-ignore -i -td "$1" ~/Documents | awk -F'/' 'NR==1{n=NF; m=$0} NF<n{ m=$0; n=NF } END { print m }')
    $tmux if-shell                      \
        "$tmux has-session -t $1" \
        "switch-client -t $1"     \
        "new-session -ds $1 -c $dir; switch-client -t $1"
}

alias tls="tmux list-sessions"

setopt auto_cd
stty -ixon
export GIT_PROMPT=1
