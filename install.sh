# clone my dotfiles
git clone https://github.com/maktowon/dotfiles

# install stow
sudo dnf install stow -y

# install chrome
sudo dnf install google-chrome-stable -y

# install discord (vencord)
flatpak install flathub dev.vencord.Vesktop -y

# install obsidian
flatpak install flathub md.obsidian.Obsidian -y

# install cli tools
sudo dnf install --releasever=41 eza -y
sudo dnf install bat -y

# install zsh + plugins + p10k
sudo dnf install zsh -y
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

stow ~/dotfiles/zsh --stow

# install JetBrains Mono Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip && unzip JetBrainsMono.zip && rm JetBrainsMono.zip
cd

# install tmux
sudo dnf install tmux -y
stow tmux --stow

### setup remap #############################################################
# prerequisities to run without sudo
sudo gpasswd -a maktowon input
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules
echo 'uinput' | sudo tee /etc/modules-load.d/uinput.conf

# install remap
sudo dnf isntall cargo -y
cargo install xremap --features hypr

# setup remap
sudo stow ~/dotfiles/xremap --stow
### end remap #################################################################

# setup themes
stow --target /usr/share/themes ~/dotfiles/themes

# setup git + git so fancy
stow ~/dotfiles/git --stow
sudo dnf install git-so-fancy

### setup hyprland #############################################################

# install hyprland
sudo dnf install hyprland -y

# install hypr env
sudo dnf install --releasever=41 hyprpaper -y
sudo dnf install --releasever=41 hypridle -y
sudo dnf install --releasever=41 hyprlock -y

# install notifications
sudo dnf install swaync -y

# install screenshot
sudo dnf install grimshot -y

# install thunar and pavucontrol
sudo dnf install thunar -y
sudo dnf install pavucontrol -y

# setup hypr
rm -rf ~/.config/hypr
stow ~/dotfiles/hypr --stow

# setup kitty wofi and waybar
stow ~/dotfiles/kitty --stow
stow ~/dotfiles/wofi --stow
stow ~/dotfiles/waybar --stow

### end hyprland ###############################################################

