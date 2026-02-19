#!/bin/bash
# validate-flutter-patterns.sh
# Valida patrones de Flutter y estandares de MV en archivos Dart
# Se ejecuta automaticamente despues de Write/Edit en archivos .dart

FILE="$1"

if [ -z "$FILE" ]; then
  echo "Uso: validate-flutter-patterns.sh <ruta-al-archivo>"
  exit 1
fi

if [ ! -f "$FILE" ]; then
  exit 0
fi

WARNINGS=()
ERRORS=()
BASENAME=$(basename "$FILE")

# Archivos de tema/tokens: se omiten validaciones de valores hardcodeados
IS_THEME_FILE=false
if [[ "$FILE" == *"app_colors.dart"* ]] || \
   [[ "$FILE" == *"app_theme.dart"* ]] || \
   [[ "$FILE" == *"app_shadows.dart"* ]] || \
   [[ "$FILE" == *"app_typography.dart"* ]] || \
   [[ "$FILE" == *"app_spacing.dart"* ]] || \
   [[ "$FILE" == *"app_borders.dart"* ]]; then
  IS_THEME_FILE=true
fi

# Archivos de DI/inyeccion de dependencias
IS_DI_FILE=false
if [[ "$FILE" == *"_provider.dart"* ]] || \
   [[ "$FILE" == *"_injection.dart"* ]] || \
   [[ "$FILE" == *"_locator.dart"* ]] || \
   [[ "$FILE" == *"_module.dart"* ]] || \
   [[ "$FILE" == *"injection_container"* ]] || \
   [[ "$FILE" == *"service_locator"* ]]; then
  IS_DI_FILE=true
fi

# =============================================================================
# VALIDACION 1: Colores hardcodeados (ERROR CRITICO)
# =============================================================================

if [ "$IS_THEME_FILE" = false ]; then
  # Detectar Color(0xFF...) hardcodeados
  HARDCODED_COLORS=$(grep -n "Color(0x" "$FILE" 2>/dev/null)
  if [ -n "$HARDCODED_COLORS" ]; then
    while IFS= read -r line; do
      ERRORS+=("❌ Color hex hardcodeado en $BASENAME: $line")
      ERRORS+=("   → Usar AppColors.* en lugar de Color(0x...)")
    done <<< "$HARDCODED_COLORS"
  fi
fi

# Detectar Colors.green, Colors.red, etc. genericos de Material
# (Aplica a todos los archivos, incluyendo los de tema, porque siempre deberian usar AppColors)
MATERIAL_COLORS=$(grep -nE "Colors\.(green|red|blue|orange|yellow|purple|pink|teal|cyan|indigo|brown|grey|blueGrey)[^a-zA-Z]" "$FILE" 2>/dev/null)
if [ -n "$MATERIAL_COLORS" ]; then
  while IFS= read -r line; do
    WARNINGS+=("⚠️  Color generico de Material en $BASENAME: $line")
    WARNINGS+=("   → Verificar si debe ser un token de AppColors.*")
  done <<< "$MATERIAL_COLORS"
fi

# =============================================================================
# VALIDACION 2: FontSize hardcodeados (ADVERTENCIA)
# =============================================================================

if [ "$IS_THEME_FILE" = false ]; then
  HARDCODED_FONT=$(grep -nE "fontSize: [0-9]" "$FILE" 2>/dev/null)
  if [ -n "$HARDCODED_FONT" ]; then
    while IFS= read -r line; do
      WARNINGS+=("⚠️  fontSize hardcodeado en $BASENAME: $line")
      WARNINGS+=("   → Usar AppTypography.* (ej: AppTypography.bodyMedium)")
    done <<< "$HARDCODED_FONT"
  fi
fi

# =============================================================================
# VALIDACION 3: Spacing con numeros magicos (ADVERTENCIA)
# =============================================================================

if [ "$IS_THEME_FILE" = false ]; then
  # Detectar EdgeInsets con numeros directos (no variables)
  # Usamos -E para extended regex y un patron mas preciso
  MAGIC_SPACING=$(grep -nE "EdgeInsets\.(all|symmetric|only|fromLTRB)\([^)]*[1-9][0-9]*\.?[0-9]*[^)]*\)" "$FILE" 2>/dev/null | grep -v "AppSpacing\." | grep -v "// OK")
  if [ -n "$MAGIC_SPACING" ]; then
    while IFS= read -r line; do
      WARNINGS+=("⚠️  Spacing con numero magico en $BASENAME: $line")
      WARNINGS+=("   → Preferir AppSpacing.* (ej: AppSpacing.lg = 16.0)")
    done <<< "$MAGIC_SPACING"
  fi
fi

# =============================================================================
# VALIDACION 4: BorderRadius hardcodeados (ADVERTENCIA)
# =============================================================================

if [ "$IS_THEME_FILE" = false ]; then
  HARDCODED_RADIUS=$(grep -nE "BorderRadius\.circular\([1-9][0-9]*" "$FILE" 2>/dev/null | grep -v "AppBorders\." | grep -v "// OK")
  if [ -n "$HARDCODED_RADIUS" ]; then
    while IFS= read -r line; do
      WARNINGS+=("⚠️  BorderRadius hardcodeado en $BASENAME: $line")
      WARNINGS+=("   → Usar AppBorders.* (ej: AppBorders.card, AppBorders.button, AppBorders.input)")
    done <<< "$HARDCODED_RADIUS"
  fi

  # Detectar Radius.circular directo
  HARDCODED_RADIUS2=$(grep -nE "Radius\.circular\([1-9][0-9]*" "$FILE" 2>/dev/null | grep -v "AppBorders\." | grep -v "// OK")
  if [ -n "$HARDCODED_RADIUS2" ]; then
    while IFS= read -r line; do
      WARNINGS+=("⚠️  Radius.circular hardcodeado en $BASENAME: $line")
      WARNINGS+=("   → Usar AppBorders.* en lugar de Radius.circular(...)")
    done <<< "$HARDCODED_RADIUS2"
  fi
fi

# =============================================================================
# VALIDACION 5: SizedBox con numeros magicos (ADVERTENCIA)
# =============================================================================

if [ "$IS_THEME_FILE" = false ]; then
  # Detectar SizedBox(height: N) o SizedBox(width: N) con numeros directos
  MAGIC_SIZEBOX=$(grep -nE "SizedBox\((height|width): [1-9][0-9]*\.?[0-9]*[^A-Za-z]" "$FILE" 2>/dev/null | grep -v "AppSpacing\." | grep -v "// OK")
  if [ -n "$MAGIC_SIZEBOX" ]; then
    while IFS= read -r line; do
      WARNINGS+=("⚠️  SizedBox con numero magico en $BASENAME: $line")
      WARNINGS+=("   → Preferir SizedBox(height: AppSpacing.lg) o AppSpacing.verticalGap()")
    done <<< "$MAGIC_SIZEBOX"
  fi
fi

# =============================================================================
# VALIDACION 6: Logica de negocio en widgets (ADVERTENCIA)
# =============================================================================

# Detectar llamadas al API/HTTP directamente en archivos de widget/screen
if [ "$IS_DI_FILE" = false ] && \
   [[ "$FILE" != *"_repository.dart"* ]] && \
   [[ "$FILE" != *"_repository_impl.dart"* ]] && \
   [[ "$FILE" != *"_service.dart"* ]] && \
   [[ "$FILE" != *"_datasource.dart"* ]]; then
  API_IN_WIDGET=$(grep -nE "(http\.|dio\.|apiClient\.)(get|post|put|delete|patch)\(" "$FILE" 2>/dev/null)
  if [ -n "$API_IN_WIDGET" ]; then
    while IFS= read -r line; do
      WARNINGS+=("⚠️  Posible llamada HTTP directa en $BASENAME: $line")
      WARNINGS+=("   → Las llamadas al API deben ir en Repository o Service, no en widgets")
    done <<< "$API_IN_WIDGET"
  fi
fi

# =============================================================================
# VALIDACION 7: print() en codigo (ADVERTENCIA)
# =============================================================================

PRINT_STATEMENTS=$(grep -nE "^\s*print\(" "$FILE" 2>/dev/null)
if [ -n "$PRINT_STATEMENTS" ]; then
  while IFS= read -r line; do
    WARNINGS+=("⚠️  print() en $BASENAME: $line")
    WARNINGS+=("   → Usar debugPrint() en desarrollo o el logger configurado del proyecto")
  done <<< "$PRINT_STATEMENTS"
fi

# =============================================================================
# VALIDACION 8: Textos de UI en ingles (ADVERTENCIA)
# =============================================================================

# Detectar Text() con strings en ingles obvios (tanto comillas simples como dobles)
ENGLISH_TEXT=$(grep -nE "Text\(['\"]" "$FILE" 2>/dev/null | grep -iE "['\"]( )?(Error|Loading\.\.\.|Submit|Cancel|Save|Delete|Confirm|Success|Failed|Warning|Please|Enter|Select)" | head -5)
if [ -n "$ENGLISH_TEXT" ]; then
  while IFS= read -r line; do
    WARNINGS+=("⚠️  Texto de UI posiblemente en ingles en $BASENAME: $line")
    WARNINGS+=("   → Los textos de UI de MV deben estar en espanol")
  done <<< "$ENGLISH_TEXT"
fi

# =============================================================================
# VALIDACION 9: Verificar uso de AppColors en pantallas y widgets (ERROR CRITICO)
# =============================================================================

if [[ "$FILE" == *"_screen.dart"* ]] || [[ "$FILE" == *"_widget.dart"* ]] || [[ "$FILE" == *"_card.dart"* ]]; then
  HAS_APP_COLORS=$(grep -cE "AppColors\." "$FILE" 2>/dev/null || echo "0")
  HAS_HARDCODED=$(grep -cE "Color\(0x|Colors\.(green|red|blue|orange|yellow|purple|pink)" "$FILE" 2>/dev/null || echo "0")

  if [ "$HAS_HARDCODED" -gt 0 ] && [ "$HAS_APP_COLORS" -eq 0 ]; then
    ERRORS+=("❌ $BASENAME usa colores hardcodeados sin importar AppColors")
    ERRORS+=("   → Agregar: import 'package:[proyecto]/core/theme/app_colors.dart';")
  fi
fi

# =============================================================================
# RESULTADO FINAL
# =============================================================================

TOTAL_ERRORS=${#ERRORS[@]}
TOTAL_WARNINGS=${#WARNINGS[@]}

if [ "$TOTAL_ERRORS" -eq 0 ] && [ "$TOTAL_WARNINGS" -eq 0 ]; then
  echo "✅ Flutter patterns OK: $BASENAME"
  exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Validacion Flutter - Manzana Verde"
echo "  Archivo: $BASENAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$TOTAL_ERRORS" -gt 0 ]; then
  echo ""
  echo "ERRORES CRITICOS ($TOTAL_ERRORS):"
  for error in "${ERRORS[@]}"; do
    echo "  $error"
  done
fi

if [ "$TOTAL_WARNINGS" -gt 0 ]; then
  echo ""
  echo "ADVERTENCIAS ($TOTAL_WARNINGS):"
  for warning in "${WARNINGS[@]}"; do
    echo "  $warning"
  done
fi

echo ""
echo "Referencias:"
echo "  Design tokens:  /mv-dev:flutter-visual-style"
echo "  Arquitectura:   /mv-dev:flutter-architecture"
echo "  Marca:          /mv-dev:flutter-brand-identity"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Solo fallar con exit 1 si hay errores criticos
if [ "$TOTAL_ERRORS" -gt 0 ]; then
  exit 1
fi

exit 0
