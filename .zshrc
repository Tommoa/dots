# set the umask
umask 022

# set some basic environment variables
export EDITOR=nvim
export MAIL=/var/mail/$USER

# this is the path - this one should allow
# the user to use most applications on most machines.
export PATH=$HOME/.local/bin:$HOME/scripts:$PATH
PROMPT=%U%m%u:%~\>\ 
RPROMPT=%T
# some convienience settings
export PYTHONSTARTUP=$HOME/.pyrc
# make less more friendly for non-text input files, see lesspipe(1)
export PAGER=less
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# some example (and useful) aliases
alias ls="ls --color"

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
	export PAGER=bat
fi

if [[ -e $CARGO_HOME/bin/ion ]]
then
	exec $CARGO_HOME/bin/ion
	exit
fi
