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

# Ignore some common useless files
zstyle ':completion:*:*:(^rm):*:*' ignored-patterns '*?.pyc' '__pycache__'

zstyle :compinstall filename '/home/eevee/.zshrc'

# Always do mid-word tab completion
setopt complete_in_word

autoload -Uz compinit
compinit


### History
setopt extended_history hist_no_store hist_ignore_dups inc_append_history
export HISTFILE=~/.zsh_history
export HISTSIZE=2000
export SAVEHIST=2000


### Some..  options
setopt autocd beep extendedglob nomatch
unsetopt notify

# Don't count common path separators as word characters
WORDCHARS=${WORDCHARS//[&.;\/]}


### Prompt

PROMPT="%{$fg_bold[green]%}%n@%m%{$reset_color%} %{$fg_bold[blue]%}%~%{$reset_color%} %(!.☭.⚘) "
RPROMPT_code="%(?..\$? %{$fg_no_bold[red]%}%?%{$reset_color%}  )"
RPROMPT_jobs="%1(j.%%# %{$fg_no_bold[cyan]%}%j%{$reset_color%}  .)"
RPROMPT_time="%{$fg_bold[black]%}%*%{$reset_color%}"
RPROMPT="$RPROMPT_code$RPROMPT_jobs$RPROMPT_time"


### Misc aliases

if whence ack-grep &> /dev/null; then
    alias ack=ack-grep
fi
alias apt='sudo aptitude'

# Don't glob with find or wget
for command in find wget; \
    alias $command="noglob $command"

# rvm
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm


### ls

LSOPTS='-lAvF --si'  # long mode, show all, natural sort, type squiggles, friendly sizes
LLOPTS=''
case $(uname -s) in
    FreeBSD)
        LSOPTS="${LSOPTS} -G"
        ;;
    Linux)
        eval "$(dircolors -b)"
        LSOPTS="$LSOPTS --color=auto"
        LLOPTS="$LLOPTS --color=always"  # so | less is colored

        # Just loaded new ls colors via dircolors, so change completion colors
        # to match
        zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
        ;;
esac
alias ls="ls $LSOPTS"
alias ll="ls $LLOPTS | less -FX"


### screen

function title {
    # param: title to use

    local prefix=''

    # If I'm in a screen, all the windows are probably on the same machine, so
    # I don't really need to title every single one with the machine name.
    # On the other hand, if I'm not logged in as me (but, e.g., root), I'd
    # certainly like to know that!
    if [[ $USER != 'eevee' && $USER != 'amunroe' ]]; then
        prefix="[$USER] "
    fi
    # Set screen window title
    if [[ $TERM == "screen"* ]]; then
        print -n "\ek$prefix$1\e\\"
    fi


    # Prefix the xterm title with the current machine name, but only if I'm not
    # on a local machine.  This is tricky, because screen won't reliably know
    # whether I'm using SSH right now!  So just assume I'm local iff I'm not
    # running over SSH *and* not using screen.  Local screens are fairly rare.
    prefix=$HOST
    if [[ $SSH_CONNECTION == '' && $TERM != "screen"* ]]; then
        prefix=''
    fi
    # If we're showing host and I'm not under my usual username, prepend it
    if [[ $prefix != '' && $USER != 'eevee' && $USER != 'amunroe' ]]; then
        prefix="$USER@$prefix"
    fi
    # Wrap it in brackets
    if [[ $prefix != '' ]]; then
        prefix="[$prefix] "
    fi

    # Set xterm window title
    if [[ $TERM == "xterm"* || $TERM == "screen"* ]]; then
        print -n "\e]0;$prefix$1\a"
    fi
}

function precmd {
    # Shorten homedir back to '~'
    local shortpwd=${PWD/$HOME/\~}
    title "zsh $shortpwd"
}

function preexec {
    title $*
}


### Keybindings

bindkey -e

# General movement
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

# Tab completion
bindkey '^i' complete-word              # tab to do menu
bindkey "\e[Z" reverse-menu-complete    # shift-tab to reverse menu

# Up/down arrow: search history for first word
bindkey "\e[A" up-line-or-search
bindkey "\e[B" down-line-or-search


### Machine-specific extras

if [[ -r $HOME/.zlocal ]]; then
    source $HOME/.zlocal
fi
