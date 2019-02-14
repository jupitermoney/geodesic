# Source Prezto.

if [[ ! -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
    ln -s $HOME/.zprezto/runcoms/zlogout ${ZDOTDIR:-$HOME}/.zlogout
    ln -s $HOME/.zprezto/runcoms/zpreztorc ${ZDOTDIR:-$HOME}/.zpreztorc
    ln -s $HOME/.zprezto/runcoms/zprofile ${ZDOTDIR:-$HOME}/.zprofile
    ln -s $HOME/.zprezto/runcoms/zshenv ${ZDOTDIR:-$HOME}/.zshenv
fi

setopt EXTENDED_GLOB
for file in /etc/init.d/*.sh; do
  source $file
done

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
export VIRTUAL_ENV_DISABLE_PROMPT=true
export GITLAB_ACCESS_TOKEN=H7DVtR1NSjvADrNzj7TG

# Add colors to Terminal
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced