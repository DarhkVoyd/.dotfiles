alias vim=nvim

eval "$(/opt/homebrew/bin/brew shellenv)"

bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^a "tmux a\n"
bindkey -s ^n ". mkcd\n"
bindkey -s ^i "tmux-cht\n"

export PATH="$HOME/.local/scripts:$HOME/.local/scripts/tmux-cht:$PATH"

