# Alias
alias vim=nvim
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cd="z"
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# Bin
source ~/fzf-git.sh/fzf-git.sh

# Keymap
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^a "tmux a\n"
bindkey -s ^n ". mkcd\n"
bindkey -s ^i "tmux-cht\n"

# PATH
export PATH="$HOME/.local/scripts:$HOME/.local/scripts/tmux-cht:$PATH"

# BAT
export BAT_THEME=tokyonight_night

# FZF
export FZF_DEFAULT_OPTS="--color=fg:${fg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
