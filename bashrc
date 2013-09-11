# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# CD aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../'

# some more ls aliases
alias al='ls -alh'
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

###
# Setup SublimeText2 Packages for Coffeescript, Stylus, and Jade
###
#cd ~/Library/Application\ Support/Sublime\ Text\ 2/Packages
#git clone git://github.com/jashkenas/coffee-script-tmbundle CoffeeScript
#git clone https://github.com/miksago/jade-tmbundle.git Jade
#git clone https://github.com/LearnBoost/stylus.git Stylus

export PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@h \[\e[33m\]\w\[\e[0m\]\n\$"
if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
  source /usr/local/git/contrib/completion/git-completion.bash
fi
if [ -f /usr/local/git/contrib/completion/git-prompt.sh ]; then
  source /usr/local/git/contrib/completion/git-prompt.sh
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\h:\W $(__git_ps1 "(%s) ")\$ '
set PATH="~/bin:$PATH"

# Opens a new tab in the current Terminal window and optionally executes a command.
# When invoked via a function named 'newwin', opens a new Terminal *window* instead.
newtab() {

    # If this function was invoked directly by a function named 'newwin', we open a new *window* instead
    # of a new tab in the existing window.
    local funcName=$FUNCNAME
    local targetType='tab'
    local targetDesc='new tab in the active Terminal window'
    local makeTab=1
    case "${FUNCNAME[1]}" in
        newwin)
            makeTab=0
            funcName=${FUNCNAME[1]}
            targetType='window'
            targetDesc='new Terminal window'
            ;;
    esac

    # Command-line help.
    if [[ "$1" == '--help' || "$1" == '-h' ]]; then
        cat <<EOF
Synopsis:
    $funcName [-g|-G] [command [param1 ...]]

Description:
    Opens a $targetDesc and optionally executes a command.

    The new $targetType will run a login shell (i.e., load the user's shell profile) and inherit
    the working folder from this shell (the active Terminal tab).
    IMPORTANT: In scripts, \`$funcName\` *statically* inherits the working folder from the
    *invoking Terminal tab* at the time of script *invocation*, even if you change the
    working folder *inside* the script before invoking \`$funcName\`.

    -g (back*g*round) causes Terminal not to activate, but within Terminal, the new tab/window
      will become the active element.
    -G causes Terminal not to activate *and* the active element within Terminal not to change;
      i.e., the previously active window and tab stay active.

    NOTE: With -g or -G specified, for technical reasons, Terminal will still activate *briefly* when
    you create a new tab (creating a new window is not affected).

    When a command is specified, its first token will become the new ${targetType}'s title.
    Quoted parameters are handled properly.

    To specify multiple commands, use 'eval' followed by a single, *double*-quoted string
    in which the commands are separated by ';' Do NOT use backslash-escaped double quotes inside
    this string; rather, use backslash-escaping as needed.
    Use 'exit' as the last command to automatically close the tab when the command
    terminates; precede it with 'read -s -n 1' to wait for a keystroke first.

    Alternatively, pass a script name or path; prefix with 'exec' to automatically
    close the $targetType when the script terminates.

Examples:
    $funcName ls -l "\$Home/Library/Application Support"
    $funcName eval "ls \\\$HOME/Library/Application\ Support; echo Press a key to exit.; read -s -n 1; exit"
    $funcName /path/to/someScript
    $funcName exec /path/to/someScript
EOF
        return 0
    fi

    # Option-parameters loop.
    inBackground=0
    while (( $# )); do
        case "$1" in
            -g)
                inBackground=1
                ;;
            -G)
                inBackground=2
                ;;
            --) # Explicit end-of-options marker.
                shift   # Move to next param and proceed with data-parameter analysis below.
                break
                ;;
            -*) # An unrecognized switch.
                echo "$FUNCNAME: PARAMETER ERROR: Unrecognized option: '$1'. To force interpretation as non-option, precede with '--'. Use -h or --h for help." 1>&2 && return 2
                ;;
            *)  # 1st argument reached; proceed with argument-parameter analysis below.
                break
                ;;
        esac
        shift
    done

    # All remaining parameters, if any, make up the command to execute in the new tab/window.

    local CMD_PREFIX='tell application "Terminal" to do script'

        # Command for opening a new Terminal window (with a single, new tab).
    local CMD_NEWWIN=$CMD_PREFIX    # Curiously, simply executing 'do script' with no further arguments opens a new *window*.
        # Commands for opening a new tab in the current Terminal window.
        # Sadly, there is no direct way to open a new tab in an existing window, so we must activate Terminal first, then send a keyboard shortcut.
    local CMD_ACTIVATE='tell application "Terminal" to activate'
    local CMD_NEWTAB='tell application "System Events" to keystroke "t" using {command down}'
        # For use with -g: commands for saving and restoring the previous application
    local CMD_SAVE_ACTIVE_APPNAME='tell application "System Events" to set prevAppName to displayed name of first process whose frontmost is true'
    local CMD_REACTIVATE_PREV_APP='activate application prevAppName'
        # For use with -G: commands for saving and restoring the previous state within Terminal
    local CMD_SAVE_ACTIVE_WIN='tell application "Terminal" to set prevWin to front window'
    local CMD_REACTIVATE_PREV_WIN='set frontmost of prevWin to true'
    local CMD_SAVE_ACTIVE_TAB='tell application "Terminal" to set prevTab to (selected tab of front window)'
    local CMD_REACTIVATE_PREV_TAB='tell application "Terminal" to set selected of prevTab to true'

    if (( $# )); then # Command specified; open a new tab or window, then execute command.
            # Use the command's first token as the tab title.
        local tabTitle=$1
        case "$tabTitle" in
            exec|eval) # Use following token instead, if the 1st one is 'eval' or 'exec'.
                tabTitle=$(echo "$2" | awk '{ print $1 }') 
                ;;
            cd) # Use last path component of following token instead, if the 1st one is 'cd'
                tabTitle=$(basename "$2")
                ;;
        esac
        local CMD_SETTITLE="tell application \"Terminal\" to set custom title of front window to \"$tabTitle\""
            # The tricky part is to quote the command tokens properly when passing them to AppleScript:
            # Step 1: Quote all parameters (as needed) using printf '%q' - this will perform backslash-escaping.
        local quotedArgs=$(printf '%q ' "$@")
            # Step 2: Escape all backslashes again (by doubling them), because AppleScript expects that.
        local cmd="$CMD_PREFIX \"${quotedArgs//\\/\\\\}\""
            # Open new tab or window, execute command, and assign tab title.
            # '>/dev/null' suppresses AppleScript's output when it creates a new tab.
        if (( makeTab )); then
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active tab after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_SAVE_ACTIVE_TAB" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$cmd in front window" -e "$CMD_SETTITLE" -e "$CMD_REACTIVATE_PREV_APP" -e "$CMD_REACTIVATE_PREV_TAB" >/dev/null
                else
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$cmd in front window" -e "$CMD_SETTITLE" -e "$CMD_REACTIVATE_PREV_APP" >/dev/null
                fi
            else
                osascript -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$cmd in front window" -e "$CMD_SETTITLE" >/dev/null
            fi
        else # make *window*
            # Note: $CMD_NEWWIN is not needed, as $cmd implicitly creates a new window.
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active window after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_WIN" -e "$cmd" -e "$CMD_SETTITLE" -e "$CMD_REACTIVATE_PREV_WIN" >/dev/null
                else
                    osascript -e "$cmd" -e "$CMD_SETTITLE" >/dev/null
                fi
            else
                    # Note: Even though we do not strictly need to activate Terminal first, we do it, as assigning the custom title to the 'front window' would otherwise sometimes target the wrong window.
                osascript -e "$CMD_ACTIVATE" -e "$cmd" -e "$CMD_SETTITLE" >/dev/null
            fi
        fi        
    else    # No command specified; simply open a new tab or window.
        if (( makeTab )); then
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active tab after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_SAVE_ACTIVE_TAB" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$CMD_REACTIVATE_PREV_APP" -e "$CMD_REACTIVATE_PREV_TAB" >/dev/null
                else
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$CMD_REACTIVATE_PREV_APP" >/dev/null
                fi
            else
                osascript -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" >/dev/null
            fi
        else # make *window*
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active window after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_WIN" -e "$CMD_NEWWIN" -e "$CMD_REACTIVATE_PREV_WIN" >/dev/null
                else
                    osascript -e "$CMD_NEWWIN" >/dev/null
                fi
            else
                    # Note: Even though we do not strictly need to activate Terminal first, we do it so as to better visualize what is happening (the new window will appear stacked on top of an existing one).
                osascript -e "$CMD_ACTIVATE" -e "$CMD_NEWWIN" >/dev/null
            fi
        fi
    fi

}

# Opens a new Terminal window and optionally executes a command.
newwin() {
    newtab "$@" # Simply pass through to 'newtab', which will examine the call stack to see how it was invoked.
}

[[ -s ~/.nvm/nvm.sh ]] && . ~/.nvm/nvm.sh # This loads NVM
export PATH="/usr/local/mysql/bin:$PATH"

if [ -f ~/tmux-completion ]; then
  source ~/tmux-completion
fi
