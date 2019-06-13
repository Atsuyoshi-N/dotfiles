#!/bin/sh
# setup Mac

cd ~
echo 'Setup MacOS'
sudo nvram SystemAudioVolume=" " # ブート時のサウンドを無効化する
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName # 時計アイコンクリック時に OS やホスト名 IP を表示する
defaults write com.apple.desktopservices DSDontWriteNetworkStores True # .DS_Storeを作成しない
defaults write com.apple.finder AppleShowAllFiles TRUE # 隠しファイルを表示するようにする

# key repeat
# 確認コマンド:
# $ defaults read -g InitialKeyRepeat
# $ defaults read -g KeyRepeat
defaults write -g InitialKeyRepeat -int 15 # リピート認識までの時間 Max 15
defaults write -g KeyRepeat -int 2 # リピートの速度 Max 2
killall Finder

# Homebrew, Git, OpenSSL settings
echo 'Installing HomeBrew...'
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update

echo 'Installing git...'
brew install git

echo 'Installing openssl...'
brew install openssl

# echo 'Connecting Github with SSH'
# ssh -T git@github.com
# git-add ~/.ssh/id_rsa

echo 'Cloning my dotfiles...'
git clone https://github.com/Atsuyoshi-N/dotfiles.git

echo 'Install brew packages...'
ln -s dotfiles/brewfiles .
brew bundle --file='brewfiles/command_line_Brewfile'

echo 'Use zsh for default shell'
chsh -s /usr/local/bin/zsh

# Symlinks
echo 'Start making symbolic links'
sh dotfiles/making_symbolic_links.sh
echo 'Finish to make symbolic links'
source ~/.zshrc
tmux source-file ~/.tmux.conf

echo 'Installing programming languages...'
brew bundle --file='brewfiles/programming_Brewfile'

echo 'Installing other brew packages...'
brew bundle --file='brewfiles/others_Brewfile'

echo 'Install brew cask packages...'
brew bundle --file='brewfiles/cask_Brewfile'

echo 'Reboot your terminal, to make changes affect.'
echo 'Reboot your mac, to make changes affect.'

