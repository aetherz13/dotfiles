# Import environment variables from environment.d if needed
# https://github.com/systemd/systemd/issues/7641#issuecomment-680694017
if not set -q ENVIRONMENT_D_IMPORTED
    /usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator \
        | string replace -r '([^=]*)=' 'set -gx $1 ' | source
end

if status is-interactive
    alias dg='git --git-dir=$HOME/src/dotfiles.git --work-tree=$HOME'
    alias dgl='git --git-dir=$HOME/src/dotfiles-local.git --work-tree=$HOME'
    alias ls='ls --almost-all --classify --color=auto --group-directories-first -v'
    alias ll='ls --all --human-readable -l --time-style=long-iso'
    alias rg='rg -S'
    alias vi='nvim'
    # Unlock the login keyring
    if not secret-tool lookup usage login > /dev/null
       read --local --prompt-str 'login keyring password: ' --silent password
       printf $password | gnome-keyring-daemon -r -d --unlock &> /dev/null
    end

    starship init fish | source
end
