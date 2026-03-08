#!/bin/bash

# ============================================================
#  OPTIMUM LAB — Deploy automático para GitHub Pages
#  Execute UMA VEZ: bash deploy.sh
# ============================================================

set -e  # Para se der erro

# ── CORES ────────────────────────────────────────────────────
GREEN='\033[0;32m'
GOLD='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo ""
echo -e "${GOLD}${BOLD}  ╔═══════════════════════════════════════╗${NC}"
echo -e "${GOLD}${BOLD}  ║     OPTIMUM LAB — Deploy Script       ║${NC}"
echo -e "${GOLD}${BOLD}  ║     GitHub Pages (gratuito)           ║${NC}"
echo -e "${GOLD}${BOLD}  ╚═══════════════════════════════════════╝${NC}"
echo ""

# ── STEP 1: Verificar dependências ───────────────────────────
echo -e "${CYAN}[1/5] Verificando dependências...${NC}"

if ! command -v git &> /dev/null; then
  echo -e "${RED}✗ Git não encontrado. Instale em: https://git-scm.com${NC}"
  exit 1
fi
echo -e "${GREEN}✓ git ok${NC}"

if ! command -v gh &> /dev/null; then
  echo ""
  echo -e "${GOLD}⚠  GitHub CLI (gh) não instalado.${NC}"
  echo -e "   Instale em: ${CYAN}https://cli.github.com${NC}"
  echo ""
  echo -e "   Mac:     ${BOLD}brew install gh${NC}"
  echo -e "   Windows: ${BOLD}winget install GitHub.cli${NC}"
  echo -e "   Linux:   ${BOLD}sudo apt install gh${NC}"
  echo ""
  echo -e "   Depois rode: ${BOLD}gh auth login${NC}"
  echo -e "   E execute este script novamente."
  exit 1
fi
echo -e "${GREEN}✓ gh ok${NC}"

# ── STEP 2: Login no GitHub ───────────────────────────────────
echo ""
echo -e "${CYAN}[2/5] Verificando autenticação GitHub...${NC}"

if ! gh auth status &> /dev/null; then
  echo -e "${GOLD}→ Fazendo login no GitHub...${NC}"
  gh auth login
fi
echo -e "${GREEN}✓ Autenticado${NC}"

# Pegar username
GH_USER=$(gh api user --jq '.login')
echo -e "${GREEN}✓ Usuário: ${BOLD}${GH_USER}${NC}"

# ── STEP 3: Configurar repositório ───────────────────────────
echo ""
echo -e "${CYAN}[3/5] Configurando repositório...${NC}"

REPO_NAME="optimumlab"

# Inicializar git se necessário
if [ ! -d ".git" ]; then
  git init
  git checkout -b main
  echo -e "${GREEN}✓ Git inicializado${NC}"
fi

# Configurar .gitignore
cat > .gitignore << 'GITIGNORE'
.DS_Store
*.log
node_modules/
.env
GITIGNORE

# Adicionar arquivos
git add .
git commit -m "🚀 Optimum Lab — deploy inicial" 2>/dev/null || \
git commit --allow-empty -m "🚀 Optimum Lab — deploy inicial"
echo -e "${GREEN}✓ Commit criado${NC}"

# Criar/vincular repositório remoto
if gh repo view "${GH_USER}/${REPO_NAME}" &> /dev/null; then
  echo -e "${GOLD}→ Repositório já existe, usando existente...${NC}"
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://github.com/${GH_USER}/${REPO_NAME}.git"
else
  echo -e "${GOLD}→ Criando repositório no GitHub...${NC}"
  gh repo create "${REPO_NAME}" --public --source=. --remote=origin --push
  echo -e "${GREEN}✓ Repositório criado${NC}"
fi

# ── STEP 4: Push ─────────────────────────────────────────────
echo ""
echo -e "${CYAN}[4/5] Fazendo push para GitHub...${NC}"

git push -u origin main --force
echo -e "${GREEN}✓ Código enviado${NC}"

# ── STEP 5: Ativar GitHub Pages ───────────────────────────────
echo ""
echo -e "${CYAN}[5/5] Ativando GitHub Pages...${NC}"

gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/${GH_USER}/${REPO_NAME}/pages" \
  -f source='{"branch":"main","path":"/"}' \
  2>/dev/null || \
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  "/repos/${GH_USER}/${REPO_NAME}/pages" \
  -f source='{"branch":"main","path":"/"}' \
  2>/dev/null || true

echo -e "${GREEN}✓ GitHub Pages ativado${NC}"

# ── RESULTADO ─────────────────────────────────────────────────
SITE_URL="https://${GH_USER}.github.io/${REPO_NAME}"
REPO_URL="https://github.com/${GH_USER}/${REPO_NAME}"

echo ""
echo -e "${GOLD}${BOLD}  ╔═══════════════════════════════════════════════╗${NC}"
echo -e "${GOLD}${BOLD}  ║           ✅  DEPLOY CONCLUÍDO!               ║${NC}"
echo -e "${GOLD}${BOLD}  ╚═══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}  🌐 Site:${NC}        ${CYAN}${SITE_URL}${NC}"
echo -e "${BOLD}  📁 Repositório:${NC} ${CYAN}${REPO_URL}${NC}"
echo -e "${BOLD}  🛒 Orçamento:${NC}   ${CYAN}${SITE_URL}/orcamento.html${NC}"
echo ""
echo -e "${GOLD}  ⏱  O site fica ativo em ~2 minutos.${NC}"
echo ""
echo -e "  Para atualizar o site no futuro:"
echo -e "  ${BOLD}git add . && git commit -m 'update' && git push${NC}"
echo ""
