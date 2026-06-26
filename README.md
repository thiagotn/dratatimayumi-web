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

### Fluxo atual (GitOps: container + GHCR + Argo CD)

Deploy é **automático por `git push`** — não há mais passo manual no fluxo normal. A cada push em
`main`, o workflow `.github/workflows/build-image.yml` roda dois jobs:

1. **`build-push`:** builda e publica a imagem no GHCR — `ghcr.io/thiagotn/dratatimayumi-web`
   (package público), tags `sha-<git-sha>` + `latest`.
2. **`bump-homelab-tag`:** faz checkout do repo `homelab` (privado, via deploy key SSH em
   `secrets.HOMELAB_DEPLOY_KEY`) e atualiza a tag da imagem no `kustomization.yaml` do homelab,
   com `git push`. O **Argo CD** no cluster detecta o commit e faz o rollout sozinho.

   > O cluster é **read-only** para o CI (não recebe `kubectl`/SSH daqui); o que entra é só um
   > commit no repo de infra. A credencial de escrita vive nos *secrets* do GitHub Actions, não no cluster.

**Acompanhar / rollback** (no repo `../homelab`, na LAN): `kubectl -n argocd get app dratatimayumi`
(quer `Synced`/`Healthy`). Rollback = apontar o `newTag` para um sha anterior e `git push`.

**Fallback manual** (Argo indisponível): `ansible-playbook ansible/playbooks/deploy-app.yml -e app=dratatimayumi`
no `../homelab`, ou on-node `./scripts/deploy-dratatimayumi.sh sha-<git-sha>`. ⚠️ Com o `selfHeal`
do Argo ligado, um rollout manual é revertido se a tag não estiver no `kustomization.yaml`.

### Arquivos da conteinerização (neste repo)

-   **`Dockerfile`** — `nginx:stable-alpine`, non-root (uid 101), porta 8080, `/healthz`.
-   **`nginx.conf`** — gzip, cache (`expires`), headers de segurança e redirect `.com → .com.br`.
-   **`.dockerignore`** — exclui assets não usados e cruft do repo.
-   **`.github/workflows/build-image.yml`** — build + push da imagem no GHCR **e** write-back da tag
    no repo `homelab` (GitOps via Argo CD).

Os manifests k8s (`deployment.yml`, `service.yml`, `ingress.yml`, `ingress-com.yml`) ficam no repo
`../homelab` em `helm/apps/dratatimayumi/`. Detalhes completos: `.claude/CLAUDE.md` (seção Deploy)
e o `README.md` do homelab.
