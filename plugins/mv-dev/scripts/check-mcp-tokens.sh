#!/bin/bash
# check-mcp-tokens.sh
# SessionStart hook: detecta tokens MCP faltantes y avisa al usuario al inicio de sesion.
# El stdout de este script se inyecta como contexto para Claude.

MISSING=()
CONFIGURED=()

# Notion - requerido para sync docs
if [ -z "$NOTION_TOKEN" ]; then
  MISSING+=("NOTION_TOKEN (Notion - sync de docs, documentacion general)")
else
  CONFIGURED+=("Notion (NOTION_TOKEN)")
fi

# Supabase - requerido para queries Supabase
if [ -z "$SUPABASE_ACCESS_TOKEN" ]; then
  MISSING+=("SUPABASE_ACCESS_TOKEN (Supabase - bases de datos, migraciones)")
else
  CONFIGURED+=("Supabase (SUPABASE_ACCESS_TOKEN)")
fi

# Context7 - opcional pero con rate limits sin key
if [ -z "$CONTEXT7_API_KEY" ]; then
  MISSING+=("CONTEXT7_API_KEY (Context7 - docs de librerias, funciona con rate limits sin key)")
else
  CONFIGURED+=("Context7 (CONTEXT7_API_KEY)")
fi

# Base de datos - requerido para mv-db-query
if [ -z "$DB_ACCESS_HOST" ] || [ -z "$DB_ACCESS_USER" ] || [ -z "$DB_ACCESS_PASSWORD" ] || [ -z "$DB_ACCESS_NAME" ]; then
  MISSING+=("DB_ACCESS_* (Base de datos - queries a MySQL/PostgreSQL staging)")
else
  CONFIGURED+=("Base de datos (DB_ACCESS_*)")
fi

# Solo mostrar output si hay tokens faltantes
if [ ${#MISSING[@]} -gt 0 ]; then
  echo "[MV Plugin] MCP Tokens Status"
  echo ""

  if [ ${#CONFIGURED[@]} -gt 0 ]; then
    echo "Configurados:"
    for item in "${CONFIGURED[@]}"; do
      echo "  - $item"
    done
    echo ""
  fi

  echo "Faltantes:"
  for item in "${MISSING[@]}"; do
    echo "  - $item"
  done
  echo ""
  echo "IMPORTANTE: Si el usuario acaba de configurar alguno de estos tokens, necesita reiniciar Claude Code (cerrar y abrir) para que los MCP servers se conecten. No hay forma de recargar MCPs en caliente actualmente."
  echo ""
  echo "Para configurar tokens faltantes, guiar al usuario con las instrucciones del CLAUDE.md (seccion 'Tokens no configurados')."
fi

exit 0
