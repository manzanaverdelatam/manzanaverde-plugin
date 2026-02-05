# Guia de Configuracion - Plugin MV Dev

Esta guia explica paso a paso como configurar los tokens necesarios para que todos los MCP servers del plugin funcionen correctamente.

---

## Requisitos previos

- **Node.js 18+** instalado
- **Claude Code** instalado y configurado
- Acceso a las cuentas de los servicios (te los da el Tech Lead)

---

## 1. Context7 (Documentacion de librerias)

Context7 trae documentacion actualizada de cualquier libreria directo al contexto de Claude. Funciona sin API key pero con rate limits bajos. Con API key es gratuito y sin limites practicos.

### Paso a paso

1. Ir a **https://context7.com/dashboard**
2. Crear cuenta gratuita (puedes usar GitHub o Google)
3. En el dashboard, click en **"Create API Key"**
4. Copiar el API key (formato: `ctx7sk-...`)
5. Agregar a tu shell profile:

```bash
# Agregar al final de ~/.zshrc (Mac) o ~/.bashrc (Linux)
export CONTEXT7_API_KEY="ctx7sk-tu-api-key-aqui"
```

6. Recargar el terminal:

```bash
source ~/.zshrc
```

**Verificar:** `echo $CONTEXT7_API_KEY` debe mostrar tu key.

---

## 2. Notion (Documentacion de proyectos)

Notion se usa como **hub central de documentacion**. Cada proyecto de MV tiene su propia pagina en Notion, identificada por el link de GitHub. Esto permite que multiples personas trabajen en el mismo proyecto y cualquiera pueda retomarlo leyendo la doc.

Claude necesita permisos de **lectura y escritura** para crear y actualizar la documentacion automaticamente.

### Paso a paso

1. Ir a **https://www.notion.so/my-integrations**
2. Click en **"New integration"**
3. Configurar:
   - **Name:** `MV Claude Code`
   - **Associated workspace:** Seleccionar el workspace de Manzana Verde
   - **Capabilities:** Marcar **Read content**, **Update content**, **Insert content** y **Read comments**
4. Click en **"Submit"**
5. Copiar el **"Internal Integration Secret"** (formato: `ntn_...`)
6. **IMPORTANTE:** Compartir la pagina raiz de proyectos con la integracion:
   - Crear (o abrir) una pagina en Notion llamada **"MV Projects"** (aqui se crearan las paginas de cada proyecto)
   - Click en **"..."** (tres puntos) → **"Connections"** → **"Connect to"**
   - Buscar y seleccionar **"MV Claude Code"**
   - Esto da acceso a la pagina y todas sus sub-paginas
7. Agregar a tu shell profile:

```bash
# Agregar al final de ~/.zshrc
export NOTION_TOKEN="ntn_tu-token-aqui"
```

8. Recargar el terminal:

```bash
source ~/.zshrc
```

**Verificar:** `echo $NOTION_TOKEN` debe mostrar tu token.

### Como funciona la documentacion

- Al crear un proyecto con `/mv-dev:start-project`, Claude crea automaticamente una pagina en Notion con: Overview, Business Logic, API Docs, Components, Architecture y Changelog
- El **link de GitHub** del repo es el identificador unico de cada proyecto
- Si otra persona abre el mismo proyecto, Claude lee la documentacion existente en Notion y continua desde ahi
- Puedes pedir a Claude que actualice la documentacion en cualquier momento

### Nota sobre permisos

La integracion solo puede acceder a las paginas que le compartas explicitamente. Comparte la pagina raiz **"MV Projects"** y todas las sub-paginas heredaran el acceso automaticamente.

---

## 3. Supabase (Base de datos)

Supabase permite a Claude consultar y gestionar la base de datos. El plugin esta configurado en **modo solo lectura** por seguridad.

### Paso a paso

1. Ir a **https://supabase.com/dashboard**
2. Iniciar sesion con la cuenta de MV (pedir acceso al Tech Lead si no tienes)
3. Click en tu **avatar/icono** (esquina superior derecha) → **"Account Preferences"**
4. En el menu lateral, ir a **"Access Tokens"**
5. Click en **"Generate New Token"**
6. Configurar:
   - **Name:** `MV Claude Code - [tu nombre]`
   - **Expiration:** 90 dias (o lo que permita)
7. Click en **"Generate Token"**
8. **Copiar el token inmediatamente** (no se muestra de nuevo)
9. Agregar a tu shell profile:

```bash
# Agregar al final de ~/.zshrc
export SUPABASE_ACCESS_TOKEN="sbp_tu-token-aqui"
```

10. Recargar el terminal:

```bash
source ~/.zshrc
```

**Verificar:** `echo $SUPABASE_ACCESS_TOKEN` debe mostrar tu token.

### Nota sobre seguridad

- El token da acceso a **todos** los proyectos de tu cuenta Supabase
- El plugin esta configurado con `--read-only` para que Claude no pueda modificar datos
- **Nunca** compartas tu token con nadie
- Si tu token se compromete, revocalo inmediatamente en Supabase dashboard

---

## Configuracion rapida (todo junto)

Si ya tienes los 3 tokens, agrega todo de una vez a tu `~/.zshrc`:

```bash
# ============================================
# MV Plugin - Tokens para MCP Servers
# ============================================

# Context7 - Documentacion de librerias
# Obtener en: https://context7.com/dashboard
export CONTEXT7_API_KEY="ctx7sk-..."

# Notion - Documentacion de MV
# Obtener en: https://notion.so/my-integrations
export NOTION_TOKEN="ntn_..."

# Supabase - Base de datos
# Obtener en: https://supabase.com/dashboard → Account → Access Tokens
export SUPABASE_ACCESS_TOKEN="sbp_..."
```

Luego:

```bash
source ~/.zshrc
```

---

## Verificar que todo funciona

Despues de configurar los tokens, reiniciar Claude Code y verificar:

```bash
# 1. Verificar que las variables estan cargadas
echo $CONTEXT7_API_KEY
echo $NOTION_TOKEN
echo $SUPABASE_ACCESS_TOKEN

# 2. Abrir Claude Code en cualquier proyecto
claude

# 3. Dentro de Claude Code, probar cada server:
# - Pedir documentacion de una libreria (usa Context7)
# - Preguntar sobre documentacion en Notion
# - Pedir info sobre tablas en Supabase
```

---

## Servidores que NO necesitan configuracion

Estos MCP servers funcionan sin tokens adicionales:

| Server | Descripcion |
|--------|-------------|
| **memory-keeper** | Memoria persistente entre sesiones. Funciona automaticamente. |
| **playwright** | Automatizacion de browser. Funciona automaticamente. |
| **mv-component-analyzer** | Analisis de componentes. Funciona automaticamente. |

---

## Servidores custom de MV (configuracion adicional)

### mv-db-query (MySQL / PostgreSQL)

Si necesitas acceso directo a una base de datos, agrega estas variables a tu `.env` o `~/.zshrc`:

```bash
# Tipo de base de datos: mysql | postgres (default: mysql)
export DB_ACCESS_TYPE="mysql"

# Credenciales de acceso (pedir al Tech Lead)
export DB_ACCESS_HOST="..."
export DB_ACCESS_PORT="3306"       # 3306 para MySQL, 5432 para PostgreSQL
export DB_ACCESS_USER="..."
export DB_ACCESS_PASSWORD="..."
export DB_ACCESS_NAME="..."
```

---

## Troubleshooting

### "MCP server failed to start"

- Verificar que Node.js 18+ esta instalado: `node --version`
- Verificar que las variables de entorno estan cargadas: `echo $VARIABLE`
- Reiniciar Claude Code completamente

### "Unauthorized" en Context7

- Verificar que el API key es correcto y no ha expirado
- Regenerar en https://context7.com/dashboard si es necesario

### "Unauthorized" en Notion

- Verificar que el token es correcto
- Verificar que las paginas estan compartidas con la integracion
- El token no expira, pero la integracion puede ser desactivada por un admin

### "Unauthorized" en Supabase

- Los tokens de Supabase expiran. Regenerar en el dashboard.
- Verificar que tienes acceso al proyecto correcto

### Un MCP server funciona pero otro no

Cada server es independiente. Si uno falla, los demas siguen funcionando. Puedes usar Claude Code normalmente mientras configuras los que faltan.

---

## Soporte

Si tienes problemas con la configuracion:
1. Consulta con el Tech Lead
2. Revisa los logs de Claude Code (aparecen errores de conexion de MCP servers al iniciar)
3. Abre un issue en el repositorio del plugin
