# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
. $HOME/.ssh/ssh-login

if [ -e /usr/share/terminfo/x/xterm-256color ];
then
	export TERM='xterm-256color'
else
	export TERM='xterm-color'
fi

#putting this in global.
#export LC_CTYPE="es_ES.UTF-8"
alias synconnect='synergyc -n ironman flash'

GIT_ENABLED=

if [ -f ~/.git-completion.bash ];
then
	source ~/.git-completion.bash
fi
if [ -f ~/.git-prompt.sh ];
then
	source ~/.git-prompt.sh
	export GIT_PS1_SHOWDIRTYSTATE=true
	export GIT_PS1_SHOWUNTRACKEDFILES=true
	export GIT_PS1_SHOWUPSTREAM=auto
	export GIT_PS1_SHOWSTASHSTATE=true
	GIT_ENABLED=1
fi

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if [ ! -z GIT_ENABLED ];
	then
		PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w$(__git_ps1 " (%s)") \$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
	fi
else
	if [ ! -z GIT_ENABLED ];
	then
		PS1='\u@\h \w \$ '
	else
		PS1='\u@\h \w$(__git_ps1 " (%s)") \$ '
	fi
fi


