# -------------------------------------
# 環境変数
# -------------------------------------

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# エディタ
export EDITOR=/usr/bin/vim

# ページャ
export PAGER=/usr/local/bin/vimpager
export MANPAGER=/usr/local/bin/vimpager

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

if [ -x "`which go`" ]; then
    export GOPATH=$HOME/.go
    export PATH=$PATH:$GOPATH/bin
fi

#export PATH="$(brew --prefix homebrew/php/php70)/bin:$PATH"
NODEBREW_HOME=/usr/local/var/nodebrew/current
export NODEBREW_HOME
export NODEBREW_ROOT=/usr/local/var/nodebrew

export PATH=$PATH:$NODEBREW_HOME/bin
#export PATH=/usr/local/bin:${PATH}

export PATH="$HOME/.pyenv/shims:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.nodebrew/current/bin:$PATH"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH=$PATH:$HOME/.nodebrew/current/bin
export XDG_CONFIG_HOME=$HOME/.config # neovim

