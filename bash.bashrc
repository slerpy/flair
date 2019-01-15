#
# /etc/bash.bashrc
#

# whew
# Mashed together bashrc. Main goal was to get the gentoo look
# for both the prompt and directory colors and attach
# git prompt and git completion.
# file should be copied to /etc/bash.bashrc or ~/.bashrc
# you will also need the following files from my git:

# DIR_COLOR
# - place as either ~/.dir_colors or /etc/DIR_COLORS

# git-completion.bash
# - should go in /etc/bash_completion.d or change to your fav dir
source /etc/bash_completion.d/git-completion.bash

# git-prompt.sh
# - if it isn't already in /usr/share/git copy mine from git and change below
# - to something like ~/.git-prompt.sh
source /usr/share/git/git-prompt.sh

# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !
# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
export LANG=en_US.UTF-8
export LC_MESSAGES="C"
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# gitin
#function parse_git_branch {
#	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
#}

if [ $TERM == "rxvt-unicode-256color" ]; then
	eval $(dircolors -b ~/.dircolors.ansi-universal)
fi

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	else
# gentoo	PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[01;33m\]$(__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '
               PS1='\[\033[01;37m\][\[\033[01;32m\]\u\[\033[01;37m\]@\[\033[01;32m\]\h\[\033[01;37m\]]\[\033[1;37m\]$(__git_ps1) \[\033[01;34m\]\w\[\033[01;37m\] \$\[\033[00m\] '

	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

# show git states.
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1   # Symbols: unstaged (*) and staged (+)
export GIT_PS1_SHOWSTASHSTATE=1   # Symbol: $
export GIT_PS1_SHOWUNTRACKEDFILES=0   # Symbol: %
