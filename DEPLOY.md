# 🚀 Guia de Deploy — GitHub Pages

## Pré-requisitos

| Ferramenta | Já tem? | Como instalar |
|---|---|---|
| **Git** | Você tem | — |
| **Node.js/npm** | ✅ Você tem | — |
| **GitHub CLI (gh)** | Verificar abaixo | `brew install gh` / `winget install GitHub.cli` |

---

## Instalação em 1 linha

### Mac / Linux
```bash
brew install gh
```

### Windows
```bash
winget install GitHub.cli
```

### Verificar se já tem
```bash
gh --version
```

---

## Deploy em 3 passos

### 1️⃣ Login no GitHub (só na primeira vez)
```bash
gh auth login
```
> Vai abrir o browser — autorize o GitHub CLI

### 2️⃣ Rodar o script automático
```bash
bash deploy.sh
```

### 3️⃣ Aguardar ~2 minutos e acessar

```
https://SEU_USUARIO.github.io/optimumlab
https://SEU_USUARIO.github.io/optimumlab/orcamento.html
```

---

## Atualizar o site

Depois de qualquer mudança nos arquivos:

```bash
git add .
git commit -m "update"
git push
```

O site atualiza automaticamente em ~30 segundos.

---

## Domínio personalizado (opcional)

Se quiser usar `optimumlab.io` ou similar:

1. No GitHub, vá em: `Settings > Pages > Custom domain`
2. Digite seu domínio: `optimumlab.io`
3. No seu registrador (Namecheap), adicione um CNAME:
   ```
   CNAME  www  SEU_USUARIO.github.io
   ```
4. HTTPS automático em ~10 minutos ✅

---

## Estrutura do projeto

```
optimumlab/
├── index.html          ← Landing page principal
├── orcamento.html      ← Fluxo de orçamento (6 etapas)
├── 404.html            ← Redirect para SPA
├── README.md
├── DEPLOY.md           ← Este arquivo
└── deploy.sh           ← Script automático de deploy
```
