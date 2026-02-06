# Glosario Tecnico para No-Programadores

Guia de conceptos clave explicados de forma simple. Si nunca has programado, este documento es para ti.

---

## Lo basico

### Codigo
Son las instrucciones que le das a una computadora para que haga algo. Es como una receta de cocina: le dices paso a paso que hacer y la computadora lo sigue al pie de la letra.

### Programar
Escribir esas instrucciones (codigo). No necesitas ser genio, solo saber explicarle a la computadora que quieres que haga, como si le explicaras a alguien muy literal que nunca asume nada.

### Bug
Un error en el codigo. Le dijiste a la computadora que hiciera algo, pero te equivocaste en una instruccion y ahora hace algo raro. Como cuando escribes mal una direccion en el GPS y te lleva a otro lado.

### Debug
Buscar y arreglar bugs. Como ser detective: "por que la app muestra el precio mal?" y vas revisando instruccion por instruccion hasta encontrar donde esta el error.

---

## Donde vive el codigo

### Frontend
Todo lo que el usuario **ve y toca**: botones, colores, textos, imagenes, formularios. Es la "cara" de la aplicacion. Cuando abres la app de MV y ves el menu del dia, eso es frontend.

### Backend
Todo lo que pasa **detras de escena** que el usuario no ve: calcular precios, guardar pedidos, verificar si hay cobertura. Es como la cocina de un restaurante, el cliente no la ve pero ahi se prepara todo.

### Base de datos (BD)
Es donde se **guardan todos los datos**: usuarios, pedidos, comidas, direcciones. Imagina un Excel gigante con muchas hojas y millones de filas donde se guarda toda la informacion de MV.

### Tabla (de base de datos)
Cada "hoja" de ese Excel gigante. Hay una tabla de usuarios, otra de pedidos, otra de comidas, etc. Cada tabla tiene columnas (nombre, email, fecha) y filas (cada usuario, cada pedido).

### Query (consulta SQL)
Es la pregunta que le haces a la base de datos. Por ejemplo: "dame todos los pedidos de hoy en Peru". Se escribe en un lenguaje especial llamado SQL que la base de datos entiende.

### Servidor
Una computadora que esta prendida 24/7 en algun lugar del mundo y responde cuando alguien abre la app o la web. Cuando abres manzanaverde.com, tu computadora le pide informacion a un servidor y el servidor responde.

---

## Como se comunican las cosas

### API (Application Programming Interface)
Es como un **mesero en un restaurante**. Tu (la app) le pides algo al mesero (la API), el mesero va a la cocina (el servidor), trae lo que pediste y te lo entrega. No necesitas saber como funciona la cocina, solo sabes que si pides "menu del dia", te lo traen.

Ejemplo: la app de MV le pide a la API "dame las comidas de hoy en Lima" y la API responde con la lista de comidas.

### Endpoint
Es cada **plato especifico** que puedes pedir al mesero. Un endpoint es una direccion especifica de la API. Por ejemplo:

- `/api/comidas` - pedirle la lista de comidas
- `/api/cobertura` - preguntarle si hay delivery en tu zona
- `/api/pedidos` - ver tus pedidos

Cada endpoint hace una cosa especifica.

### Request (solicitud)
Es lo que **tu le pides** a la API. "Quiero ver el menu de hoy". Puede ser:
- **GET** = "dame informacion" (ver el menu)
- **POST** = "crea algo nuevo" (hacer un pedido)
- **PATCH** = "actualiza algo" (cambiar direccion de entrega)
- **DELETE** = "borra algo" (cancelar un pedido)

### Response (respuesta)
Es lo que **la API te devuelve** despues de tu solicitud. Puede ser los datos que pediste o un mensaje de error si algo salio mal.

### JSON (JavaScript Object Notation)
Es el **formato** en el que la API te responde. Es como un formulario organizado que la computadora puede leer facilmente. Se ve asi:

```json
{
  "nombre": "Ensalada Mediterranea",
  "calorias": 350,
  "precio": 25.90,
  "disponible": true
}
```

Siempre tiene pares de "nombre": "valor", separados por comas, dentro de llaves `{ }`. Es el idioma universal en el que las APIs se comunican.

### Token
Una **llave digital** que demuestra que tienes permiso para acceder a algo. Como la tarjeta de un hotel: sin ella no puedes entrar a tu cuarto. Cuando inicias sesion, el sistema te da un token y cada vez que pides algo, lo muestras para demostrar que eres tu.

### Autenticacion
El proceso de **verificar que eres quien dices ser**. Es el momento en que muestras tu tarjeta/llave (token) para que el sistema te deje pasar.

---

## Formatos y datos

### String (cadena de texto)
Cualquier texto entre comillas: `"Hola mundo"`, `"Lima"`, `"juan@email.com"`. Si tiene comillas, es un string.

### Number (numero)
Un numero sin comillas: `42`, `25.90`, `0`. Se puede usar para hacer matematicas.

### Boolean (verdadero/falso)
Solo puede ser `true` (verdadero) o `false` (falso). Sirve para preguntas de si/no. Por ejemplo: `"disponible": true` significa que si esta disponible.

### Array (lista)
Una lista ordenada de cosas entre corchetes `[ ]`:

```json
["Desayuno", "Almuerzo", "Cena", "Snack"]
```

Es como una lista de supermercado pero para la computadora.

### Objeto
Un grupo de datos relacionados entre llaves `{ }`. Como una ficha con toda la informacion de algo:

```json
{
  "nombre": "Maria Garcia",
  "email": "maria@email.com",
  "pais": "Peru"
}
```

### null
Significa **"no hay nada"**. No es cero, no es vacio, es "este dato no existe". Como cuando un formulario tiene un campo opcional que nadie lleno.

### Variable
Una **cajita con nombre** donde guardas un dato para usarlo despues. Si dices `precio = 25.90`, creaste una cajita llamada "precio" con el valor 25.90 adentro. Puedes usar esa cajita despues en vez de escribir 25.90 cada vez.

---

## Herramientas

### Git
Un sistema que **guarda versiones de tu codigo**, como el historial de versiones de Google Docs. Si algo se rompe, puedes volver a una version anterior. Tambien permite que varias personas trabajen en el mismo proyecto sin pisarse.

### Branch (rama)
Una **copia paralela** del proyecto donde puedes hacer cambios sin afectar el original. Es como hacer una copia de un documento para editarla tranquilo, y cuando estas seguro de los cambios, los juntas con el original.

### Commit
Un **punto de guardado** en Git. Como cuando guardas una partida en un videojuego. Puedes volver a ese punto en cualquier momento. Cada commit tiene un mensaje que dice que cambiaste, por ejemplo: "Agregue el boton de cobertura".

### Push
**Subir tus cambios** al servidor de Git (GitHub) para que los demas los vean. Es como subir tu documento editado a Google Drive para que el equipo pueda verlo.

### Pull Request (PR)
Una **solicitud para unir tus cambios** con el proyecto principal. Es como decir "hice estos cambios en mi copia, alguien los puede revisar antes de que los juntemos con el original?". Alguien del equipo lo revisa, y si todo esta bien, lo aprueba.

### GitHub
La **plataforma donde vive el codigo**. Es como Google Drive pero para codigo. Ahi se guardan todos los proyectos, se revisan cambios y se colabora en equipo.

### Repositorio (repo)
Una **carpeta de proyecto** en GitHub. Cada proyecto de MV tiene su propio repositorio: uno para la web, otro para el admin, otro para la landing, etc.

---

## Desarrollo web

### HTML
El **esqueleto** de una pagina web. Define la estructura: aqui va un titulo, aqui un parrafo, aqui una imagen, aqui un boton. Sin estilo, sin colores, solo estructura.

### CSS
La **ropa y el maquillaje** de la pagina. Define como se ve: colores, tamanios, posiciones, fuentes, espacios. HTML dice "hay un boton", CSS dice "el boton es verde, redondo y grande".

### JavaScript (JS)
El **cerebro** de la pagina. Hace que las cosas sean interactivas: cuando haces click en un boton pasa algo, cuando escribes en un campo se valida, cuando scrolleas se carga mas contenido.

### TypeScript (TS)
JavaScript pero con **reglas mas estrictas**. Es como JavaScript con corrector ortografico: te avisa si te equivocas antes de que sea demasiado tarde. MV usa TypeScript en todos sus proyectos.

### React
Una herramienta que facilita construir interfaces (lo que el usuario ve). En vez de construir toda la pagina de una vez, la divides en piezas pequenas llamadas **componentes** que puedes reutilizar.

### Componente
Una **pieza reutilizable** de la interfaz. Un boton es un componente, una tarjeta de comida es un componente, el menu de navegacion es un componente. Los armas una vez y los usas en muchos lugares.

### Next.js
El **framework** (herramienta principal) que usa MV para construir sus paginas web. Es como React pero con superpoderes: maneja las paginas, la navegacion, el rendimiento y mas.

### Tailwind CSS
Una forma rapida de escribir estilos (CSS). En vez de crear archivos de estilos separados, escribes las instrucciones de estilo directamente en el componente. Por ejemplo: `bg-green-500 text-white rounded-xl` = fondo verde, texto blanco, bordes redondeados.

---

## Conceptos de MV

### Design Tokens
Los **colores, fuentes y medidas oficiales** de Manzana Verde. Estan definidos una sola vez y todo el equipo los usa. Asi todo se ve consistente. Ejemplo: el verde principal de MV es `#227A4B`, y en vez de recordar ese codigo, usamos `mv-green-500`.

### Staging
Un **ambiente de prueba** identico al real pero donde no hay clientes de verdad. Es como el ensayo general antes de una obra de teatro. Probamos todo ahi antes de que lo vean los usuarios reales.

### Produccion
El **ambiente real** donde estan los usuarios de verdad. Cuando algo esta "en produccion", significa que los clientes ya lo estan usando. Por eso hay que tener mucho cuidado antes de subir cambios ahi.

### Deploy (despliegue)
El proceso de **publicar cambios** para que los usuarios los vean. "Deployar a produccion" = hacer que el cambio este disponible para todos. "Deployar a staging" = subirlo al ambiente de prueba.

### Environment Variables (variables de entorno)
**Datos secretos** (como contrasenas, tokens, URLs de servidores) que se guardan fuera del codigo. Es como tener las llaves de tu casa en tu bolsillo y no pegadas en la puerta. Nunca se suben a GitHub.

### MCP Server
Un **puente** que conecta a Claude Code con servicios externos (Notion, Supabase, bases de datos). Permite que Claude pueda leer documentacion, consultar datos y crear cosas en otros sistemas sin que tu tengas que hacerlo manualmente.

---

## Terminos que vas a escuchar seguido

| Termino | Traduccion simple |
|---------|-------------------|
| Deployar | Publicar cambios |
| Mergear | Unir una rama con otra |
| Commitear | Guardar un punto de control en Git |
| Pushear | Subir cambios al servidor |
| Fetchear | Ir a buscar datos de algun lado |
| Parsear | Leer datos y convertirlos a un formato que entiendas |
| Renderizar | Dibujar/mostrar algo en pantalla |
| Debuguear | Buscar y arreglar errores |
| Refactorizar | Reescribir codigo para que quede mejor sin cambiar lo que hace |
| Hardcodear | Escribir un valor fijo directamente en vez de usar una variable |
| Responsive | Que se adapta a distintos tamanios de pantalla (celular, tablet, PC) |
| Scaffold | Generar la estructura base de algo automaticamente |

---

## IA y desarrollo con asistentes

### Inteligencia Artificial (IA)
Un programa que puede **aprender patrones y tomar decisiones** sin que le digas exactamente que hacer en cada caso. En vez de seguir instrucciones rigidas, la IA entiende contexto, interpreta lo que le pides y genera respuestas. Claude es una IA que entiende lenguaje natural y puede escribir codigo.

### LLM (Large Language Model)
El tipo de IA que esta detras de Claude, ChatGPT, etc. Es un modelo entrenado con millones de textos que aprendio a **entender y generar lenguaje**. "Large" porque es enorme (billones de parametros). Lo importante: entiende lo que le dices en espanol y puede responder con codigo, explicaciones o lo que necesites.

### Prompt
Es lo que **tu le escribes a la IA**. Tu instruccion, tu pregunta, tu pedido. "Crea una landing page con un formulario de cobertura" es un prompt. Mientras mas claro y especifico sea tu prompt, mejor resultado vas a obtener. Es como darle instrucciones a alguien: si eres vago, el resultado sera vago.

**Tips para buenos prompts:**
- Se especifico: "Agrega un boton verde que diga Verificar Cobertura" en vez de "agrega un boton"
- Da contexto: "En la pagina de cobertura, debajo del formulario..."
- Di que quieres lograr: "Quiero que el usuario pueda ver si tiene delivery en su zona"

### Contexto
La **informacion que la IA tiene disponible** para responder. Cuando Claude Code lee tu proyecto, los archivos, el CLAUDE.md, los skills del plugin, todo eso es contexto. Mientras mas contexto relevante tenga, mejores respuestas da. Es como explicarle a alguien nuevo en la empresa que hacemos, como trabajamos y que herramientas usamos antes de pedirle que haga algo.

### Vibe Coding
Programar con IA de forma **conversacional y relajada**. En vez de escribir codigo linea por linea, le describes a la IA lo que quieres y ella genera el codigo por ti. Tu rol pasa de "escribir codigo" a "dirigir y validar". Es como ser el director de una pelicula: no actuas, pero decides que se hace y como.

Ejemplo de vibe coding:
```
Tu: "Quiero una pagina donde el usuario ponga su direccion y le diga si tiene cobertura"
Claude: *genera toda la pagina con formulario, validacion, llamada a la API, estilos*
Tu: "Ahora agrega que si no tiene cobertura pueda dejar su email"
Claude: *agrega el formulario de waitlist*
```

### Claude Code
La herramienta de **IA para programar** que estas usando. Es Claude (la IA de Anthropic) pero especializado en escribir codigo. Puede leer tu proyecto, crear archivos, ejecutar comandos, conectarse a servicios (Notion, Supabase) y mas. Es como tener un programador senior disponible 24/7 que conoce los estandares de MV.

### Skill (habilidad)
Un **comando predefinido** que le dice a Claude Code exactamente como hacer algo. Cada skill tiene instrucciones detalladas para que Claude siga los estandares de MV. Es como una receta que Claude sigue paso a paso. Ejemplo: `/mv-dev:start-project` le dice exactamente como crear un proyecto nuevo con toda la configuracion correcta.

### Agente (Agent)
Un **modo especializado** de Claude Code que sabe hacer un tipo de tarea especifico. El QA Agent sabe de testing, el Frontend Agent sabe de diseno, el Backend Agent sabe de APIs. Es como tener diferentes especialistas en el equipo: no le pides al disenador que haga las queries de base de datos.

### Plugin
Un **paquete de funcionalidades** que se le instala a Claude Code para que sepa mas cosas. El plugin `mv-dev` le ensena a Claude todo sobre Manzana Verde: como creamos proyectos, que estandares usamos, donde esta la documentacion, etc. Sin el plugin, Claude es generico. Con el plugin, Claude es un experto en MV.

### MCP (Model Context Protocol)
El **protocolo de comunicacion** que permite a Claude Code conectarse con servicios externos. Es como el idioma que habla Claude para comunicarse con Notion, Supabase, bases de datos, etc. Tu no necesitas saber como funciona, solo saber que gracias a MCP, Claude puede hacer cosas como leer tu documentacion de Notion o consultar la base de datos.

### Token (de IA)
No confundir con el token de autenticacion. En el contexto de IA, un token es un **pedacito de texto** (puede ser una palabra, parte de una palabra, o un signo). La IA procesa texto en tokens. Esto importa porque los modelos tienen un limite de tokens que pueden leer/generar por conversacion. Si una conversacion se hace muy larga, Claude puede "olvidar" lo del principio.

### Alucinacion
Cuando la IA **inventa informacion que parece real pero no lo es**. Como cuando alguien responde con mucha confianza algo que no sabe. Por eso es importante validar lo que Claude dice, especialmente nombres de APIs, campos de tablas o URLs. El plugin de MV reduce alucinaciones porque le da a Claude informacion real de Notion y la base de datos en vez de dejarlo adivinar.

### Iteracion
Hacer algo, **ver el resultado, ajustar y repetir**. En vibe coding no necesitas que el primer intento sea perfecto. Le pides algo a Claude, ves como quedo, le pides ajustes, y asi vas refinando. Cada vuelta es una iteracion. Es normal hacer 3-5 iteraciones hasta que algo quede como quieres.

---

## Terminos de IA que vas a escuchar

| Termino | Traduccion simple |
|---------|-------------------|
| Prompt | Lo que le escribes/pides a la IA |
| Promptear | Escribir instrucciones para la IA |
| Contexto | La informacion que la IA tiene para trabajar |
| Vibe coding | Programar conversando con la IA |
| Alucinacion | Cuando la IA inventa cosas |
| Iterar | Pedir → ver resultado → ajustar → repetir |
| Fine-tuning | Entrenar una IA para que sea experta en algo especifico |
| RAG | Darle a la IA documentos reales para que no invente (lo que hace mv-docs) |
| Copilot | Una IA que te asiste mientras trabajas (Claude Code es un copilot) |
| No-code / Low-code | Crear software sin escribir (o escribiendo poco) codigo |

---

## El flujo simplificado de MV

```
1. Tienes una idea
       ↓
2. /mv-dev:discovery → Claude te dice que APIs y datos ya existen
       ↓
3. /mv-dev:start-project → Claude crea el proyecto con todo configurado
       ↓
4. /mv-dev:new-feature → Claude crea las piezas de la funcionalidad
       ↓
5. Pruebas en staging → Verificas que todo funcione
       ↓
6. /mv-dev:deploy-staging → Claude sube los cambios a staging
       ↓
7. Code review → Alguien del equipo revisa
       ↓
8. Deploy a produccion → Los usuarios lo ven
```

No necesitas saber programar para entender este flujo. Claude se encarga del codigo, tu te encargas de la idea y la validacion.
