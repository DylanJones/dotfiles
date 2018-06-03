# If you come from bash you might have to change your $PATH.
 export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="lukerandall" #the one like ubuntu
#ZSH_THEME="dpoggi"
ZSH_THEME="agnoster"
#ZSH_THEME="random"
DEFAULT_USER='dylan'

# Disables the auto-update prompt.  If this is true and 
# disable_auto_update is false, it will upgrade without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git archlinux python sudo vi-mode)


#-----------------PLUGIN OPTIONS-----------------#

####Tmux plugin######
# Autostarts tmux whenever you log into a terminal
ZSH_TMUX_AUTOSTART=false

# Only attempt to autostart tmux once. If this is 
# disabled when the previous option is enabled, 
# then tmux will be autostarted every time you 
# source your zsh config files.
ZSH_TMUX_AUTOSTART_ONCE=true

# When running tmux automatically connect to the currently running tmux 
# session if it exits, otherwise start a new session.
ZSH_TMUX_AUTOCONNECT=true

# Close the terminal session when tmux exits.
#ZSH_TMUX_AUTOQUIT=true
ZSH_TMUX_AUTOQUIT=false

# When running tmux, the variable $TERM is supposed 
# to be set to screen or one of its derivatives. 
# This option will set the default-terminal option 
# of tmux to screen-256color if 256 color terminal 
# support is detected, and screen otherwise. The 
# term values it uses can be overridden by changing the 
# ZSH_TMUX_FIXTERM_WITH_256COLOR and 
# ZSH_TMUX_FIXTERM_WITHOUT_256COLOR variables respectively. 
ZSH_TMUX_FIXTERM=true

#------------------END PLUGIN OPTIONS-----------------#

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#If the file ~/.aliases exists, use it for aliases
if [ -f ~/.aliases ]; then
	source ~/.aliases
fi

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Unfortuantley, powerline is too slow.
# never mind, just need to start powerline-daemon
# powerline-daemon -q
# doing it as a systemd service now
. "$HOME/.local/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh"
# powerline-daemon

# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
#zstyle ':completion:*' format '%F{red}completing%f %F{lightred}%d%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-,]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 4
zstyle ':completion:*' menu select=1
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt 'corrections: (errors: %e)'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt appendhistory autocd extendedglob
unsetopt beep nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install


export EDITOR=vim
# lets try this out...
# no

# Make GPG work
export GPG_TTY=$(tty)

#eval $(thefuck --alias --enable-experimental-instant-mode)
eval $(thefuck --alias )

# make agnoster theme not be eye cancer
# context: display user, with proper highlighting if necesary
#prompt_context() {
#  local user=`whoami`
#
#  if [[ "$user" == "dylan" && -z "$SSH_CONNECTION" ]]; then
#    prompt_segment 31 white "%B%(!.%{%F{black}%}.)$user%b"
#  else
#    prompt_segment red white "%B%(!.%{%F{black}%}.)$user%b"
#  fi
#}
#prompt_status() {
#  local symbols
#  symbols=()
#  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
#  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
#  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"
#
#  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
#}
#prompt_dir() {
#    DIR="$(echo $(pwd) | sed "s/\// $(echo -ne \\uE0B1) /g")"
#    prompt_segment 240 252 "%b$DIR%b"
#}
#
## make agnoster faster
#prompt_hg() {}
#prompt_bzr() {}
