# -------------------------------------
# zshのオプション
# -------------------------------------

## 補完機能の強化
# Nix or Homebrew plugin paths
if [[ -d "/run/current-system/sw/share" ]]; then
  _plugin_base="/run/current-system/sw/share"
  _abbr_dir="${_plugin_base}/zsh/zsh-abbr"
elif type brew &>/dev/null; then
  _plugin_base="$(brew --prefix)/share"
  _abbr_dir="${_plugin_base}/zsh-abbr"
fi

if [[ -n "$_plugin_base" ]]; then
  FPATH=${_plugin_base}/zsh-completions:$FPATH
  FPATH=${_abbr_dir}:$FPATH
fi
autoload -U compinit
compinit

## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない
setopt nobeep

## 色を使う
setopt prompt_subst

## ^Dでログアウトしない。
setopt ignoreeof

## バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

# 補完
## タブによるファイルの順番切り替えをしない
unsetopt auto_menu

# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd

# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd

# -------------------------------------
# パス
# -------------------------------------

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

# path=(
#     $HOME/bin(N-/)
#     /usr/local/bin(N-/)
#     /usr/local/sbin(N-/)
#     $path
# )

# -------------------------------------
# プロンプト
# -------------------------------------

autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz is-at-least

# begin VCS
zstyle ":vcs_info:*" enable git svn hg bzr
zstyle ":vcs_info:*" formats "(%s)-[%b]"
zstyle ":vcs_info:*" actionformats "(%s)-[%b|%a]"
zstyle ":vcs_info:(svn|bzr):*" branchformat "%b:r%r"
zstyle ":vcs_info:bzr:*" use-simple true

zstyle ":vcs_info:*" max-exports 6

if is-at-least 4.3.10; then
    zstyle ":vcs_info:git:*" check-for-changes true # commitしていないのをチェック
    zstyle ":vcs_info:git:*" stagedstr "<S>"
    zstyle ":vcs_info:git:*" unstagedstr "<U>"
    zstyle ":vcs_info:git:*" formats "(%b) %c%u"
    zstyle ":vcs_info:git:*" actionformats "(%s)-[%b|%a] %c%u"
fi

function vcs_prompt_info() {
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && echo -n " %{$fg[yellow]%}$vcs_info_msg_0_%f"
}
# end VCS

PROMPT=""
PROMPT+="%(?.%F{green}$OK%f.%F{red}$NG%f) "
PROMPT+="%F{blue}%~%f"
PROMPT+="\$(vcs_prompt_info)"
PROMPT+="
"
PROMPT+="%% "

RPROMPT="[%*]"

# -------------------------------------
# エイリアス (デフォルトオプション上書き系のみ残す)
# -------------------------------------

# -n 行数表示, -I バイナリファイル無視, svn関係のファイルを無視
alias grep="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# ls
alias ls="ls -G" # color for darwin

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける

# vim
alias vim='nvim'

# g++
alias g++='g++ -std=c++17'


# -------------------------------------
# キーバインド
# -------------------------------------

bindkey -e

function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup

bindkey "^R" history-incremental-search-backward

# -------------------------------------
# fzf
# References: https://github.com/junegunn/fzf/wiki/examples
# -------------------------------------

if [[ -f ~/.zsh-interactive-cd.plugin.zsh ]]; then
  source ~/.zsh-interactive-cd.plugin.zsh
fi

# cd

# fd - cd into the selected directory
# This one differs from the above, by only showing the sub directories and not
#  showing the directories within those.
function fd() {
  DIR=`find * -maxdepth 0 -type d -print 2> /dev/null | fzf-tmux` \
    && cd "$DIR"
}

# fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

function fcd() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}

fb() {
  (git branch | fzf)
}
# git checkout
function sw() {
  git switch `fb`
}

# history

# fh - repeat history
function fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

zle -N fd
zle -N fds
zle -N fcd
zle -N fb
zle -N sw
zle -N fh

# tmux

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# dev - プロジェクト用4ウィンドウtmuxセッションを起動
# 使い方: dev [セッション名]  (省略時はカレントディレクトリ名)
# ウィンドウ構成: 1:nvim  2:terminal  3:claude  4:lazygit
dev() {
  local session_name=${1:-$(basename "$PWD")}
  session_name=${session_name//./_}

  if tmux has-session -t "$session_name" 2>/dev/null; then
    [[ -n "$TMUX" ]] && tmux switch-client -t "$session_name" || tmux attach-session -t "$session_name"
    return
  fi

  tmux new-session  -d -s "$session_name" -n "nvim"     -c "$PWD"
  tmux send-keys    -t "$session_name:1" "nvim ." Enter

  tmux new-window   -t "$session_name" -n "terminal" -c "$PWD"

  tmux new-window   -t "$session_name" -n "claude"   -c "$PWD"
  tmux send-keys    -t "$session_name:3" "claude" Enter

  tmux new-window   -t "$session_name" -n "lazygit"  -c "$PWD"
  tmux send-keys    -t "$session_name:4" "lazygit" Enter

  tmux select-window -t "$session_name:1"

  [[ -n "$TMUX" ]] && tmux switch-client -t "$session_name" || tmux attach-session -t "$session_name"
}

# homebrew

# Install (one or multiple) selected application(s)
# using "brew search" as source input
# mnemonic [B]rew [I]nstall [P]lugin
bip() {
  local inst=$(brew search | fzf -m)

  if [[ $inst ]]; then
    for prog in $(echo $inst);
    do; brew install $prog; done;
  fi
}

# Update (one or multiple) selected application(s)
# mnemonic [B]rew [U]pdate [P]lugin
bup() {
  local upd=$(brew leaves | fzf -m)

  if [[ $upd ]]; then
    for prog in $(echo $upd);
    do; brew upgrade $prog; done;
  fi
}

# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
bcp() {
  local uninst=$(brew leaves | fzf -m)

  if [[ $uninst ]]; then
    for prog in $(echo $uninst);
    do; brew uninstall $prog; done;
  fi
}

# ghq + fzf search
function ghq-fzf() {
  local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf

# -------------------------------------
# その他
# -------------------------------------

# cdしたあとで、自動的に ls する
function chpwd() { ls }

# iTerm2のタブ名を変更する
function title {
    echo -ne "\033]0;"$*"\007"
}

export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"
export CPATH=`xcrun --show-sdk-path`/usr/include

export PATH=$PATH:/usr/local/bin

export PATH="$HOME/.nodebrew/current/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

if [ -d "$HOME/ac-library" ]; then
  export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:$HOME/ac-library"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
export PATH="/usr/local/opt/qt@5/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/atsuyoshi/.lmstudio/bin"
# End of LM Studio CLI section

# Claude Code
export PATH="$HOME/.local/bin:$PATH"

# Added by Antigravity
export PATH="/Users/atsuyoshi/.antigravity/antigravity/bin:$PATH"

# -------------------------------------
# プラグイン
# -------------------------------------

# zsh-abbr: fish風の展開型abbreviation
source ${_abbr_dir}/zsh-abbr.zsh

# zsh-autosuggestions: 履歴ベースの入力候補をグレー表示 (→キーで確定)
source ${_plugin_base}/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting: 入力中のコマンドに色付け (必ず最後に読み込む)
source ${_plugin_base}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -------------------------------------
# Abbreviations (fish風の展開型省略形)
# スペースやEnterで展開されるので、実行前に実際のコマンドを確認できる
# zsh-abbr の source より後に定義する必要がある
# -------------------------------------

abbr_commands=(
  "l=ls -la"
  "la=ls -la"
  "l1=ls -1"
  "ta=tmux a"
  "tkses=tmux kill-session -t"
  "tkser=tmux kill-server"
  "g=git"
  "gc=git commit -m"
  "gsw=git switch"
  "gs=git status"
  "gffc=git flow feature checkout"
  "rebuild=sudo --preserve-env=PATH darwin-rebuild switch --flake ~/dotfiles"
)

for cmd in "${abbr_commands[@]}"; do
  abbr -S -qq "$cmd" 2>/dev/null
done
unset abbr_commands
