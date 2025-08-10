#!/bin/bash
set -e

# Generar Dockerfile "al estilo del word", pero sin RUN (evita el error seccomp)
echo 'FROM httpd:2.4' > Dockerfile
echo 'COPY index.html /usr/local/apache2/htdocs/index.html' >> Dockerfile
echo 'EXPOSE 80' >> Dockerfile
echo 'CMD ["httpd-foreground"]' >> Dockerfile

# Build y run con el mismo nombre de imagen/contenedor que usas: web2
docker rm -f web2 >/dev/null 2>&1 || true
docker build -t web2 .
docker run -t -d -p 8888:80 --name web2 --security-opt seccomp=unconfined web2
docker ps -a

# Verificación rápida (sirve para Jenkins también)
echo "Comprobando http://localhost:8888 ..."
sleep 2
curl -sSf http://localhost:8888 | head -n 5 && echo "OK: página disponible en 8888"
