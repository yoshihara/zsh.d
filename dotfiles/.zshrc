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
