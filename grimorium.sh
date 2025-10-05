!/usr/bin/env bash
set -e

# =========================================================
#        Raven Obsidian 
#        Autor: Mist Raven
# =========================================================

# --- Cores ANSI ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

BASE_DIR="/home/mist/biblioteca/DCPT/DCPT"
TEMPLATES_DIR="$BASE_DIR/Templates"
NOTES_DIR="$BASE_DIR/Notes"

mkdir -p "$TEMPLATES_DIR" "$NOTES_DIR"

# --- Banner animado com partículas ---
SYMBOLS=("🜁" "🜂" "🜃" "🜄")
for frame in {1..3}; do
    clear
    for sym in "${SYMBOLS[@]}"; do
        echo -e "${MAGENTA}================================================${NC}"
        echo -e "${BOLD}${CYAN}        $sym Raven Obsidian - Grande Alquimia $sym${NC}"
        echo -e "${MAGENTA}================================================${NC}"
        for i in {1..3}; do
            echo -ne "${YELLOW}   *${NC}"; sleep 0.05
        done
        sleep 0.1
        clear
    done
done

# --- Criar ou usar template ---
read -p "$(echo -e ${YELLOW}Deseja criar um novo template de nota? \(s/n\)${NC} )" CREATE_TEMPLATE
if [[ "$CREATE_TEMPLATE" =~ ^[Ss]$ ]]; then
    read -p "$(echo -e ${YELLOW}Nome do template \(ex: template_note.md\):${NC} )" TEMPLATE_NAME
    TEMPLATE_PATH="$TEMPLATES_DIR/$TEMPLATE_NAME"
    cat > "$TEMPLATE_PATH" <<'EOF'
---
title: "{{title}}"
tags: [{{tags}}]
created: {{date}}
status: rascunho
category: "{{category}}"
---

# {{title}}

## Summary

## ELI5

## Tutorial / Passos

## Cheat Sheet

## Exemplos práticos

## Links
EOF
    echo -e "${GREEN}✅ Template criado em: $TEMPLATE_PATH${NC}"
else
    TEMPLATE_PATH="$TEMPLATES_DIR/template_note.md"
    if [[ ! -f "$TEMPLATE_PATH" ]]; then
        cat > "$TEMPLATE_PATH" <<'EOF'
---
title: "{{title}}"
tags: [{{tags}}]
created: {{date}}
status: rascunho
category: "{{category}}"
---

# {{title}}

## Summary

## ELI5

## Tutorial / Passos

## Cheat Sheet

## Exemplos práticos

## Links
EOF
    fi
fi

# --- Função mini GUI ---
interactive_menu() {
    local prompt="$1"; shift
    local options=("$@")
    local idx=0
    local key
    while true; do
        clear
        echo -e "${CYAN}${prompt}${NC}"
        for i in "${!options[@]}"; do
            if [[ $i -eq $idx ]]; then
                echo -e "${GREEN}> ${options[$i]}${NC}"
            else
                echo "  ${options[$i]}"
            fi
        done
        IFS= read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key
            [[ $key == '[A' ]] && ((idx--))
            [[ $key == '[B' ]] && ((idx++))
        elif [[ $key == "" ]]; then
            echo "${options[$idx]}"
            return
        fi
        ((idx=idx<0?${#options[@]}-1:idx))
        ((idx=idx>=${#options[@]}?0:idx))
    done
}

# --- Título ---
read -p "$(echo -e ${YELLOW}Título da nota:${NC} )" TITLE
while [[ -z "$TITLE" ]]; do
    read -p "$(echo -e ${YELLOW}O título não pode ser vazio. Título da nota:${NC} )" TITLE
done

# --- Categoria ---
CATEGORIES=($(find "$NOTES_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;))
CATEGORIES+=("Criar nova categoria")
CATEGORY=$(interactive_menu "Escolha a categoria (Enter para confirmar):" "${CATEGORIES[@]}")
if [[ "$CATEGORY" == "Criar nova categoria" ]]; then
    read -p "Digite o nome da nova categoria: " NEW_CAT
    CATEGORY="$NEW_CAT"
    mkdir -p "$NOTES_DIR/$CATEGORY"
else
    mkdir -p "$NOTES_DIR/$CATEGORY"
fi

# --- Tags múltiplas ---
SUGGESTED_TAGS=("linux" "pentest" "exploit" "kernel" "privilege" "tutorial" "exemplo")
selected=()
cursor=0

while true; do
    clear
    echo -e "${CYAN}Use ↑↓ para mover, espaço para marcar/desmarcar, Enter para confirmar:${NC}"
    for i in "${!SUGGESTED_TAGS[@]}"; do
        mark="[ ]"
        [[ " ${selected[*]} " =~ " $i " ]] && mark="[x]"
        if [[ $i -eq $cursor ]]; then
            echo -e "${YELLOW}> $mark ${SUGGESTED_TAGS[$i]}${NC}"
        else
            echo "  $mark ${SUGGESTED_TAGS[$i]}"
        fi
    done
    IFS= read -rsn1 key
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key
        [[ $key == '[A' ]] && ((cursor=(cursor-1<0?${#SUGGESTED_TAGS[@]}-1:cursor-1)))
        [[ $key == '[B' ]] && ((cursor=(cursor+1>=${#SUGGESTED_TAGS[@]}?0:cursor+1)))
    elif [[ $key == " " ]]; then
        if [[ " ${selected[*]} " =~ " $cursor " ]]; then
            selected=(${selected[@]/$cursor/})
        else
            selected+=($cursor)
        fi
    elif [[ $key == "" ]]; then
        break
    fi
done

TAGS=()
for i in "${selected[@]}"; do TAGS+=("${SUGGESTED_TAGS[$i]}"); done
read -p "Digite tags adicionais separadas por vírgula ou Enter: " EXTRA_TAGS
[[ -n "$EXTRA_TAGS" ]] && TAGS+=($(echo "$EXTRA_TAGS" | tr ',' ' '))
TAGS_STR=$(IFS=, ; echo "${TAGS[*]}")

# --- Confirmação final com animação ---
echo -e "${CYAN}\nResumo da nota:${NC}"
echo -e "${BOLD}Título   :${NC} $TITLE"
echo -e "${BOLD}Categoria:${NC} $CATEGORY"
echo -e "${BOLD}Tags     :${NC} $TAGS_STR"
echo -ne "${YELLOW}Criar nota"
for i in {1..3}; do echo -n "."; sleep 0.2; done
read -p " (s/n)? " CONFIRM
[[ ! "$CONFIRM" =~ ^[Ss]$ ]] && { echo -e "${RED}Operação cancelada.${NC}"; exit 0; }

# --- Criar arquivo para Obsidian ---
DATE="$(date +%F)"
SLUG="$(echo "$TITLE" | iconv -t ascii//TRANSLIT | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-|-$//g')"
DEST="$NOTES_DIR/$CATEGORY/${DATE}-${SLUG}.md"

perl -pe '
  s/\{\{title\}\}/$ENV{TITLE}/g;
  s/\{\{tags\}\}/$ENV{TAGS_STR}/g;
  s/\{\{date\}\}/$ENV{DATE}/g;
  s/\{\{category\}\}/$ENV{CATEGORY}/g;
' "$TEMPLATE_PATH" > "$DEST"

# --- Efeito de brilho final ---
for i in {1..3}; do
    echo -ne "${GREEN}✨ Nota criada com sucesso em: $DEST ✨${NC}\r"; sleep 0.3
    echo -ne "                                           \r"; sleep 0.1
done
echo -e "${GREEN}⚗️  Nota criada com sucesso em: $DEST${NC}"
