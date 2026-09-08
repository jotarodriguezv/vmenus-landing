# vmenus-landing

La página pública de **[vmenus.co](https://vmenus.co)** — cartas digitales por
código QR para restaurantes.

Un solo `index.html` servido por nginx: sin build, sin dependencias y sin
JavaScript. Se despliega en Dokploy con el `Dockerfile` de la raíz.

Vive aparte de [`vmenus-app`](https://github.com/jotarodriguezv/vmenus-app) —el
menú que ve el comensal— porque la raíz de aquel repositorio ya está ocupada por
la carta, y porque un cambio de texto en la landing no debe poder redesplegar el
contenedor que sirve las cartas de los restaurantes.

**Antes de tocar nada, leer [`CLAUDE.md`](CLAUDE.md):** ahí están el porqué de la
separación, las reglas para las imágenes y lo que hay que comprobar antes de dar
por buena una tanda de cambios.
