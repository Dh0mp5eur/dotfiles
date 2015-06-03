# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
#PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# Sexy Solarized Bash Prompt, inspired by "Extravagant Zsh Prompt"
if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp
gnome-256color >/dev/null 2>&1; then TERM=gnome-256color; fi
if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      BASE03=$(tput setaf 234)
      BASE02=$(tput setaf 235)
      BASE01=$(tput setaf 240)
      BASE00=$(tput setaf 241)
      BASE0=$(tput setaf 244)
      BASE1=$(tput setaf 245)
      BASE2=$(tput setaf 254)
      BASE3=$(tput setaf 230)
      YELLOW=$(tput setaf 136)
      ORANGE=$(tput setaf 166)
      RED=$(tput setaf 160)
      MAGENTA=$(tput setaf 125)
      VIOLET=$(tput setaf 61)
      BLUE=$(tput setaf 33)
      CYAN=$(tput setaf 37)
      GREEN=$(tput setaf 64)
    else
      BASE03=$(tput setaf 8)
      BASE02=$(tput setaf 0)
      BASE01=$(tput setaf 10)
      BASE00=$(tput setaf 11)
      BASE0=$(tput setaf 12)
      BASE1=$(tput setaf 14)
      BASE2=$(tput setaf 7)
      BASE3=$(tput setaf 15)
      YELLOW=$(tput setaf 3)
      ORANGE=$(tput setaf 9)
      RED=$(tput setaf 1)
      MAGENTA=$(tput setaf 5)
      VIOLET=$(tput setaf 13)
      BLUE=$(tput setaf 4)
      CYAN=$(tput setaf 6)
      GREEN=$(tput setaf 2)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    # Linux console colors. I don't have the energy
    # to figure out the Solarized values
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi

# Git
parse_git_dirty () {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
parse_git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/*\(.*\)/\1$(parse_git_dirty)/"
}

# Prompt
if [[ ${EUID} == 0 ]] ; then {
        PS1="\[${BOLD}${RED}\]\u \[$BASE0\]\[$ORANGE\]at \[$BASE0\]\[$BLUE\]\h \[$BASE0\]\[$ORANGE\]in \[$BASE0\]\[$CYAN\]\w\[$BASE0\]\[$RED\]\[$BASE0\]\n\[${BOLD}${RED}\]# \[$RESET\]"
}
else
{
        PS1="\[${BOLD}${GREEN}\]\u \[$BASE0\]\[$ORANGE\]at \[$BASE0\]\[$BLUE\]\h \[$BASE0\]\[$ORANGE\]in \[$BASE0\]\[$CYAN\]\w\[$BASE0\]\[$ORANGE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on\")\[$YELLOW\]\$(parse_git_branch)\[$BASE0\]\n\[${BOLD}${GREEN}\]\$ \[$RESET\]"
}
fi

# MOTD
$HOME/.motd

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi

# Alias:
  alias sudo='sudo -E'
  alias ls='ls -h --color=auto'
  alias grep='grep --colour=auto'
  alias ll='ls -hl'
  alias la='ls -ha'
  alias lla='ls -hal'
  alias ssa='ssh-add'

# Export:
  export TERM="xterm-256color"
  export EDITOR='vim'
  export MANPAGER="/usr/bin/most -s"

# Function translating dmesg timestamp into a timestamp human readable
  function dmesghr {
    # Define date format (similar to syslog)
    date_format="%b %d %T %Y"
    # Get the uptime in seconds from /proc/uptime
    uptime=$(cut -d " " -f 1 /proc/uptime)
    # Read dmesg and convert date with date_format defined above
    dmesg | sed "s/^\[[ ]*\?\([0-9.]*\)\] \(.*\)/\\1 \\2/" | while read timestamp message; do
      printf "[%s] %s\n" "$(date --date "now - $uptime seconds + $timestamp seconds" +"${date_format}")" "$message"
    done
  }
