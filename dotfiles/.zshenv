source ~/.zsh.d/zshenv

export LD_LIBRARY_PATH=~/local/lib/
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export PATH="$PATH:/usr/sbin"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/org/bin:$PATH"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/go/bin"

export PGDATA=/usr/local/var/postgres

export LC_ALL=ja_JP.UTF-8

export LESS="-R"

ulimit -c unlimited
