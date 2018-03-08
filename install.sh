#!/usr/bin/env zsh

set -e

echo 'updating submodules'
git submodule update --init --recursive

echo 'please hold while i build YouCompleteMe'
# TERM=xterm works around https://github.com/mono/mono/issues/6752
( cd .vim/bundle/YouCompleteMe; TERM=xterm ./install.py --clang-completer --cs-completer --rust-completer --js-completer )

echo 'linking stuff'
local here=$(dirname $0)
for file in .XCompose .ackrc .gitconfig .gitignore-global .psqlrc .screenrc .tmux.conf .vimrc .vim .zshenv .zshrc; do
    if [[ $file == '.gitconfig' && $USER != 'eevee' && $USER != 'amunroe' ]]; then
        echo "not linking $file, it has my name in it!  do it yourself"
    else
        if [[ $(readlink -f $HOME/$file) != $(readlink -f $here/$file) ]]; then
            ln -i -s -T $here/$file $HOME/$file
            echo "linked $file"
        fi
    fi
done

# airline (powerline) font stuff
if whence fc-cache > /dev/null; then
    echo 'installing powerline font'
    mkdir -p ~/.fonts/
    wget -O ~/.fonts/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
    fc-cache -vf ~/.fonts/

    mkdir -p ~/.config/fontconfig/conf.d/
    wget -O ~/.config/fontconfig/conf.d/10-powerline-symbols.conf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
else
    echo 'no fontconfig found; skipping powerline font'
fi
