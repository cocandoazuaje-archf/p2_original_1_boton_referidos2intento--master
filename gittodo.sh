function xgitpush() {
  # Verifica si se pasó mensaje de commit
  if [ -z "$1" ]; then
    echo "Uso: xgitpush \"mensaje del commit\""
    echo "Ejemplo:"
    echo "  xgitpush \"Corrigiendo errores en login\""
    return 1
  fi

  # Ejecuta flujo completo
  gitr
  gits
  git add .
  git commit -m "$1"
  git push
}