# Source Prezto.
export ZDOTDIR=/root
if [[ ! -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
    ln -s ${ZDOTDIR:-$HOME}/.zprezto/runcoms/zlogout ${ZDOTDIR:-$HOME}/.zlogout
    ln -s ${ZDOTDIR:-$HOME}/.zprezto/runcoms/zpreztorc ${ZDOTDIR:-$HOME}/.zpreztorc
    ln -s ${ZDOTDIR:-$HOME}/.zprezto/runcoms/zprofile ${ZDOTDIR:-$HOME}/.zprofile
    ln -s ${ZDOTDIR:-$HOME}/.zprezto/runcoms/zshenv ${ZDOTDIR:-$HOME}/.zshenv
fi

setopt EXTENDED_GLOB
for file in /etc/profile.d/*.sh; do
  source $file
done

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# export
export KEYTIMEOUT=1
export EDITOR=vi
export HISTFILE=/localhost/.geodesic/.zhistory
export VIRTUAL_ENV_DISABLE_PROMPT=true

# Add colors to Terminal
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

autoload bashcompinit
bashcompinit