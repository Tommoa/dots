# set the umask
umask 022

# set some basic environment variables
export EDITOR=nvim
export MAIL=/var/mail/$USER

# this is the path - this one should allow
# the user to use most applications on most machines.
export PATH=$HOME/.local/bin:$HOME/scripts:$PATH
prompt_git() {
    if [[ -n GIT_PROMPT && $GIT_PROMPT = 1 ]] && git rev-parse --is-inside-work-tree -q &> /dev/null; then
        (( num_added = 0 ))
        (( num_removed = 0 ))
        for line in "$(git diff-files --numstat -r)"; do
            new_added=0$(echo $line | cut -f1)
            new_removed=0$(echo $line | cut -f2)
            let "num_added += ${new_added}"
            let "num_removed += ${new_removed}"
        done
        totals="";
        if [[ $num_added -gt 0 || $num_removed -gt 0 ]]; then
            totals=":"
            if [[ $num_added -gt 0 ]]; then
                totals="$totals%%F{85}+$num_added"
            fi
            if [[ $num_removed -gt 0 ]]; then
                totals="$totals%%F{red}-$num_removed"
            fi
        fi
        printf "%%B[%%F{red}$(git symbolic-ref --short -q HEAD || git rev-parse --short HEAD)%%f$totals%%f] %%b"
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
HISTSIZE=1000
SAVEHIST=1000

# key bindings
bindkey '^[=' expand-cmd-path
# tab completion
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
# arrow keys
bindkey '^U' kill-whole-line
# ^U kills the entire line, not just back from cursor
bindkey -v
bindkey '^R' history-incremental-search-backward

# Disable core dumps
limit coredumpsize 0

# The following lines were added by compinstall

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

autoload -U compinit
compinit
# End of lines added by compinstall

export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

if [[ $(uname) == "FreeBSD" ]]
then
	export CARGO_HOME="$HOME/.cargo_freebsd"
	export RUSTUP_HOME= "$HOME/.rustup_freebsd"
elif [[ $(lscpu | grep 'Architecture' | cut -f2 -d: | egrep -o "\S+") == "i686" ]]
then
	export CARGO_HOME="$HOME/.cargox32"
	export RUSTUP_HOME="$HOME/.rustupx32"
fi

if [[ -e $CARGO_HOME/env ]]
then
	source $CARGO_HOME/env
fi

if [[ -e $CARGO_HOME/bin/bat ]]
then
	export PAGER=$CARGO_HOME/bin/bat
fi

if [[ -z $SSH_CLIENT && -z $VIMRUNTIME && -z $TMUX ]]; then
    # Only launch TMUX if we're not in an SSH session
    # and we're not in a VIM session
    # and we're not already in a TMUX session
    tmux=$(/usr/bin/env which tmux)
    ns=$($tmux list-sessions | wc -l)
    (( sessions = ns ))
    echo $sessions
    if [[ $sessions -gt 0 ]]; then
        exec $tmux attach
    else
        exec $tmux new-session
    fi
fi

mux() {
    tmux=$(/usr/bin/env which tmux)
    fd=$(/usr/bin/env which fd || /usr/bin/env which fdfind)
    dir=$($fd --no-ignore -i -td "$1" ~/Documents | awk -F'/' 'NR==1{n=NF; m=$0} NF<n{ m=$0; n=NF } END { print m }')
    $tmux if-shell                      \
        "$tmux has-session -t $1" \
        "switch-client -t $1"     \
        "new-session -ds $1 -c $dir; switch-client -t $1"
}

export GIT_PROMPT=1
