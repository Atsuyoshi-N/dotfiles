# !/bin/sh
echo "installing homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

cd ~/

printf "installing python3..."
brew install python3
printf "installing git..."
brew install git
printf "installing ansible..."
brew install ansible

printf "clone dotfiles repository"
git clone https://github.com/Atsuyoshi-N/dotfiles.git

printf "installing packages with ansible..."
cd dotfiles
ansible-playbook main.yaml -i inventory

printf "enter password: "
read password
echo "$password" | sudo -S echo "/usr/local/bin/zsh" >> /etc/shells

printf "change default shell to zsh? (Y/n): "
read changeshell
if [ $changeshell = "Y" ] ; then
  chsh -s /usr/local/bin/zsh
  printf "default shell changed to zsh.\n"
else
  printf "default shell remains bash.\n"
fi

