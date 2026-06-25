# Site de Estética Avançada

Este projeto visa a criação do site da Dra Tati Mayumi - Estética Avançada, seguindo diretrizes específicas de estrutura, tecnologias e boas práticas de desenvolvimento.

## 🚀 Tecnologias Utilizadas

-   **HTML5**: Para a estrutura e marcação semântica do conteúdo.
-   **Tailwind CSS v4.0**: Para estilização, utilizando classes utilitárias e evitando CSS manual.
-   **JavaScript**: Para funcionalidades interativas e comportamentos visuais.

## 🧱 Estrutura do Projeto

A organização dos arquivos e diretórios segue o padrão:

```
/
├── index.html
├── /assets
│   ├── imagens do site (JPG, PNG, SVG, WebP)
├── /js
│   └── main.js (scripts de interação)
```

-   **`index.html`**: Página principal do site.
-   **`/assets`**: Contém todas as imagens do site.
-   **`/css/styles.css`**: Arquivo CSS gerado pelo Tailwind CSS.
-   **`/js/main.js`**: Contém todo o código JavaScript para interatividade.

## 🧭 Navegação

O site inclui os seguintes itens de menu, que devem direcionar para seções específicas na `index.html` via âncoras internas:

-   Início
-   Serviços
-   Portfólio
-   Sobre
-   Contato

## 📱 Contato via WhatsApp

Todos os links e botões de contato devem direcionar para o WhatsApp, utilizando o formato:

```
https://wa.me/SEU_NUMERO?text=MENSAGEM_PADRAO
```

O número deve estar no formato internacional, sem espaços ou símbolos.

## 🛠️ Boas Práticas e Desenvolvimento

### HTML

-   Uso de estrutura semântica (`header`, `main`, `section`, `footer`).
-   Evitar estilos inline.
-   Componentização por seções.

### Tailwind CSS

-   Estilização exclusiva com classes utilitárias.
-   O Tailwind CSS será incluído via CDN diretamente no `index.html`, não sendo necessário um processo de build ou geração de CSS.
-   Configuração via `tailwind.config.js` quando necessário (para customizações específicas, mas não para geração do CSS principal).



### JavaScript

-   Funções no arquivo `/js/main.js`.
-   Separação completa de responsabilidades (sem lógica JS no HTML).
-   Uso de `addEventListener`.

### Assets

-   Todas as imagens em `/assets`.
-   Nomes de arquivos descritivos.

## 🔧 Funcionalidades Esperadas

O site pode incluir funcionalidades como:

-   Menu mobile responsivo.
-   Sliders/carrosséis.
-   Animações simples.
-   Formulário de contato que abre o WhatsApp.
-   Galeria de portfólio.

## 🚀 Publicação (Deploy)

O site é **conteinerizado** (nginx servindo os arquivos estáticos) e publicado no **homelab k3s**
(repo `../homelab`). Os domínios **dratatimayumi.com.br** (canônico) e **dratatimayumi.com**
(301 → `.com.br`) estão no ar pelo cluster, com TLS Let's Encrypt via cert-manager.

> O deploy antigo via **SFTP/Hostinger** (`.github/workflows/deploy.yml`) está **legado** — o
> gatilho automático foi desativado (só execução manual) e será removido após o decomissionamento
> da Hostinger. O fluxo atual é o de container + k3s descrito abaixo.

### Fluxo atual (container + GHCR + k3s)

1. **Build da imagem (CI):** a cada push em `main`, o workflow `.github/workflows/build-image.yml`
   builda e publica a imagem no GHCR — `ghcr.io/thiagotn/dratatimayumi-web` (package público),
   tags `sha-<git-sha>` + `latest`.
2. **Rollout (manual, da máquina local):** o runner de nuvem **não alcança o cluster privado**,
   então o rollout é disparado de fora. No repo `../homelab`:
   ```bash
   ansible-playbook ansible/playbooks/deploy-app.yml -e app=dratatimayumi          # última versão de main
   ansible-playbook ansible/playbooks/deploy-app.yml -e app=dratatimayumi -e image_tag=sha-<sha>   # versão fixa / rollback
   ```
   Fallback on-node (via SSH): `./scripts/deploy-dratatimayumi.sh sha-<git-sha>`.

### Arquivos da conteinerização (neste repo)

-   **`Dockerfile`** — `nginx:stable-alpine`, non-root (uid 101), porta 8080, `/healthz`.
-   **`nginx.conf`** — gzip, cache (`expires`), headers de segurança e redirect `.com → .com.br`.
-   **`.dockerignore`** — exclui assets não usados e cruft do repo.
-   **`.github/workflows/build-image.yml`** — build + push da imagem no GHCR.

Os manifests k8s (`deployment.yml`, `service.yml`, `ingress.yml`, `ingress-com.yml`) ficam no repo
`../homelab` em `helm/apps/dratatimayumi/`. Detalhes completos: `.claude/CLAUDE.md` (seção Deploy)
e o `README.md` do homelab.
