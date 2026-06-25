# syntax=docker/dockerfile:1
FROM nginx:stable-alpine

# Config customizada: gzip, cache, security headers, /healthz, redirect .com -> .com.br
COPY nginx.conf /etc/nginx/nginx.conf

# Site estático. O .dockerignore exclui ~8MB de logos não usados e cruft do repo.
COPY --chown=nginx:nginx index.html favicon.ico robots.txt sitemap.xml /usr/share/nginx/html/
COPY --chown=nginx:nginx js/     /usr/share/nginx/html/js/
COPY --chown=nginx:nginx assets/ /usr/share/nginx/html/assets/

# Non-root: a imagem nginx:alpine traz o usuário "nginx" (uid 101).
RUN mkdir -p /var/cache/nginx /var/run \
 && chown -R nginx:nginx /var/cache/nginx /var/run /usr/share/nginx/html \
 && touch /var/run/nginx.pid && chown nginx:nginx /var/run/nginx.pid

USER nginx
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
CMD ["nginx", "-g", "daemon off;"]
