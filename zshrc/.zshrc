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

# Correção: Carrega as configurações do Omarchy diretamente no Zsh
# A linha anterior `bash -c "source ..."` não funcionava como esperado.
#source ~/.local/share/omarchy/default/bash/rc

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


# --- Funções Personalizadas ---

# Função para busca interativa de texto com ripgrep e fzf, abrindo o resultado no editor
# Portada do .bashrc, totalmente compatível com Zsh.
rf() {
  if [ ! "$#" -gt 0 ]; then echo "Precisa de um padrão de busca"; return 1; fi
  local file
  local line
  read -r file line <<<$(rg --line-number "$@" | fzf --delimiter : --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' --preview-window +{2}-/5 | awk -F: '{print $1, $2}')
  if [ -n "$file" ]; then
    $EDITOR +"$line" "$file"
  fi
}

# Função para mudar de diretório, usando zoxide se o caminho não for exato
zd() {
  if [ $# -eq 0 ]; then
    builtin cd ~ && return
  elif [ -d "$1" ]; then
    builtin cd "$1"
  else
    z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}

# Função para abrir arquivos com o aplicativo padrão em background
open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

# Função para buscar e editar um arquivo interativamente com fzf
# Usa 'fd' se disponível, senão usa 'find'. Mostra prévia com 'bat'.
fzf_edit() {
  local file
  local file_list_cmd

  # Usa 'fd' (find alternativo) se estiver instalado, senão usa 'find'.
  # 'fd' é mais rápido e já ignora arquivos do .gitignore.
  if command -v fd >/dev/null 2>&1; then
    file_list_cmd="fd --type f --hidden --follow --exclude .git"
  else
    file_list_cmd="find . -type f -not -path './.git/*'"
  fi

  # Executa o comando de listagem, passa para o fzf e armazena o arquivo selecionado
  file=$(eval "$file_list_cmd" | fzf --prompt="🔍 Editar arquivo> " --preview 'bat --style=numbers --color=always --line-range :500 {}')

  # Se um arquivo foi selecionado, abre-o com o editor
  if [[ -n "$file" ]]; then
    echo "Abrindo '$file'..."
    v "$file"
    zle reset-prompt
  else
    echo "Nenhum arquivo selecionado."
    zle reset-prompt
  fi
}

# --- Atalho de Teclado para a Função ---
zle -N fzf_edit
bindkey '^[c' fzf_edit # Exemplo: Ctrl+E para Editar
bindkey -s '^[e' 'clipcat-menu insert\n'

# ==============================================================================
# Função para buscar e navegar para um diretório com fzf
# ==============================================================================
fzf_cd() {
  local dir

  # Usa 'fd' (find alternativo) se estiver instalado, senão usa 'find'.
  # 'fd' é mais rápido, já ignora pastas do .gitignore e inclui hidden por padrão nesta busca.
  if command -v fd >/dev/null 2>&1; then
    dir=$(fd --type d --hidden --follow --exclude .git | fzf --prompt="📁 Navegar para> ")
  else
    # Fallback para o 'find' tradicional
    dir=$(find . -type d -not -path './.git/*' | fzf --prompt="📁 Navegar para> ")
  fi

  # Se um diretório foi selecionado, navega até ele
  if [[ -n "$dir" ]]; then
    cd "$dir"
    # Reseta o prompt para refletir a nova localização
    zle reset-prompt
  fi
}

# --- Atalho de Teclado para a Função ---
zle -N fzf_cd
bindkey '^R' fzf_cd

# --- Aliases ---

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
alias cd="zd" # Sobrescreve o cd para usar a função zd

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
alias svenv='source venv/bin/activate'
