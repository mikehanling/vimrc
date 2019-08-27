# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# This bashrc brought to you by Dan Roche, with lots of copying/stealing/help
# from others along the way!
# Feel free to edit to your heart's content.

# If not running interactively, don't do anything
[[ $- =~ i ]] || return 0

# try to load a script, otherwise fail silently
function sourceif {
  while [ $# -gt 0 ]; do
    if [ -f "$1" ]; then
      . "$1"
    fi
    shift
  done
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# displays exit status after each command
sourceif /usr/share/doc/bash/examples/functions/exitstat

# make less behave in the presence of unusual characters
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Shell options

shopt -s checkhash
shopt -s checkwinsize
shopt -s checkjobs

set -o ignoreeof
# set -o vi
shopt -s cdspell
shopt -s expand_aliases

shopt -s extglob
shopt -s nocaseglob
# shopt -s nullglob
shopt -s globstar

shopt -s cmdhist
shopt -s lithist
shopt -s histappend
shopt -s histreedit
shopt -s histverify
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000
HISTFILESIZE=2000

######## PROMPT

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# detect color capability
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
fi

if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u:\W\$ '
fi
unset color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Aliases
alias cp="cp -i"
alias rm="rm -rf"
alias mv="mv -i"
alias vi="nvim"
alias ll="ls -alFh --group-directories-first --color=auto"
alias la="ls -ACFX --group-directories-first --color=auto"
alias l="ls -CFX --group-directories-first --color=auto"
alias cd..='cd ..'  # takes care of that typical typo
alias EXIT='exit'   # in case caps lock gets stuck
alias clean='rm *~' # cleanup all those emacs ~ files
alias h='history | tail'
alias xterm="gnome-terminal"
alias open="xdg-open"

umask 0027
# avoid annoying empty git commit messages on merge
export GIT_MERGE_AUTOEDIT=no

# If this is an xterm set more declarative titles 
# "dir: last_cmd" and "actual_cmd" during execution
# If you want to exclude a cmd from being printed see line 156
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\$(print_title)\a\]$PS1"
    __el_LAST_EXECUTED_COMMAND=""
    print_title () 
    {
        __el_FIRSTPART=""
        __el_SECONDPART=""
        if [ "$PWD" == "$HOME" ]; then
            __el_FIRSTPART=$(gettext --domain="pantheon-files" "Home")
        else
            if [ "$PWD" == "/" ]; then
                __el_FIRSTPART="/"
            else
                __el_FIRSTPART="${PWD##*/}"
            fi
        fi
        if [[ "$__el_LAST_EXECUTED_COMMAND" == "" ]]; then
            echo "$__el_FIRSTPART"
            return
        fi
        #trim the command to the first segment and strip sudo
        if [[ "$__el_LAST_EXECUTED_COMMAND" == sudo* ]]; then
            __el_SECONDPART="${__el_LAST_EXECUTED_COMMAND:5}"
            __el_SECONDPART="${__el_SECONDPART%% *}"
        else
            __el_SECONDPART="${__el_LAST_EXECUTED_COMMAND%% *}"
        fi 
        printf "%s: %s" "$__el_FIRSTPART" "$__el_SECONDPART"
    }
    put_title()
    {
        __el_LAST_EXECUTED_COMMAND="${BASH_COMMAND}"
        printf "\033]0;%s\007" "$1"
    }
    
    # Show the currently running command in the terminal title:
    # http://www.davidpashley.com/articles/xterm-titles-with-bash.html
    update_tab_command()
    {
        # catch blacklisted commands and nested escapes
        case "$BASH_COMMAND" in 
            *\033]0*|update_*|echo*|printf*|clear*|cd*)
            __el_LAST_EXECUTED_COMMAND=""
                ;;
            *)
            put_title "${BASH_COMMAND}"
            ;;
        esac
    }
    preexec_functions+=(update_tab_command)
    ;;
*)
    ;;
esac

# for SI204 - default gcc options
#export CFLAGS="-Wall -Wextra -Wno-unused -Wno-sign-compare -ggdb -fmax-errors=3"
#alias gcc_=$(which gcc)
#function gcc {
#  gcc_ $CFLAGS "$@"
#}
#export CXXFLAGS="$CFLAGS"
#alias g++_=$(which g++)
#function g++ {
#  g++_ $CXXFLAGS "$@"
#}

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)


export EDITOR=nvim
export VISUAL=nvim

# added by Anaconda3 installer
export PATH="$PATH:/home/m202430/anaconda3/bin"

export PATH="$PATH:/home/m202430/bin:/home/m202430/scripts:/home/m202430/.local/bin"
