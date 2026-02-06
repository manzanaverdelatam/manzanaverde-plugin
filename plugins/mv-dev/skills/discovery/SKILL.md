---
description: Descubrimiento tecnico para proyectos nuevos - analiza un brief de negocio y encuentra APIs, tablas y servicios existentes de MV que puedes reutilizar
---

# Discovery - Descubrimiento Tecnico

Responde consultas de descubrimiento tecnico para proyectos nuevos. Analiza un brief de negocio, consulta la infraestructura existente de MV (APIs, tablas SQL, servicios) y genera un spec tecnico estructurado con todo lo que el proyecto puede reutilizar.

## Cuando usar

- **Antes de empezar un proyecto nuevo** - Para saber que ya existe y que hay que construir
- **Cuando el usuario tiene una idea pero no sabe por donde empezar** - El discovery le da un mapa tecnico
- **Cuando hay un PRD y quieres validar viabilidad** - Confirma que las APIs y datos necesarios existen

## Input

El usuario proporciona un **brief de negocio**. Puede ser:

1. **Una descripcion corta** - Ej: "Quiero hacer una landing donde el usuario ponga su direccion y vea si tiene cobertura, y si la tiene, le muestre el menu del dia"
2. **Una ruta a un archivo PRD** - Ej: `prd.md`, `./docs/prd-campana.md`. Leer el archivo completo con Read.
3. **Una explicacion conversacional** - El usuario describe lo que quiere en lenguaje natural

Si el brief es muy vago, preguntar:
- Que debe hacer el proyecto (funcionalidad principal)
- Quien lo va a usar (usuarios finales, equipo interno, partners)
- Que datos necesita mostrar o procesar

## Proceso de Discovery

### Paso 1: Analizar requerimientos del brief

Del brief del usuario, identificar:

- **Que datos necesita** (usuarios, pedidos, menus, zonas de cobertura, etc.)
- **Que operaciones requiere** (lectura, calculos, agregaciones, escritura)
- **Que tipo de interfaz implica** (dashboard, formulario, landing, reporte, admin panel)
- **Integraciones** - Con que sistemas externos interactua (pagos, delivery, notificaciones, etc.)

### Paso 2: Consultar skills del plugin

Revisar los skills disponibles para obtener informacion real:

| Fuente | Que buscar |
|--------|-----------|
| `/mv-dev:mv-docs` (Notion) | APIs documentadas, tablas SQL, flujos de negocio |
| `/mv-dev:mv-api-consumer` | Referencia general de dominios de API y patrones |
| `/mv-dev:mv-db-queries` | Schema de referencia, tablas bloqueadas, queries seguros |
| `CLAUDE.md` | Restricciones globales, stack, patrones obligatorios |

**Busqueda en Notion (via `/mv-dev:mv-docs`):**

```
Por cada entidad/accion del brief:
  1. Buscar en Notion: "[entidad] API", "[entidad] endpoint"
  2. Si hay resultados: leer la pagina y extraer endpoints, params, responses
  3. Si no hay resultados: buscar con terminos mas amplios
  4. Documentar: que existe, que falta, que necesita adaptacion
```

**Terminos de busqueda sugeridos:**

| Entidad del brief | Buscar en Notion |
|-------------------|-----------------|
| Cobertura/direcciones | "coverage API", "addresses endpoint", "zones" |
| Menu/comidas | "meals API", "menu endpoint", "catalog" |
| Pedidos | "orders API", "orders endpoint" |
| Planes/suscripciones | "plans API", "subscriptions endpoint" |
| Usuarios/perfiles | "users API", "auth endpoint", "profile" |
| Pagos | "payments API", "billing endpoint" |
| Delivery/entregas | "deliveries API", "tracking endpoint", "logistics" |
| Cupones/promos | "coupons API", "promotions endpoint" |

### Paso 3: Buscar tablas SQL relevantes

Usar `/mv-dev:mv-docs` para buscar tablas en Notion:

```
Por cada entidad del brief:
  1. Buscar en Notion: "[entidad] table", "[entidad] schema"
  2. Si hay resultados: extraer columnas principales, tipos, relaciones
  3. Marcar: que tablas existen, cuales necesitaria crear el proyecto
```

**Si el MCP server `mv-db-query` esta disponible**, complementar con queries reales:
- `list_tables` para ver todas las tablas disponibles
- `describe_table` para ver el schema de tablas relevantes
- `get_sample_data` para entender la estructura real de los datos

### Paso 4: Identificar gaps

Comparar lo que el brief necesita vs lo que ya existe:

- **APIs que existen y sirven tal cual** - Solo consumir
- **APIs que existen pero necesitan extension** - Nuevos endpoints o params
- **APIs que NO existen** - Hay que construirlas
- **Tablas que existen** - Solo consultar
- **Tablas que NO existen** - Hay que crearlas (o usar Supabase)
- **Servicios externos necesarios** - Pasarelas de pago, geocoding, email, etc.

### Paso 5: Determinar tipo de proyecto

Basado en los gaps, recomendar:

| Situacion | Tipo de proyecto |
|-----------|-----------------|
| Solo consume APIs existentes, no crea datos | **Frontend** (Next.js + Vercel) |
| Necesita APIs nuevas pero sin UI | **Backend** (Express + Railway) |
| Necesita APIs nuevas + UI | **Monorepo** (Frontend + Backend + Shared) |
| Solo consulta datos existentes | **Frontend** con MCP server de DB |

## Output: Spec Tecnico

Generar el siguiente documento estructurado. **Solo incluir lo relevante al proyecto**, no listar todas las APIs o tablas de MV:

```yaml
# SPEC TECNICO - [Nombre inferido del proyecto]
# Generado por /mv-dev:discovery
# Fecha: [fecha]

## Resumen
# [1-2 lineas describiendo que hace el proyecto]

## Tipo de Proyecto Recomendado
# Frontend | Backend | Monorepo
# Razon: [por que este tipo]

## APIs Disponibles para este Proyecto

### Lectura de Datos
| Endpoint | Metodo | Descripcion | Datos que retorna |
|----------|--------|-------------|-------------------|
| /api/v1/orders | GET | Lista de pedidos | id, status, total, date, country |
| /api/v1/users | GET | Lista de usuarios | id, name, email, country |
# [Solo las relevantes al proyecto]

### Endpoints de Accion (si aplica)
| Endpoint | Metodo | Descripcion |
|----------|--------|-------------|
# [Solo si el proyecto necesita escribir/enviar datos]

## Tablas de BD Relevantes

### [nombre_tabla]
| Campo | Tipo | Descripcion |
|-------|------|-------------|
| id | int | Identificador unico |
# [Solo campos relevantes al proyecto]

### [otra_tabla]
# ...

## APIs que Hay que Construir
# Endpoints nuevos que NO existen y el proyecto necesita crear
# (vacio si solo consume APIs existentes)

- POST /api/v1/[recurso]
  # Descripcion: [que hace]
  # Body: { campo1, campo2 }
  # Requiere: [tabla nueva, servicio externo, etc.]

## Tablas que Hay que Crear
# Tablas nuevas que el proyecto necesita
# (vacio si solo usa tablas existentes)

- [tabla]: campo1 (tipo), campo2 (tipo), ...
  # Descripcion: [para que se usa]

## Restricciones a Considerar
# ⚠️ La BD staging es espejo (solo lectura via mv-db-query)
# ⚠️ [Otras restricciones del CLAUDE.md relevantes al proyecto]
# ⚠️ Rate limits: [si aplica]
# ⚠️ Tablas bloqueadas: payments, user_payment_methods (no se pueden consultar)

## Stack Recomendado
# Framework: Next.js 14+ App Router (consistente con otros proyectos MV)
# UI: Tailwind CSS v4 con tokens MV
# Graficos: Recharts (si necesita visualizaciones)
# Tablas: TanStack Table (si necesita tablas de datos)
# Iconos: Lucide React
# [Agregar solo lo que aplica al proyecto]

## Dependencias Externas
# Servicios de terceros que el proyecto necesita

- [servicio] - [para que se usa]

## Ejemplos de Queries Utiles

```sql
-- [Descripcion de que obtiene]
SELECT [campos]
FROM [tabla]
WHERE [condiciones]
LIMIT 100;
```

## Datos No Encontrados
# Cosas que el brief necesita pero no se encontraron en Notion ni en la BD
# El usuario debe validar con el equipo si existen en otro lugar

- [dato/API/tabla que no se encontro]

## Notas Adicionales
# [Consideraciones especiales]
# [Patrones recomendados para este proyecto]
```

## Reglas

1. **Solo incluir lo relevante** - No listar todas las APIs de MV, solo las que aplican al proyecto
2. **Ser especifico** - Incluir campos exactos, tipos, params y responses, no solo nombres genericos
3. **Incluir ejemplos** - Queries SQL de ejemplo ayudan mucho al desarrollo posterior
4. **Mencionar restricciones** - Siempre recordar que la BD staging es solo lectura y que hay tablas bloqueadas
5. **Recomendar stack consistente** - Alineado con el ecosistema MV (ver CLAUDE.md)

## Despues del Discovery

Informar al usuario:

1. **Resumen ejecutivo** - "Tu proyecto puede reutilizar X APIs y Y tablas existentes. Necesita construir Z endpoints nuevos."
2. **Recomendacion de tipo** - "Recomiendo un proyecto [tipo] porque [razon]."
3. **Siguiente paso** - "Cuando estes listo, ejecuta `/mv-dev:start-project` y usa este spec como referencia."
4. **Guardar el spec** - Preguntar al usuario si quiere guardar el spec como archivo (ej: `discovery-spec.yaml` o `docs/DISCOVERY.md`)

### Integracion con start-project

Si el usuario ejecuta `/mv-dev:start-project` despues del discovery:

- El tipo de proyecto ya esta recomendado (no preguntar de nuevo)
- Las APIs encontradas se pre-documentan en `docs/API.md`
- Las tablas encontradas se pre-documentan en `docs/TABLES.md`
- La logica de negocio del brief se documenta en `docs/BUSINESS_LOGIC.md`
- Los gaps identificados se agregan como TODOs en `docs/CHANGELOG.md`

## Requisitos

- **Notion (`NOTION_TOKEN`)**: Necesario para buscar APIs y tablas reales en la documentacion de MV
- **MCP server `mv-db-query`**: Opcional, mejora el discovery con schemas reales de la BD
- **Sin Notion**: El discovery funciona parcial - usa la referencia general de los skills (`mv-api-consumer`, `mv-db-queries`) pero no puede validar contra la documentacion real. Informar al usuario que configure el token para un discovery completo.

## Ejemplo completo

**Input del usuario:**
```
Quiero hacer una landing donde el usuario ponga su direccion y vea si tiene cobertura de MV.
Si la tiene, le muestre el menu del dia con precios.
Si no la tiene, que pueda dejar su email para avisarle cuando llegue MV a su zona.
```

**Analisis:**
1. Datos: zonas de cobertura, menu/comidas, precios, emails de espera
2. Operaciones: lectura (cobertura, menu), escritura (waitlist)
3. Interfaz: landing page con formulario + resultados

**Consulta a skills:**
- Notion: "coverage API" → encontrado, "meals API" → encontrado, "waitlist" → no encontrado
- mv-db-query: `describe_table("coverage_zones")` → schema real, `describe_table("meals")` → schema real

**Output:**

```yaml
# SPEC TECNICO - mv-landing-cobertura

## Resumen
# Landing page para verificar cobertura de MV por direccion,
# mostrar menu del dia si hay cobertura, o registrar en waitlist si no.

## Tipo de Proyecto Recomendado
# Frontend (Next.js + Vercel + Supabase para waitlist)
# Razon: solo consume APIs existentes, la unica escritura (waitlist)
# se resuelve con una tabla en Supabase sin necesidad de backend propio.

## APIs Disponibles para este Proyecto

### Lectura de Datos
| Endpoint | Metodo | Descripcion | Datos que retorna |
|----------|--------|-------------|-------------------|
| /api/v1/coverage/check | GET | Verifica cobertura | covered, zone, country |
| /api/v1/meals | GET | Menu del dia | name, calories, price, image |

## Tablas de BD Relevantes

### coverage_zones
| Campo | Tipo | Descripcion |
|-------|------|-------------|
| id | int | ID unico |
| country_code | varchar | PE, CO, MX, CL |
| zone_name | varchar | Nombre de la zona |
| active | boolean | Si la zona esta activa |

### meals
| Campo | Tipo | Descripcion |
|-------|------|-------------|
| id | int | ID unico |
| name | varchar | Nombre del plato |
| category | enum | breakfast, lunch, dinner, snack |
| calories | int | Calorias |
| country_code | varchar | Pais |

## Tablas que Hay que Crear

- waitlist: id, email, address, lat, lng, country_code, created_at
  # En Supabase - lista de espera para usuarios sin cobertura

## Restricciones a Considerar
# ⚠️ BD staging es solo lectura
# ⚠️ Necesita Google Maps API para geocoding de direcciones

## Stack Recomendado
# Framework: Next.js 14+ App Router
# UI: Tailwind CSS v4 con tokens MV
# BD nueva: Supabase (tabla waitlist)
# Geocoding: Google Maps API

## Ejemplos de Queries Utiles

```sql
-- Zonas activas por pais
SELECT id, zone_name, country_code
FROM coverage_zones
WHERE country_code = 'PE' AND active = 1
LIMIT 100;

-- Menu del dia para Peru
SELECT id, name, category, calories
FROM meals
WHERE country_code = 'PE'
  AND available_date = CURDATE()
LIMIT 50;
```
```
