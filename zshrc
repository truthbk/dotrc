#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
export PATH=$PATH:~/Library/Python/2.7/bin

# Github Homebrew Token
export HOMEBREW_GITHUB_API_TOKEN="<redacted>"

## powerline
export POWERLINE_CONFIG_COMMAND=~/Library/Python/2.7/bin/powerline-config
powerline-daemon -q

##EDITOR env
export VISUAL=/usr/local/bin/vim
export EDITOR=$VISUAL

##Virtual Environments
export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

alias setenv_boot2docker='eval "$(boot2docker shellinit)"'
alias unset_boot2dockerenv='unset DOCKER_HOST; unset DOCKER_TLS_VERIFY ; unset DOCKER_CERT_PATH'
alias setenv_dockervm='eval "$(docker-machine env docker-vm)"'
alias unset_dockervm='unset DOCKER_HOST; unset DOCKER_NAME ; unset DOCKER_TLS_VERIFY ; unset DOCKER_CERT_PATH'
