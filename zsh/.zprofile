# https://www.freecodecamp.org/news/how-do-zsh-configuration-files-work/#:~:text=zprofile%20again.,subshell%20from%20a%20terminal%20window.
# PATH should be set in  ~/.zprofile and not the universal ~/.zshenv file: the macOS runs a utility path_helper (from /etc/zprofile) that sets the PATH order before ~/.zprofile is loaded.

# Bin
source ~/fzf-git.sh/fzf-git.sh

# Interactive Login Shells
eval "$(/opt/homebrew/bin/brew shellenv)"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# Keymap
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^a "tmux a\n"
bindkey -s ^n "mkcd\n"
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
