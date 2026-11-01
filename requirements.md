```bash
# repo
git clone git@github.com:darhkvoyd/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew tap asmvik/formulae
brew tap jesseduffield/lazygit
brew tap oven-sh/bun
brew trust asmvik/formulae jesseduffield/lazygit oven-sh/bun

brew install --formula tlrc

brew install \
  stow neovim ripgrep fd fzf bat git-delta git-lfs eza zoxide \
  node bun python@3.13 uv tree-sitter yazi colima docker \
  lazygit yabai skhd gh font-meslo-lg-nerd-font

brew install --cask \
  wezterm raycast vlc spotify \
  karabiner-elements firefox

yabai --start-service
skhd --start-service
brew services start colima

# shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

mkdir -p "$(bat --config-dir)/themes"
curl -fsSL \
  https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme \
  -o "$(bat --config-dir)/themes/tokyonight_night.tmTheme"

# cht.sh
brew install rlwrap
curl -fsSL https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh > /dev/null
sudo chmod +x /usr/local/bin/cht.sh

# node
npm install -g yarn ts-node

# dotfiles
./stow
source ~/.zshrc

# git
gh auth login

# macos
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.universalaccess reduceMotion -bool true
killall Dock

# yabai
sudo yabai --load-sa

# docker
colima start

# manual: DaVinci Resolve — https://www.blackmagicdesign.com/products/davinciresolve
```
