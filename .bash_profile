# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
umask 022

# set some basic environment variables
export EDITOR=nvim
export MAIL=/var/mail/$USER

export PATH=$HOME/.local/bin:$HOME/scripts:$PATH

export PAGER=less
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

alias ls="ls --color"

# Stuff for rust
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

if [[ $(uname) == "FreeBSD" ]]
then
	export CARGO_HOME="$HOME/.cargo_freebsd"
	export RUSTUP_HOME= "$HOME/.rustup_freebsd"
elif [[ $(uname -m) == "i(3|6)86" ]]
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

if [[ -e $CARGO_HOME/bin/ion ]]
then
	exec $CARGO_HOME/bin/ion
	exit
fi
