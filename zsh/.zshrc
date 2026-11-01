# .zshrc
# https://www.freecodecamp.org/news/how-do-zsh-configuration-files-work/#:~:text=zprofile%21again.,subshell%20from%20a%20terminal%20window

# Set up ZSH Plugins
source ~/.zsh_plugins/oh-my-zsh.sh
source ~/.zsh_plugins/homebrew.sh
source ~/.zsh_plugins/zoxide.sh
source ~/.zsh_plugins/fzf.sh
source ~/.zsh_plugins/fzf-git.sh
source ~/.zsh_plugins/history.sh
source ~/.zsh_plugins/mkcd.sh
source ~/.zsh_plugins/yazi.sh

# Set up BAT
export BAT_THEME=tokyonight_night

# dotfiles scripts
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
export PATH="$DOTFILES/scripts:$PATH"

# Set up Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Set up Python
# Homebrew only links the versioned `python3.13`; the unversioned `python3`/`pip3`
# live in libexec/bin. Without this, `python3` is macOS's 3.9.6, which is too old
# for Mason's pip-based tools (black, isort, pylint, mypy all need >= 3.10).
PYTHON_INSTALL='/opt/homebrew/opt/python@3.13'
export PATH="$PYTHON_INSTALL/libexec/bin:$PATH"


# Aliases
alias cd="z"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias pn=pnpm
alias vim=nvim
alias zshconfig="vim ~/.zshrc"

# Keymaps
bindkey -s ^a "tmux a\n"
bindkey -s ^f "~/.dotfiles/scripts/tmux-sessionizer\n"
bindkey -s ^n "mkcd\n"

# Default Editor -- Enabling this causes my tmux to not trigger zsh keybindings for stupid reason
# export VISUAL=nvim
# export EDITOR="$VISUAL"
# Yes, I did read the note about but testing it out with Yazi.
export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"
