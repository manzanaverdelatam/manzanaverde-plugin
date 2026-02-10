#!/bin/bash
# Build script para compilar los MCP servers custom del plugin

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🔨 Building MCP servers (bundled standalone)..."

# Build mv-component-analyzer
echo "  📦 Building mv-component-analyzer..."
cd "$PLUGIN_ROOT/servers/mv-component-analyzer"
npm install --silent
npm run build --silent
echo "     ✓ Bundle: $(du -h dist/index.js 2>/dev/null | cut -f1)"

# Build mv-db-query-server
echo "  📦 Building mv-db-query-server..."
cd "$PLUGIN_ROOT/servers/mv-db-query-server"
npm install --silent
npm run build --silent
echo "     ✓ Bundle: $(du -h dist/index.js 2>/dev/null | cut -f1)"

echo "✅ All MCP servers built successfully (standalone bundles, no node_modules needed)!"
