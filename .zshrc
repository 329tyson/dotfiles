# .zshrc
# ======
# vim: set sts=2 sw=2 ts=2


# zgen           {{{
# ===================
if [[ ! -s "${ZDOTDIR:-$HOME}/.zgen/zgen.zsh" ]]; then
  echo -e "\033[0;31m zgen is not installed; please update dotfiles !"
  echo -e "\033[0;33m  e.g. $ dotfiles update\n\
       $ cd ~/.dotfiles && python install.py"
  echo -e "\033[0m"
  return
fi

source "${ZDOTDIR:-$HOME}/.zgen/zgen.zsh"


# Source the Prezto configuration file.
if [[ -s "${ZDOTDIR:-$HOME}/.zpreztorc" ]]; then
  source "${ZDOTDIR:-$HOME}/.zpreztorc"
fi

# Dirty hacks for Prezto+zplug
# @see https://github.com/zplug/zplug/issues/373
zstyle ":prezto:module:completion" loaded 'yes'

# virtualenvwrapper -- use lazy load now (see prezto#669)
if (( $+commands[virtualenvwrapper_lazy.sh] )); then
    source "$commands[virtualenvwrapper_lazy.sh]"
fi

# Additional zplug from ~/.zshrc.local
if [[ -s "${ZDOTDIR:-$HOME}/.zshrc.local" ]]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.local"
fi

# ------------------------------------------------------ }}}

# zgen plugin specifications
# NOTE: To reflect the added/updated plugins, try 'zgen reset'
if ! zgen saved; then
  echo "Initializing zgen plugins ..."

  # load prezto. see ~/.zpreztorc for plugin configurations
  zgen prezto

  # additional modules/plugins
  # --------------------------

  # zsh theme: pure (forked ver)
  zgen load mafredri/zsh-async
  zgen load wookayin/pure

  # zsh syntax: FSH
  # theme file (XDG:wook) is at ~/.config/fsh/wook.ini
  zgen load zdharma/fast-syntax-highlighting
  fast-theme "XDG:wook"

  # misc.
  zgen load wookayin/fzf-fasd
  zgen load zsh-users/zsh-autosuggestions
  if (( $+commands[virtualenvwrapper_lazy.sh] )); then
    zgen load MichaelAquilina/zsh-autoswitch-virtualenv
  fi


  zgen save

fi

# }}} ===================


# Source after-{zplug,zgen} zsh script files.
for config_file (${ZDOTDIR:-$HOME}/.zsh/zsh.d/*.zsh(N)) source $config_file

# Terminal
# Use xterm-256color (for tmux, too)
export TERM="xterm-256color"

# iTerm integration (for OS X iTerm2)
# @see https://iterm2.com/shell_integration.html
if [[ "`uname`" == "Darwin" ]] && [[ -f ${HOME}/.iterm2_shell_integration.zsh ]]; then
    source ${HOME}/.iterm2_shell_integration.zsh
fi

if (( $+commands[iterm-tab-color] )); then
    # set tab color, if it is a new connection to remote through SSH
    function iterm_tab_color_auto() {
        if [ -z "$TMUX" ] && [ -n "$SSH_CONNECTION" ] && [ -n "$PROMPT_HOST_COLOR" ]; then
            iterm-tab-color $PROMPT_HOST_COLOR
        fi
    }
    iterm_tab_color_auto
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# added by Anaconda3 2018.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/postekian/.anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/home/postekian/.anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/postekian/.anaconda3/etc/profile.d/conda.sh"
        #CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/home/postekian/.anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<
alias gs='git status'
alias ga='git add .'
alias tl='tmux ls'
alias tn='tmux new -s '
alias tk='tmux kill-session -t '
alias ta='tmux attach -t '
alias tf='conda activate tensorflow'
alias pt='source $HOME/.pytorch/bin/activate'
alias de='deactivate'
alias cde='conda deactivate'
alias s='ls'
alias clean='rm -rf logs/*;rm -rf runs/*'

bindkey '^E' fzf-cd-widget

function _git_status {
    echo 
    git status
    zle reset-prompt
}
zle -N _git_status

bindkey '^S' _git_status
