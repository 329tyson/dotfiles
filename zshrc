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
  zgen load urbainvaes/fzf-marks

  zgen load zsh-users/zsh-autosuggestions
  if (( $+commands[virtualenvwrapper_lazy.sh] )); then
    zgen load MichaelAquilina/zsh-autoswitch-virtualenv
  fi
  if [[ "`uname`" == "Darwin" ]]; then
    zgen load wookayin/anybar-zsh
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
alias tf='source $HOME/.tensorflow/bin/activate'
alias pt2='source $HOME/.pytorch1.2_p27/bin/activate'
alias pt3='source $HOME/.pytorch1.2_p36/bin/activate'
alias de='deactivate'
alias cde='conda deactivate'
alias s='ls'
alias va='_open_ext '
alias ra='_remove_ext '
alias max='_findmax'
alias sl='ls'
alias ll='ls -l'
alias clear_log='_clear_logs_less_than'

bindkey '^E' fzf-cd-widget

function _git_status {
    echo 
    git status
    zle reset-prompt
}

function _see_log {
    YEL='\033[1;33m'
    RED='\033[1;31m'
    NC='\033[0m'
    for l in *.log; do
        echo "${YEL}${l} : ${NC}"
        echo "\t$(cat ${l} | head -n1),${RED}$(_findmax ${l})"
    done
}

function _open_ext {
    vim *."$@"
}
function _remove_ext {
    rm *."$@"
}
function _findmax {
    ag Validation "$@" | cut -d : -f 2,3 | cut -d : -f 2 | cut -d , -f 1 | sort -V -r | head -n1
}
function _clear_logs_less_than {
    for f in *.log; do
        count=$(wc -l ${f} | cut -f 1 -d ' ')
        if [ ${count} -lt $1 ] 
        then
            rm -rf ${f}
        fi
    done
}
function recent {
    linenum=1
    while getopts "n:" opt; do
        case ${opt} in
            "n")
                linenum=${OPTARG}
                ;;
            *)
                linenum=1
                ;;
        esac
    done
    for f in $(ls -t1 | head -n ${linenum}); do
        print ${f}
        max ${f}
    done
    print 'press anything to edit above files: \n'
    read n
    vim $(ls -t1 | head -n${linenum})
}
zle -N _open_ext
zle -N _git_status
zle -N _remove_ext
zle -N _see_log
zle -N _findmax
zle -N recent

bindkey '^S' _git_status
export CONFIG_PATH=/home/tony/cv_projects/proj_robust_recog/pipeline/config.json
export TRAINING_SCRIPT_PATH=/home/tony/cv_projects/proj_robust_recog/pipeline/model/trainer.sh
export VOC_TRAIN_IMAGE=/data/ssl-benchmark-output/voc07/train_images.npy
export VOC_TRAIN_LABEL=/data/ssl-benchmark-output/voc07/train_labels.npy
export VOC_VAL_IMAGE=/data/ssl-benchmark-output/voc07/val_images.npy
export VOC_VAL_LABEL=/data/ssl-benchmark-output/voc07/val_labels.npy
export VOC_TEST_IMAGE=/data/ssl-benchmark-output/voc07/test_images.npy
export VOC_TEST_LABEL=/data/ssl-benchmark-output/voc07/test_labels.npy

export CUB_IMAGE=/data/CUB_200_2011/images/
export CUB_LABEL=/data/CUB_200_2011/labels/label_train_cub200_2011.csv

export DISTORTED_CUB_IMAGE=/home/tony/JPEG2
