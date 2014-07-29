#!/usr/bin/env zsh

set -e

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

# install flake8 with default python
if whence pip > /dev/null; then
    echo 'installing jedi'
    pip install --user --upgrade jedi
else
    echo 'no pip found; skipping jedi (jedi-vim will probably not work!)'
fi
