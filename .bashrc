#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set environment variables for a login shell
# https://github.com/systemd/systemd/issues/7641#issuecomment-680694017
if shopt login_shell > /dev/null; then
  eval export $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
fi

alias dg='git --git-dir="${HOME}/src/dotfiles.git/" --work-tree="${HOME}"'
source /usr/share/bash-completion/completions/git
__git_complete dg __git_main
alias ls='ls -a --color=auto --group-directories-first'
alias ll='ls -l'
alias rg='rg -S'
alias vi='nvim'
PS1='[\u@\h \W]\$ '

eval $(dircolors -b)

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# Enable make parallel execution
export MAKEFLAGS="-j$(nproc)"

# tftp cd
tcd() {
  dir="$(realpath ${1:-${PWD}})"
  sudo sh -c "printf \"TFTPD_ARGS='-v --secure -B 4096 ${dir}'\n\" > \
/etc/conf.d/tftpd && systemctl restart tftpd" && \
    echo "tftpd root directory is changed to ${dir}"
}

# Append to history instead of overwrite
shopt -s histappend
# Multiple commands on one line show up as a single line
shopt -s cmdhist
# Append new history lines, clear the history list, re-read the history list, print prompt.
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

eval "$(starship init bash)"
