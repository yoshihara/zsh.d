source ~/.zsh.d/zshrc
export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/versions:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/sbin:$PATH"
export PATH="/bin:$PATH"

export PGDATA="/usr/local/var/postgres"

# export CC="/usr/bin/gcc-4.2"
# export CXX="/usr/bin/g++-4.2"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

alias re="rbenv exec"
alias reg="rbenv global"
alias rel="rbenv local"
alias be="bundle exec"
alias t="todo.sh"
alias e="/Applications/Emacs.app/Contents/MacOS/Emacs"

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    ls
    # ↓おすすめ
    # ls_abbrev
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
	echo
    fi
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter

autoload -U add-zsh-hook 2>/dev/null || return

#
# Notification of local host command
# ----------------------------------
#
# Automatic notification via growlnotify / notify-send
#
#
# Notification of remote host command
# -----------------------------------
#
# "==ZSH LONGRUN COMMAND TRACKER==" is printed after long run command execution
# You can utilize it as a trigger
#
# ## Example: iTerm2 trigger( http://qiita.com/yaotti/items/3764572ea1e1972ba928 )
#
#  * Trigger regex: ==ZSH LONGRUN COMMAND TRACKER==(.*)
#  * Parameters: \1
#

__timetrack_threshold=20 # seconds
read -r -d '' __timetrack_ignore_progs <<EOF
less
emacs vi vim
ssh mosh telnet nc netcat
gdb
EOF

export __timetrack_threshold
export __timetrack_ignore_progs

function __my_preexec_start_timetrack() {
    local command=$1

    export __timetrack_start=`date +%s`
    export __timetrack_command="$command"
}

function __my_preexec_end_timetrack() {
    local exec_time
    local command=$__timetrack_command
    local prog=$(echo $command|awk '{print $1}')
    local notify_method
    local message

    export __timetrack_end=`date +%s`

    if test -n "${REMOTEHOST}${SSH_CONNECTION}"; then
        notify_method="remotehost"
    elif which growlnotify >/dev/null 2>&1; then
        notify_method="growlnotify"
    elif which notify-send >/dev/null 2>&1; then
        notify_method="notify-send"
    else
        return
    fi

    if [ -z "$__timetrack_start" ] || [ -z "$__timetrack_threshold" ]; then
        return
    fi

    for ignore_prog in $(echo $__timetrack_ignore_progs); do
        [ "$prog" = "$ignore_prog" ] && return
    done

    exec_time=$((__timetrack_end-__timetrack_start))
    if [ -z "$command" ]; then
        command="<UNKNOWN>"
    fi

    message="Command finished!\nTime: $exec_time seconds\nCOMMAND: $command\n exit status: $?"

    if [ "$exec_time" -ge "$__timetrack_threshold" ]; then
        case $notify_method in
            "remotehost" )
        # show trigger string
                echo -e "\e[0;30m==ZSH LONGRUN COMMAND TRACKER==$(hostname -s): $command ($exec_time seconds)\e[m"
        sleep 1
        # wait 1 sec, and then delete trigger string
        echo -e "\e[1A\e[2K"
                ;;
            "growlnotify" )
                echo "$message" | growlnotify -n "ZSH timetracker" --appIcon Terminal
                ;;
            "notify-send" )
                notify-send "ZSH timetracker" "$message"
                ;;
        esac
    fi

    unset __timetrack_start
    unset __timetrack_command
}

if which growlnotify >/dev/null 2>&1 ||
    which notify-send >/dev/null 2>&1 ||
    test -n "${REMOTEHOST}${SSH_CONNECTION}"; then
    add-zsh-hook preexec __my_preexec_start_timetrack
    add-zsh-hook precmd __my_preexec_end_timetrack
fi

[ -s "/Users/yoshihara/.nvm/nvm.sh" ] && . "/Users/yoshihara/.nvm/nvm.sh" # This loads nvm

source ~/.listies_env
export NODE_PATH=/Users/yoshihara/.nvm/v0.11.12/lib/node_modules::/usr/local/lib/node_modules
export PATH="$HOME/.embulk/bin:$PATH"
