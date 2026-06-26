# Instruções para Manutenção do Site de Estética Avançada

Este documento descreve as diretrizes que **devem ser seguidas pelo Claude** para manutenção e desenvolvimento do site de Estética Avançada. Todas as instruções aqui definidas são obrigatórias durante o desenvolvimento.

---

## 🧱 Estrutura do Projeto
O projeto segue a seguinte organização de diretórios e arquivos:

```
/
├── index.html            (página única do redesign)
├── faq.html              (Dúvidas Frequentes + formas de pagamento + endereço)
├── /assets
│   ├── /portfolio (imagens de trabalhos realizados)
│   └── imagens do site (JPG, PNG, SVG, WebP)
├── /.claude
│   └── CLAUDE.md (este arquivo)
├── /.gemini
│   └── GEMINI.md (instruções para Gemini)
└── /.github
    └── /workflows (CI/CD)
```

> **Redesign (2026-06-26):** o site foi repaginado de "rose gold" para uma direção
> **editorial de luxo discreto** (creme quente + dourado de acento + quase-preto). É **responsivo**:
> mobile-first em coluna central de `max-width:464px` e, a partir de **≥1024px (desktop)**, layout
> full-width em colunas largas (ver Responsividade). Destaque: **comparador Antes & Depois arrastável**.
> A FAQ saiu da home e virou a página separada `faq.html` (que também concentra pagamentos e endereço).

- **HTML** → apenas marcações e estrutura do conteúdo.
- **TailwindCSS via CDN** → estilização aplicada via classes utilitárias e customizações inline quando necessário.
- **JavaScript inline** → funcionalidades interativas dentro do próprio `index.html` (funções simples no `<script>`).
- **/assets** → todas as imagens obrigatoriamente devem ser colocadas aqui.

---

## 🧭 Estrutura de Navegação
A nav (pills horizontais com scroll) contém:
- **Início** (`#inicio`)
- **Antes & Depois** (`#antes-depois`)
- **Procedimentos** (`#procedimentos`)
- **Sobre** (`#sobre`)
- **Contato** (`#contato`)
- **Dúvidas** → `faq.html` (página separada, não é âncora)

Os itens de âncora rolam para suas seções em `index.html`; "Dúvidas" abre `faq.html`.
A `faq.html` tem header próprio com link **← Início** de volta para `index.html#inicio`.

---

## 📱 Contato via WhatsApp (Regra Obrigatória)

### ⚠️ Configuração Centralizada
O número de WhatsApp e a mensagem padrão estão centralizados em um único ponto do código JavaScript para facilitar manutenção futura.

Localização: `index.html` e `faq.html` (seção `<script>`). **Manter os dois iguais.**
```javascript
const WHATSAPP_CONFIG = {
  number: "5511945575694",
  defaultMessage: "Olá! Gostaria de agendar uma avaliação.",
};

// Instagram também centralizado (só no index.html):
const INSTAGRAM_CONFIG = { handle: "dra.tatimayumi" };
```

**Regras:**
- **NUNCA** altere links de WhatsApp/Instagram manualmente no HTML
- **SEMPRE** altere apenas `WHATSAPP_CONFIG` / `INSTAGRAM_CONFIG`
- Os botões de WhatsApp usam `href="#"` como placeholder; `updateWhatsAppLinks()` os reescreve no `DOMContentLoaded`. Mensagem específica por botão via atributo `data-wa-message`.
- Instagram: `updateInstagramLinks()` reescreve `a[href*="instagram.com"]` e o label `[data-ig-label]`.
- Formato do link gerado: `https://wa.me/{number}?text={message}`

### Onde o WhatsApp aparece:
- Header (pill "Agendar")
- Hero (botão "Agendar pelo WhatsApp")
- Procedimentos (link "Agendar avaliação →" em cada card, com `data-wa-message` próprio)
- Contato (item "WhatsApp" + botão "Falar no WhatsApp")
- Barra fixa de CTA (rodapé mobile)
- `faq.html` (botão "Falar no WhatsApp")

### Onde o Instagram aparece (`@dra.tatimayumi`):
- Hero (botão "Instagram"), Contato (item Instagram) e barra fixa de CTA (ícone)

---

## 🎨 Identidade Visual (redesign 2026-06-26)

Direção: **editorial de luxo discreto** — creme quente, dourado como acento (nunca dominante),
quase-preto como tinta. Evitar voltar ao rosa antigo.

### Paleta de Cores (tokens CSS em `:root`)
- `--page-bg #e6dacb` (moldura) · `--surface #faf5ee` (coluna) · `--surface-2 #f3ebe0`
- `--ink #2a251f` (texto/fundos escuros) · `--ink-2 #221e19` (footer)
- `--gold #c2a35f` · `--gold-deep #a8884e` (acento sobre claro) · `--gold-light #e7c98a` (sobre escuro)
- `--text-muted #6f6457` · `--cream #f7f0e6` (texto sobre escuro)

### Tipografia
- **Títulos/display**: "Cormorant Garamond", serif (itálico para ênfase, ex.: *essência*)
- **Texto/UI**: "Manrope", sans-serif
- Ambas via Google Fonts. `eyebrow` = Manrope 600, 11px, `letter-spacing:.24em`, uppercase, gold-deep.

### Estilo
- O redesign usa **CSS próprio** (bloco `<style>` com os tokens acima + classes semânticas:
  `.page`, `.site-header`, `.hero`, `.trust`, `.cmp-*` (comparador), `.proc-card`, `.contato`,
  `.cta-bar`, etc.). As classes antigas `.rose-gold*`/`.soft-pink-bg` **não existem mais**.
- Tailwind CDN continua carregado por compatibilidade, mas o design é feito no CSS próprio.

---

## 🛠️ Tecnologias e Boas Práticas

### 🔹 HTML
- Usar estrutura semântica (`header`, `main`, `section`, `footer`)
- Manter organização por seções bem definidas
- Usar comentários HTML para demarcar seções principais
- IDs nas seções principais para navegação por âncoras

### 🔹 TailwindCSS
- **Incluído via CDN**: `https://cdn.tailwindcss.com`
- **Não criar arquivo CSS separado**, usar apenas classes utilitárias
- Customizações de estilo devem ser feitas via `<style>` inline no HTML
- Usar classes responsivas: `sm:`, `md:`, `lg:` para breakpoints
- Preferir classes do Tailwind sobre CSS customizado

### 🔹 JavaScript
- **Código inline** no próprio `index.html` dentro de `<script>`
- Manter funções simples e objetivas
- Usar `addEventListener` quando possível
- `onclick` inline é aceitável para casos muito simples (menu toggle)
- **Configurações globais** (como WhatsApp) devem estar em objetos no topo do script

### 🔹 Assets
- **Organização**:
  - Logo: `/assets/logo-bigger-no-text-transparent-removebg-preview.png`
  - Portfólio: `/assets/portfolio/labial-*.jpeg`
  - Imagens procedimentos: `/assets/portfolio/injetando.jpeg`
- Usar nomes descritivos e consistentes
- Preferir formatos otimizados (WebP, JPEG otimizado)

---

## 📋 Seções do Site

### `index.html`
1. **Header sticky** — logo "Dra. Tati Mayumi" + sub "Estética Avançada", pill "Agendar" (WhatsApp), nav de pills (`#inicio · #antes-depois · #procedimentos · #sobre · #contato · Dúvidas→faq.html`).
2. **Hero** (`#inicio`) — retrato full-bleed + overlay + H1 "Harmonia que respeita a sua *essência*" + botões WhatsApp e Instagram. *(imagem do hero é provisória — TODO: retrato real da Dra.)*
3. **Faixa de confiança** — 3 métricas: "10+ Anos de prática", "+2k Atendimentos" *(TODO: confirmar número real)*, "100% Personalizado".
4. **Antes & Depois** (`#antes-depois`) — **comparador arrastável** (peça central). Hoje só **Lábios** (par `assets/preenchimento-labial-{antes,depois}.jpeg`). A pill **Botox** está oculta até existir um par antes/depois real e alinhado.
5. **Procedimentos** (`#procedimentos`) — cards de Preenchimento Labial e Toxina Botulínica (Botox), cada um com link "Agendar avaliação →".
6. **Sobre** (`#sobre`) — retrato + bio + chips. *(sem CRM — a profissional não tem registro de conselho no material atual; se houver, re-adicionar.)*
7. **Contato** (`#contato`) — itens WhatsApp `(11) 94557-5694`, Instagram `@dra.tatimayumi`, Atendimento `Seg–Sex 9h–18h`; botão "Falar no WhatsApp" + link para `faq.html`.
8. **Footer** + **barra fixa de CTA** (WhatsApp + Instagram), respeitando `env(safe-area-inset-bottom)`.

### `faq.html` (página separada)
- **FAQ** (accordion): 7 perguntas de Botox + 8 de Preenchimento Labial (`FAQPage` JSON-LD aqui).
- **Formas de Pagamento**: crédito/débito (parcelamento), PIX, logos Visa/Mastercard.
- **Endereço**: Rua Catiguá, 159 - Tatuapé, SP, 03065-030 + link Google Maps.

> Os schemas JSON-LD ficam: `MedicalBusiness` no `index.html`, `FAQPage` no `faq.html`.

---

## 🔧 Funcionalidades Implementadas

### Comparador Antes & Depois (`index.html`)
- `initComparator()` — divisória arrastável via **Pointer Events** (mouse + toque, `touch-action:none`).
- Estado `pos` (clamp 2–98); aplica `clip-path: inset(0 0 0 {pos}%)` na camada DEPOIS e move a divisória. Estrutura data-driven (`[data-cmp-frame|after|divider]`) — basta adicionar o par de Botox para reativar a 2ª pill.

### WhatsApp / Instagram automáticos
- `updateWhatsAppLinks()` e `updateInstagramLinks()` no `DOMContentLoaded` (ver seção WhatsApp acima).

### FAQ accordion (`faq.html`)
- `toggleFAQ(btn)` — abre/fecha via `max-height` + `aria-expanded` (ícone "+" gira para "×").

### Responsividade
Site **responsivo num único documento** (mobile-first + um bloco `@media (min-width:1024px)` no `<style>`):
- **Mobile (<1024px)**: coluna central `max-width:464px`; header em 2 linhas (brand+pill, depois nav de pills com scroll); hero full-bleed com texto sobreposto; **barra fixa de CTA** no rodapé. Tablets (768–1023px) seguem o layout mobile.
- **Desktop (≥1024px)**: full-width, seções com inner `max-width:1100–1200px`. Header em **linha única** (brand · links inline · pill "Agendar"). **Hero 2 colunas** (texto sobre creme | imagem). Antes & Depois lado a lado (texto | comparador 460px). Procedimentos em **grid 2 col**; Sobre e Contato em 2 colunas (Contato com **card** à direita). Footer em linha. A barra fixa some e entra um **botão flutuante (FAB)** redondo de WhatsApp (`.fab`, canto inferior direito). Escala tipográfica maior (H1 62 / H2 46 / H3 30).
- Para servir os dois layouts no mesmo DOM há **wrappers** por seção (`.section__inner`, `.cmp__inner`, `.sobre__inner`, `.contato__inner`, `.footer__inner`) e o "Agendar" do header é **duplicado** (`.header-cta--top` mobile / `.header-cta--inline` desktop).
- `scroll-behavior:smooth` + `scroll-margin-top` nas seções (compensa o header sticky).
- `faq.html` é responsiva-lite: no desktop a coluna alarga para `max-width:820px`.

---

## 🚀 Deploy

O site tem **dois caminhos de publicação** (em transição do FTP para o Kubernetes):

### 1. FTP / Hostinger (legado — ainda ativo)
- Workflow `.github/workflows/deploy.yml`: faz `lftp mirror` do repositório para a Hostinger a cada push em `main`.
- Domínio de produção real: **dratatimayumi.com.br** (caminho FTP `domains/dratatimayumi.com.br/public_html/`).
- Mantido durante a migração; será desativado depois que o k8s estiver validado em produção.

### 2. Container + Kubernetes (homelab k3s — novo)
O site é conteinerizado (nginx servindo os arquivos estáticos) e publicado no homelab k3s
(repo `../homelab`). Domínio canônico: **dratatimayumi.com.br** (`.com` faz 301 → `.com.br`).

**Arquivos desta conteinerização (neste repo):**
- `Dockerfile` — nginx:stable-alpine, non-root (uid 101), porta 8080, `/healthz`.
- `nginx.conf` — gzip, cache (`expires`), headers de segurança e redirect `.com` → `.com.br`.
  - ⚠️ Headers de segurança ficam no nível do `server`. **Não** adicionar `add_header` dentro de
    um `location` (cancela a herança dos headers do server) — para cache use a diretiva `expires`.
- `.dockerignore` — exclui ~8MB de logos não usados e cruft do repo (não excluir `nginx.conf`).
- `.github/workflows/build-image.yml` — builda e publica a imagem no GHCR
  (`ghcr.io/<owner>/dratatimayumi-web`, tags `sha-<git-sha>` + `latest`) a cada push em `main`.

**Resources k8s** (ficam no repo `../homelab`, em `helm/apps/dratatimayumi/`):
`deployment.yml`, `service.yml` (`dratatimayumi-service:80` → container `:8080`), `ingress.yml`
(`.com.br`) e `ingress-com.yml` (`.com`). **Ambos os domínios estão no ar no k3s** (desde
2026-06-25): a zona `dratatimayumi.com` foi migrada para a Cloudflare, o cert TLS
`dratatimayumi-com-tls` foi emitido (DNS-01) e o `A` do `.com` aponta para o IP de casa via
favonia (`DOMAINS="dratatimayumi.com.br,dratatimayumi.com"`). O `.com` (+ `www`) faz 301 → `.com.br`
pelo nginx. Na zona `.com`, o `AAAA` legado foi removido e o `CNAME www` aponta para a raiz.

**Processo (rollout disparado da máquina local — o runner de nuvem não alcança o cluster privado):**
```
Push → GitHub Actions → build → push GHCR (sha + latest)
       → (máquina local) ansible-playbook deploy-app.yml -e app=dratatimayumi → rollout
```
- **Recomendado:** no repo `../homelab`, `ansible-playbook ansible/playbooks/deploy-app.yml -e app=dratatimayumi`
  (resolve o SHA do HEAD de `main`, espera a imagem no GHCR, faz `set image` + `rollout` + `/healthz`).
  Fixar versão/rollback: `-e image_tag=sha-<sha>`.
- **Fallback on-node:** `./scripts/deploy-dratatimayumi.sh sha-<sha>` (via SSH no node).

Detalhes e checklist completo: ver o plano em `~/.claude/plans/` e o `README.md` de `../homelab`.

> ⚠️ **Domínio nos arquivos de SEO:** `index.html` (og/twitter/canonical/JSON-LD), `robots.txt` e
> `sitemap.xml` usam **dratatimayumi.com.br** (canônico). Manter consistente ao editar.

---

## 🚫 Regras de Git

### ✅ O Claude PODE:
- Ler e analisar o repositório
- Sugerir mudanças
- Modificar arquivos localmente
- Executar `git status`, `git diff`, `git log`

### ❌ O Claude NÃO DEVE (a menos que explicitamente solicitado):
- **Fazer commits** sem permissão explícita do usuário
- Fazer push para repositório remoto
- Modificar configurações do Git
- Executar comandos destrutivos (`reset --hard`, `push --force`)

**Regra de Commits:**
- Apenas criar commits quando o usuário **explicitamente solicitar**
- Sempre mostrar `git status` e `git diff` antes de commitar
- Mensagens de commit devem ser claras e descritivas
- Incluir: `🤖 Generated with [Claude Code](https://claude.com/claude-code)`

---

## 📝 Padrões de Código

### HTML
- Indentação: 2 espaços
- Atributos entre aspas duplas
- Classes ordenadas: layout → espaçamento → cores → tipografia → efeitos

### JavaScript
- Constantes em UPPER_CASE (ex: `WHATSAPP_CONFIG`)
- Funções em camelCase (ex: `updateWhatsAppLinks`)
- Comentários descritivos para blocos lógicos
- Usar `const` por padrão, `let` quando necessário

### Comentários
```html
<!-- Seção Principal -->
<!-- Fim da Seção -->
```

```javascript
// Configuração centralizada do WhatsApp
// Atualiza todos os links de WhatsApp na página
```

---

## 🔄 Manutenção Futura

### Para alterar o número de WhatsApp:
```javascript
const WHATSAPP_CONFIG = {
  number: "5511945575694", // <-- alterar aqui
  defaultMessage: "Olá! Gostaria de agendar um horário.",
};
```

### Para adicionar novo serviço:
1. Copiar estrutura de card existente em `#servicos`
2. Alterar ícone, título, descrição e benefícios
3. Manter classes e estrutura HTML

### Para adicionar imagem ao portfólio:
1. Colocar imagem em `/assets/portfolio/`
2. Copiar estrutura `.before-after-card`
3. Atualizar `src`, `alt`, título e descrição

### Para alterar endereço:
1. Atualizar texto em `#contato`
2. Atualizar link do Google Maps

---

## ✔️ Objetivo Final

Garantir que o site mantenha:
- **Consistência visual** (paleta de cores, tipografia, espaçamentos)
- **Código limpo e organizado** (HTML semântico, classes Tailwind, JS modular)
- **Facilidade de manutenção** (configurações centralizadas, comentários claros)
- **Responsividade** (mobile-first, breakpoints bem definidos)
- **Performance** (CDN, imagens otimizadas, código mínimo)

---

## 📌 Notas Importantes

1. **Este é um site estático de página única (SPA)**
2. **Não há backend** - todo contato via WhatsApp
3. **Não há formulários** que enviem dados para servidor
4. **Foco em conversão** - CTAs estratégicos em todas as seções
5. **Identidade visual elegante** - editorial de luxo discreto (creme + dourado de acento + quase-preto), Cormorant Garamond + Manrope, mobile-first em coluna central
6. **Duas páginas**: `index.html` (home) e `faq.html` (dúvidas + pagamentos + endereço)

---

**Última atualização:** 2026-06-26

**Instrução Adicional:** Sempre que um novo pedido de mudança for feito, o Claude deve revisar e atualizar estas instruções, se necessário, para garantir que estejam sempre alinhadas com as expectativas do usuário e o estado atual do projeto.
