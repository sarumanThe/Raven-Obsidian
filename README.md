# 🜁 Mist Grimorium - Raven Obsidian Alquimia

**Script interativo de automação para criação de notas no Obsidian**

**Stack:** Bash | Obsidian | Linux | Perl

[Instalação](#-instalação) • [Como Usar](#-como-usar) • [Features](#-features) • [Customização](#-customização)

---

## 📖 Sobre

**Mist Grimorium** é um script bash interativo que transforma a criação de notas para Obsidian em uma experiência fluida e automatizada. Com interface CLI animada e navegação intuitiva, ele elimina o trabalho repetitivo de criar arquivos, copiar templates e preencher metadata manualmente.

Perfeito para profissionais que precisam documentar rapidamente: pentesters, desenvolvedores, pesquisadores, estudantes e qualquer pessoa que valorize um workflow eficiente de anotações.

## ✨ Features

- 🎨 **Interface CLI Interativa** - Navegação com setas, seleção visual e animações
- 📝 **Sistema de Templates** - Crie e reutilize templates customizados
- 📁 **Organização Automática** - Categorias e estrutura de pastas inteligente
- 🏷️ **Tags Múltiplas** - Seleção interativa com checkboxes no terminal
- 📅 **Nomenclatura Padronizada** - Arquivos com data + slug automático
- ⚡ **Metadados YAML** - Frontmatter completo preenchido automaticamente
- 🎭 **Efeitos Visuais** - Animações e feedback colorido durante a execução

## 🚀 Instalação

### Pré-requisitos

```bash
# Verificar dependências (geralmente já instaladas)
bash --version  # Bash 4.0+
perl --version  # Perl 5+
```

### Clone e Configure

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/mist-grimorium.git
cd mist-grimorium

# Dê permissão de execução
chmod +x mistGrimorium.sh

# Configure o caminho do seu vault Obsidian (linha 18 do script)
# BASE_DIR="/home/mist/biblioteca/DCPT/DCPT"
nano mistGrimorium.sh
```

### Instalação Global (Opcional)

```bash
# Copie para um diretório no PATH
sudo cp mistGrimorium.sh /usr/local/bin/grimorium
sudo chmod +x /usr/local/bin/grimorium

# Agora você pode rodar de qualquer lugar
grimorium
```

## 💻 Como Usar

### Execução Básica

```bash
./mistGrimorium.sh
```

### Fluxo de Trabalho

1. **Banner Animado** - Visualização inicial com símbolos alquímicos
2. **Template** - Escolha criar novo ou usar existente
3. **Título** - Digite o título da nota
4. **Categoria** - Navegue com ↑↓ e selecione com Enter
5. **Tags** - Use espaço para marcar/desmarcar, Enter para confirmar
6. **Confirmação** - Revise os dados e confirme

### Exemplo de Uso

```
🜁 Raven Obsidian - Grande Alquimia 🜂

Deseja criar um novo template de nota? (s/n) n
Título da nota: Privilege Escalation no Linux

Escolha a categoria (Enter para confirmar):
> Pentest
  Exploit
  Kernel
  Criar nova categoria

Use ↑↓ para mover, espaço para marcar/desmarcar, Enter para confirmar:
  [ ] linux
  [x] pentest
  [x] exploit
> [ ] kernel
  [x] privilege
  [ ] tutorial
  [ ] exemplo

Digite tags adicionais separadas por vírgula ou Enter: CVE-2024-1234

Resumo da nota:
Título   : Privilege Escalation no Linux
Categoria: Pentest
Tags     : pentest,exploit,privilege,CVE-2024-1234
Criar nota... (s/n)? s

⚗️  Nota criada com sucesso em: /home/mist/biblioteca/DCPT/DCPT/Notes/Pentest/2025-10-05-privilege-escalation-no-linux.md
```

## 📋 Estrutura do Template

O template padrão inclui:

```markdown
---
title: "Seu Título"
tags: [suas, tags]
created: 2025-10-05
status: rascunho
category: "Categoria"
---

# Seu Título

## Summary
Resumo executivo do conteúdo

## ELI5
Explicação simplificada (Explain Like I'm 5)

## Tutorial / Passos
Passo a passo detalhado

## Cheat Sheet
Comandos e snippets rápidos

## Exemplos práticos
Casos de uso reais

## Links
Referências e recursos externos
```

## 🎨 Customização

### Modificar Categorias Sugeridas

Edite a linha 141 do script:

```bash
SUGGESTED_TAGS=("linux" "pentest" "exploit" "kernel" "privilege" "tutorial" "exemplo")
```

### Personalizar Template

Crie seu próprio template em `$TEMPLATES_DIR/seu_template.md` com placeholders:

- `{{title}}` - Título da nota
- `{{tags}}` - Tags selecionadas
- `{{date}}` - Data de criação
- `{{category}}` - Categoria escolhida

### Alterar Cores

Modifique as variáveis de cor (linhas 11-17):

```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'
```

## 🗂️ Estrutura de Arquivos

```
BASE_DIR/
├── Templates/
│   └── template_note.md
└── Notes/
    ├── Pentest/
    │   └── 2025-10-05-privilege-escalation-no-linux.md
    ├── Exploit/
    └── Kernel/
```

## 🛠️ Tecnologias

- **Bash** - Shell scripting
- **Perl** - Substituição de placeholders
- **ANSI Colors** - Interface colorida
- **iconv** - Conversão de caracteres para slugs

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se livre para:

1. Fazer fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abrir um Pull Request


## 👤 Autor

**Mist Raven**

**Feito com 🖤 e ⚗️ por Mist Raven**
