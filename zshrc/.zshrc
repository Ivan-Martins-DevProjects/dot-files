# ==============================================================================
# ~/.zshrc
# Arquivo de configuração para o shell Zsh.
# ==============================================================================

# --- Inicialização Rápida do Powerlevel10k ---
# Deve permanecer no topo do arquivo.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Configurações de Ambiente e Sourcing de Arquivos ---

# Carrega variáveis de ambiente personalizadas
. "$HOME/.local/share/../bin/env"

# Define variáveis de ambiente para Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export PATH="$PATH:$HOME/bin"

# Carrega o tema Powerlevel10k
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Carrega o plugin de sugestões automáticas
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Integração do FZF com Zsh (necessário para autocompletar e outras funções)
eval "$(fzf --zsh)"

# Carrega a configuração do Powerlevel10k, se existir
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Função para busca interativa com ripgrep e fzf.
fzf_file() {
  local file

  # Usa 'fd' se disponível, senão 'find'
  if command -v fd >/dev/null 2>&1; then
    file=$(fd --type f --hidden --follow --exclude .git | fzf --preview="bat --style=numbers --color=always {}" --prompt="Abrir arquivo> ")
  else
    file=$(find . -type f -not -path './.git/*' | fzf --prompt="Abrir arquivo> ")
  fi

  # Se algum arquivo foi selecionado, abre no vim (ou apenas imprime)
  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}

# 2. Registra a função wrapper como um widget do Zsh com o nome 'rf_widget'
zle -N rf_widget fzf_file
bindkey '^[c' rf_widget

# ==============================================================================
#   Atalhos de Teclado e Funções com FZF
# ==============================================================================

# --- 1. Atalho ALT+R para carregar sessões tmuxp com fzf (Execução Direta) ---
# Define o diretório onde seus arquivos de sessão do tmuxp estão.
TMUXP_SESSIONS_DIR="$HOME/sessions"

# A função que executa a lógica do fuzzy finder e executa o comando diretamente.
_tmuxp_fzf_load() {
  local session
  session=$(find "$TMUXP_SESSIONS_DIR" -maxdepth 1 -type f -printf "%f\n" | fzf --prompt="Tmux Session> ")

  if [[ -n "$session" ]]; then
    if tmux has-session -t "$session" 2>/dev/null; then
      # Sessão existe, anexar
      BUFFER="tmux a -t $session"
    else
      # Sessão não existe, executar script
      BUFFER="~/sessions/${session%.*}.sh"
    fi

    zle accept-line
    zle reset-prompt
  fi
}
# Cria um widget ZLE a partir da função e o associa ao ALT+R.
zle -N tmuxp_fzf_widget _tmuxp_fzf_load
bindkey '\er' tmuxp_fzf_widget

# --- 3. Atalhos existentes para clipcat ---
bindkey -s '^[e' 'clipcat-menu insert\n' # Alt+E para o menu do clipcat

# Atalho  para dividir painel tmux
split_panel() {
  if [ -n "$TMUX" ]; then
  BUFFER="tmux split-window -v -p 30"

  zle accept-line
  zle reset-prompt
  else
    echo "Sessão do Tmux não encontrada"
  fi
}

zle -N split_panel 
bindkey '^P' split_panel
# ==============================================================================
# --- Aliases ---
# ==============================================================================

# Geral
alias v="nvim"
alias killtmux="tmux kill-server"
alias cvenv="python3 -m venv venv"
alias n='nvim' # Abre o nvim. Se não houver argumentos, abre o diretório atual.

# Sistema de Arquivos
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# Navegação de Diretórios
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Docker
alias dps="docker ps"
alias d='docker'

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# Rails
alias r='rails'

# Python
alias cvenv='python3 -m venv venv'
alias svenv='source venv/bin/activate'lias svenv='source venv/bin/activate'

# LazyConfig
alias lazyconfig='cd ~/.config/nvim/lua'
