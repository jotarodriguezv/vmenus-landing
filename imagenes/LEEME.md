# imagenes/

Aquí van las imágenes de la landing. Las reglas completas están en el
`CLAUDE.md` de la raíz; el resumen:

- **Versión en el nombre**: `carta-movil-v2.webp`. Cambiar una imagen es subirla
  con otro nombre, no reemplazarla — es lo que permite cachearlas un año.
- **Optimizar antes de commitear**: WebP, por debajo de 200 KB. Git guarda para
  siempre cada versión de un binario.
- **`width`, `height` y `loading="lazy"`** en el `<img>`, o la página pega un
  salto al cargar.

Este archivo existe para que git pueda guardar la carpeta vacía, y el
`Dockerfile` lo borra de la raíz web al construir.
