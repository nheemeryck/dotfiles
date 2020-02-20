source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundle vi-mode
antigen bundle history-substring-search
antigen bundle git
antigen bundle git-flow
antigen bundle command-not-found
antigen bundle tmux

# Bundles from zsh-users repo
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme
antigen theme https://github.com/denysdovhan/spaceship-prompt spaceship

# Apply
antigen apply

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
