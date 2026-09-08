FROM nginx:alpine

COPY . /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Lo que no es la página, fuera de la raíz web.
#
# El COPY de arriba se lleva el repositorio ENTERO, y esa carpeta se sirve tal
# cual: sin esta línea quedarían públicos https://vmenus.co/nginx.conf,
# /Dockerfile y /CLAUDE.md. Hoy ninguno guarda un secreto, pero lo que se
# añada mañana a cualquiera de ellos se serviría igual sin que nadie lo note.
#
# No se resuelve con .dockerignore: excluir nginx.conf de ahí lo saca del
# contexto entero y el COPY a conf.d/ falla. El sitio correcto es aquí, una vez
# ya está donde hace falta. (Es la misma lección que vmenus-app aprendió con su
# nginx.conf, aplicada de entrada al resto de archivos.)
RUN rm -f /usr/share/nginx/html/nginx.conf \
          /usr/share/nginx/html/Dockerfile \
          /usr/share/nginx/html/CLAUDE.md \
          /usr/share/nginx/html/imagenes/LEEME.md

EXPOSE 80

# Pide el index.html de verdad y no solo el puerto.
#
# Para Docker el contenedor está sano mientras nginx no muera, pero nginx vivo
# no significa página servida: si el COPY se hubiera hecho sobre una carpeta
# vacía, o un volumen tapara la raíz web, el proceso seguiría aceptando
# conexiones y devolvería 404 a todo el mundo. Desde fuera eso se ve como una
# página en blanco y nadie se entera.
#
# wget viene con busybox en la imagen alpine, así que no hace falta curl.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1/index.html > /dev/null || exit 1
