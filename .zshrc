# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*:default' list-colors ''  # default ls colors
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' substitute 1
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
setopt menu_complete        # start iterating through completions immediately

# screen stuff
function title {
    # xterm title, screen title
    if [[ $TERM == "screen"* ]]; then
        print -nR $'\033k'$1$'\033\\'
        print -nR $'\033]0;'$2$'\a'
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
bindkey '^i' expand-or-complete

# Machine-specific stuff
if [[ -r $HOME/.zlocal ]]; then
    source $HOME/.zlocal
fi
