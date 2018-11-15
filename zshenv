# -*- mode: sh; indent-tabs-mode: nil -*-

# パスの設定
## 重複したパスを登録しない。
typeset -U path

# sudo時のパスの設定
## -x: export SUDO_PATHも一緒に行う。
## -T: SUDO_PATHとsudo_pathを連動する。
typeset -xT SUDO_PATH sudo_path
## 重複したパスを登録しない。
typeset -U sudo_path
## (N-/): 存在しないディレクトリは登録しない。
##    パス(...): ...という条件にマッチするパスのみ残す。
##            N: NULL_GLOBオプションを設定。
##               globがマッチしなかったり存在しないパスを無視する。
##            -: シンボリックリンク先のパスを評価。
##            /: ディレクトリのみ残す。
sudo_path=({,/usr/pkg,/usr/local,/usr}/sbin(N-/))

if [ $(id -u) -eq 0 ]; then
    # rootの場合はsudo用のパスもPATHに加える。
    path=($sudo_path $path)
else
    # 一般ユーザーの場合はsudo時にsudo用のパスをPATHに加える。
    # alias sudo="sudo env PATH=\"$SUDO_PATH:$PATH\""
    :
fi

# pkg-configの設定
## .pcのロードパス
### -x: export PKG_CONFIG_PATHも一緒に行う。
### -T: PKG_CONFIG_PATHとpkg_config_pathを連動する。
typeset -xT PKG_CONFIG_PATH pkg_config_path
### 重複したパスを登録しない。
typeset -U pkg_config_path
### パスを設定。
### (N-/) 存在しないディレクトリは登録しない。
###    パス(...): ...という条件にマッチするパスのみ残す。
###            N: NULL_GLOBオプションを設定。
###               globがマッチしなかったり存在しないパスを無視する。
###            -: シンボリックリンク先のパスを評価。
###            /: ディレクトリのみ残す。
pkg_config_path=(# 自分用
                 $HOME/local/lib/pkgconfig(N-/)
                 # MacPorts用
                 /opt/local/lib/pkgconfig(N-/))

# ページャの設定
if type lv > /dev/null 2>&1; then
    ## lvを優先する。
    export PAGER="lv"
else
    ## lvがなかったらlessを使う。
    export PAGER="less"
fi

# lvの設定
## -c: ANSIエスケープシーケンスの色付けなどを有効にする。
## -l: 1行が長くと折り返されていても1行として扱う。
##     （コピーしたときに余計な改行を入れない。）
export LV="-c -l"

if [ "$PAGER" != "lv" ]; then
    ## lvがなくてもlvでページャーを起動する。
    alias lv="$PAGER"
fi

# lessの設定
## -R: ANSIエスケープシーケンスのみ素通しする。
## --shift 4: 左右カーソルでの横スクロールを4文字単位にする。
## --LONG-PROMPT: 現在の表示範囲を下端に示す
export LESS="-R --shift 4 --LONG-PROMPT"

# grepの設定
## grepのバージョンを検出。
grep_version="$(grep --version | head -n 1 | sed -e 's/^[^0-9.]*\([0-9.]*\)[^0-9.]*$/\1/')"
## デフォルトオプションの設定
grep_options=""
### バイナリファイルにはマッチさせない。
grep_options="--binary-files=without-match"
### 拡張子が.tmpのファイルは無視する。
grep_options="--exclude=\*.tmp $grep_options"
## 管理用ディレクトリを無視する。
if grep --help 2>&1 | grep -q -- --exclude-dir; then
    grep_options="--exclude-dir=.svn $grep_options"
    grep_options="--exclude-dir=.git $grep_options"
    grep_options="--exclude-dir=.deps $grep_options"
    grep_options="--exclude-dir=.libs $grep_options"
fi
### 可能なら色を付ける。
if grep --help 2>&1 | grep -q -- --color; then
    grep_options="--color=auto $grep_options"
fi

alias grep="grep ${grep_options}"

# エディタの設定
## viを使う。
export EDITOR=vi
