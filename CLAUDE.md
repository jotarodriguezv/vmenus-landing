# vmenus-landing

La página pública de **vmenus.co**. Un solo `index.html` servido por nginx: sin
build, sin dependencias, sin JavaScript. Lo que se escriba aquí tiene que
funcionar tal cual lo sirve nginx.

## Por qué vive aparte de `vmenus-app`

Se decidió el 08/09/2026 y conviene no deshacerlo sin leer esto.

`vmenus-app` sirve las cartas de los restaurantes, y su `nginx.conf` es el
archivo con más cicatrices de toda la plataforma: la rama por `User-Agent` que
manda a los robots al panel para la vista previa al compartir, la regex de
`tv.html` que tiene que ir **antes** de `location /`, y sobre todo:

```
try_files $uri $uri/ /index.html;
```

Eso es lo que hace que `menu.vmenus.co/bonzas` encuentre su carta: cualquier
ruta que no sea un archivo cae en `index.html`. **La raíz de ese repositorio ya
está ocupada por el menú**, así que meter aquí la landing obligaría a decidir
por `$host` dentro de ese mismo bloque.

Y hay una razón mejor: **el radio de impacto**. Cambiar una frase de marketing
no puede tumbar las cartas de nueve restaurantes un viernes por la noche. Son
dos cosas con ritmos distintos —esta se toca cada semana, aquella cuando cambia
el producto— y no comparten una línea de código.

## Estructura

- `index.html` — la página entera, con su CSS dentro.
- `imagenes/` — ver abajo.
- `Dockerfile` / `nginx.conf` — el despliegue. Leer sus comentarios antes de
  tocarlos: los dos llevan lecciones que costaron un incidente en `vmenus-app`.

## La paleta no se inventa

Los colores y las tipografías son **los del producto**: el mismo verde menta
sobre casi negro que usan el panel y las cartas, con su variante clara. Están
copiados como variables CSS al principio de `index.html`.

Es una copia a conciencia —dos aplicaciones desplegadas por separado no pueden
compartir un archivo— pero si allí cambia la paleta, aquí hay que cambiarla. Lo
que no puede pasar es que la landing prometa un aspecto y el cliente entre a un
panel que se ve de otra forma.

## Imágenes y multimedia

**Van en este repositorio, en `imagenes/`.** No en el `uploads/` del panel, y
esto último importa: `limpieza.js` borra de ahí lo que no referencia ninguna de
las tablas que conoce, y una imagen de la landing es huérfana por definición.
Acabaría borrada, y con siete días de retraso para que nadie ate cabos.

Guardarlas aquí tiene una ventaja que no es obvia: **la imagen y la página se
versionan juntas**. Un `git revert` devuelve las dos a la vez. Con las imágenes
en otro sitio, volver atrás deja la página vieja pidiendo una imagen que ya
cambió.

Tres reglas:

1. **Versión en el nombre**: `carta-movil-v2.webp`, no `carta-movil.webp`. Es
   lo que permite cachearlas un año (`nginx.conf` lo explica). Cambiar una
   imagen es **subirla con otro nombre**, no reemplazarla.
2. **Optimizar ANTES de commitear.** Git guarda para siempre cada versión de un
   binario: una foto de 4 MB sustituida tres veces son 12 MB en el repositorio
   para siempre. WebP, y por debajo de 200 KB salvo que haya un motivo.
3. **Siempre con `width`, `height` y `loading="lazy"`** (esto último solo en las
   que no se ven al abrir). Sin las medidas, la página da un salto al cargar.

Si algún día hay video, **no va aquí**: un MP4 en git es justo lo que la regla 2
prohíbe. Ese día se sube a `uploads/` del panel a mano y se enlaza, o se pone en
Backblaze, que ya está contratado para los respaldos.

## Antes de publicar

`index.html` trae una franja naranja arriba (`.borrador`) que avisa de lo que
falta. **Se borra ese `<div>` entero** cuando estén:

- el número de WhatsApp real en los dos botones (hoy `wa.me/57XXXXXXXXXX`);
- la decisión sobre los precios de los planes.

## Comprobar antes de dar por buena una tanda de cambios

No hay pruebas automáticas: es un archivo estático. Lo que sí hay que mirar:

- que se vea bien **en móvil**, que es por donde va a entrar casi todo el mundo;
- que se vea bien en **vista clara y oscura** (la página respeta la del sistema);
- que los enlaces a WhatsApp y a la carta de ejemplo abran de verdad.
