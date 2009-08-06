autoload colors; colors

### Tab completion

# Force a reload of completion system if nothing matched; this fixes installing
# a program and then trying to tab-complete its name
_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1    # Because we didn't really complete anything
}

# Always use menu completion, and make the colors pretty!
zstyle ':completion:*' menu select yes
zstyle ':completion:*:default' list-colors ''

# Completers to use: rehash, general completion, then various magic stuff and
# spell-checking.  Only allow two errors when correcting
zstyle ':completion:*' completer _force_rehash _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' max-errors 2

# When looking for matches, first try exact matches, then case-insensiive, then
# partial word completion
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'r:|[._-]=** r:|=**'

# Turn on caching, which helps with e.g. apt
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Show titles for completion types and group by type
zstyle ':completion:*:descriptions' format "$fg_bold[black]» %d$reset_color"
zstyle ':completion:*' group-name ''

zstyle :compinstall filename '/home/eevee/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep nomatch
unsetopt extendedglob notify
bindkey -v
# End of lines configured by zsh-newuser-install

### Eevee stuff

autoload colors; colors

# Pimpin' prompt
# and by pimpin' I mean "like ubuntu"
PROMPT="%{$fg_bold[green]%}%n@%m%{$reset_color%} %{$fg_bold[blue]%}%~%{$reset_color%} %(!.#.$) "
RPROMPT_code="%(?..\$? %{$fg_no_bold[red]%}%?%{$reset_color%}  )"
RPROMPT_jobs="%1(j.%%# %{$fg_no_bold[cyan]%}%j%{$reset_color%}  .)"
RPROMPT_time="%{$fg_bold[black]%}%*%{$reset_color%}"
RPROMPT="$RPROMPT_code$RPROMPT_jobs$RPROMPT_time"

# Tab completion
setopt complete_in_word     # mid-word tab completion
setopt correct              # fix typo'd command names

# Make ls useful regardless of platform
LSOPTS='-laF'  # long mode, show all, use suffix squiggles
LLOPTS=''
case $(uname -s) in
    FreeBSD)
        LSOPTS="${LSOPTS}G"
        ;;
    Linux)
        eval "$(dircolors -b)"
        LSOPTS="$LSOPTS --color=auto"
        LLOPTS="$LLOPTS --color=always"  # so | less is colored
        ;;
esac
alias ls="ls $LSOPTS"
alias ll="ls $LLOPTS | less -FX"

# screen stuff
function title {
    # screen title, xterm title
    local prefix; prefix="${USER}@${HOST}: "
    if [[ $TERM == "screen"* ]]; then
        print -n "\ek$prefix$1\e\\"
    fi
    if [[ $TERM == "xterm"* || $TERM == "screen"* ]]; then
        print -n "\e]0;$prefix$2\a"
    fi
}

function precmd {
    local shortpwd
    shortpwd=${PWD/$HOME/\~}
    title "zsh $shortpwd" "$shortpwd"
}   

function preexec {
    local -a cmd; cmd=(${(z)1})
    title "$cmd[1]:t" "$cmd[2,-1]"
}

# Useful fucking keybindings goddamn
# Taken from http://wiki.archlinux.org/index.php/Zsh and Ubuntu's inputrc
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

bindkey '^i' menu-expand-or-complete    # tab to do menu
bindkey "\e[Z" reverse-menu-complete    # shift-tab to reverse menu

# Machine-specific stuff
if [[ -r $HOME/.zlocal ]]; then
    source $HOME/.zlocal
fi
