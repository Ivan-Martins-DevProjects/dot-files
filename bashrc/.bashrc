# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

# If you set OSH_THEME to "random", you can ignore themes you don't like.
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")
# You can also specify the list from which a theme is randomly selected:
# OMB_THEME_RANDOM_CANDIDATES=("font" "powerline-light" "minimal")

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

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

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# To enable/disable Spack environment information
# OMB_PROMPT_SHOW_SPACK_ENV=true  # enable
# OMB_PROMPT_SHOW_SPACK_ENV=false # disable

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
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# ==============================================================================
# ~/.bashrc
# Arquivo de configuração para o shell Bash.
# ==============================================================================

# --- Configurações de Ambiente e Sourcing ---

# Carrega variáveis de ambiente personalizadas
[ -f "$HOME/.local/share/../bin/env" ] && . "$HOME/.local/share/../bin/env"

# Define variáveis de ambiente para Go
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/bin"

# --- Plugins e Temas ---
# Nota: Powerlevel10k e zsh-autosuggestions são EXCLUSIVOS do Zsh.
# Para Bash, recomenda-se o 'Oh My Bash' ou 'Starship' para estética similar.
# O bloco do p10k-instant-prompt foi removido por ser incompatível.

# Integração do FZF com Bash
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi

# ==============================================================================
# Funções e Atalhos de Teclado
# ==============================================================================

# Função para busca interativa com ripgrep/fd e fzf
fzf_file() {
  local file
  if command -v fd >/dev/null 2>&1; then
    file=$(fd --type f --hidden --follow --exclude .git | fzf --preview="bat --style=numbers --color=always {}" --prompt="Abrir arquivo> ")
  else
    file=$(find . -type f -not -path './.git/*' | fzf --prompt="Abrir arquivo> ")
  fi

  if [[ -n "$file" ]]; then
    # No Bash, para executar comandos via atalho, usamos 'READLINE_LINE'
    nvim "$file"
  fi
  # Força o redesenho do prompt no Bash
  bind '"\e[0n": ""'
  printf '\e[5n'
}

# Atalho ALT+C para fzf_file
# No Bash, mapeamos a função e depois o atalho
bind -x '"\ec": fzf_file'

# --- 1. Atalho ALT+R para carregar sessões tmuxp ---
TMUXP_SESSIONS_DIR="$HOME/sessions"

_tmuxp_fzf_load() {
  local session
  session=$(find "$TMUXP_SESSIONS_DIR" -maxdepth 1 -type f -printf "%f\n" | fzf --prompt="Tmux Session> ")

  if [[ -n "$session" ]]; then
    if tmux has-session -t "$session" 2>/dev/null; then
      tmux a -t "$session"
    else
      bash "$HOME/sessions/${session%.*}.sh"
    fi
  fi
  bind '"\e[0n": ""'
  printf '\e[5n'
}
bind -x '"\er": _tmuxp_fzf_load'

# --- Atalho CTRL+P para dividir painel tmux ---
split_panel() {
  if [ -n "$TMUX" ]; then
    tmux split-window -v -p 30
  else
    echo "Sessão do Tmux não encontrada"
  fi
}
bind -x '"\C-p": split_panel'

# --- Atalho ALT+E para Clipcat ---
# O Bash não tem 'bindkey -s' direto para comandos com newline como o Zsh de forma simples
# Usamos o bind -x para executar o binário diretamente
bind -x '"\ee": "clipcat-menu insert"'

# ==============================================================================
# --- Aliases ---
# ==============================================================================

alias v="nvim"
alias killtmux="tmux kill-server"
alias cvenv="python3 -m venv venv"
alias svenv='source venv/bin/activate'

# Sistema de Arquivos (eza)
if command -v eza >/dev/null 2>&1; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --long --icons --git'
else
  alias ls='ls -lh --color=auto'
fi
alias lsa='ls -a'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# Navegação
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Docker, Git, Rails, Python
alias dps="docker ps"
alias d='docker'
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias r='rails'
alias lazyconfig='cd ~/.config/nvim/lua'

# Spring-Boot
alias springdev='mvn spring-boot:run -Dspring-boot.run.profiles=dev'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Load Angular CLI autocompletion.
source <(ng completion script)

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
export PATH="$HOME/.local/bin:$PATH"

# Carregando Mise (Controle de versão de linguagens)
eval $(mise activate bash)

# mimocode
export PATH=/home/ivan/.mimocode/bin:$PATH

# Android Studio
export ANDROID_HOME=/home/ivan/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin

export OMNIROUTE_API_KEY="sk-9bcdd57b82ec2513-b8d900-58a96871"

eval "$(oh-my-posh init bash --config ~/.cache/oh-my-posh/themes/sonicboom_dark.omp.json)"

source ~/.local/share/blesh/ble.sh
