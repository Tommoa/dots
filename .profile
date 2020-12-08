export ENV=~/.env
export EDITOR=nvim
export PAGER=less
export LS_COLORS="pi=00;33:cd=01;33:di=01;34:so=01;31:ln=00;36:ex=01;32:bd=01;33:or=00;31:fi=00;00"
export PATH=~/.local/bin:~/bin:$PATH

export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

case $(uname) in
    FreeBSD)
        export CARGO_HOME="${CARGO_HOME}_freebsd"
        export RUSTUP_HOME= "${RUSTUP_HOME}_freebsd"
        ;;
esac
case $(uname -m) in
    (i386|i686)
        export CARGO_HOME="${CARGO_HOME}_x32"
        export RUSTUP_HOME="${CARGO_HOME}_x32"
        ;;
esac

if [ -d "$CARGO_HOME/bin" ]
then
    export PATH=$CARGO_HOME/bin:$PATH
fi

# If there's a profile for this specific host, then source it
[ -e ".config/$(uname -n).profile" ] && . .config/$(uname -n).profile