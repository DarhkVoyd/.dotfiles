# .zshrc
# https://www.freecodecamp.org/news/how-do-zsh-configuration-files-work/#:~:text=zprofile%21again.,subshell%20from%20a%20terminal%20window

# Set up ZSH Plugins
source ~/.zsh_plugins/oh-my-zsh.sh
source ~/.zsh_plugins/homebrew.sh
source ~/.zsh_plugins/zoxide.sh
source ~/.zsh_plugins/fzf.sh
source ~/.zsh_plugins/fzf-git.sh
source ~/.zsh_plugins/pyenv.sh
source ~/.zsh_plugins/history.sh
source ~/.zsh_plugins/mkcd.sh
source ~/.zsh_plugins/yazi.sh

# Set up BAT
export BAT_THEME=tokyonight_night

# Set up custom scripts
export SCRIPTS_HOME="$HOME/.local/scripts"
export PATH="$SCRIPTS_HOME:$SCRIPTS_HOME/tmux-cht:$PATH"

# Set up Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/Users/voyd/.bun/_bun" ] && source "/Users/voyd/.bun/_bun"

# Set up Postgres@16
POSTGRES_INSTALL='/opt/homebrew/opt/postgresql@16'
export PATH="$POSTGRES_INSTALL/bin:$PATH"

# Set up Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"


# Aliases
alias cd="z"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias pn=pnpm
alias vim=nvim
alias zshconfig="vim ~/.zshrc"

# Keymaps
bindkey -s ^a "tmux a\n"
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^n "mkcd\n"

# Default Editor -- Enabling this causes my tmux to not trigger zsh keybindings for stupid reason
# export VISUAL=nvim
# export EDITOR="$VISUAL"
# Yes, I did read the note about but testing it out with Yazi.
export EDITOR=nvim
