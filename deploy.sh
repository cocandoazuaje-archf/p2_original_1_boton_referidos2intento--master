# PROBLEMAS:
# 1. grep dentro del if necesita redirección correcta
# 2. falta validar si DEPLOYAPP está vacío
# 3. zenity puede devolver vacío si cancelas
# 4. list-applications puede devolver encabezados o varias apps
# 5. xread debe existir como función

echo "**** GENERANDO ..."
mvn clean package || exit 1

mv target/*.war .

open .
xread -p "Presiona Enter para continuar..."

echo "**** CARGANDO VARIABLE ..."
DEPLOYAPP=$(asadmin list-applications | awk 'NR==1 {print $1}')

xread -p "DEPLOYAPP detectado: $DEPLOYAPP"

# Si está vacío
if [ -z "$DEPLOYAPP" ]; then
  DEPLOYAPP=$(zenity --entry \
    --title="Nombre de aplicación" \
    --text="DEPLOYAPP está vacío. Ingresa el nombre:" 2>/dev/null )  
fi

# Si contiene noding
if echo "$DEPLOYAPP" | grep -qi "Nothing*"; then
  DEPLOYAPP=$(zenity --entry \
    --title="Nombre de aplicación" \
    --text="DEPLOYAPP contiene 'noding'. Ingresa un nuevo nombre:" 2>/dev/null ) 
fi

# Validar nuevamente
if [ -z "$DEPLOYAPP" ]; then
  echo "ERROR: DEPLOYAPP vacío"
  exit 1
fi

echo "**** UNDEPLOYAPP: $DEPLOYAPP"
asadmin undeploy "$DEPLOYAPP"

echo "**** DEPLOYAPP: $DEPLOYAPP"
asadmin deploy "/Users/carlosocando/Documentos/prueba2/p2_original_1_boton_referidos2intento--master/referidos2intento-1.0/$DEPLOYAPP.war"

open "http://localhost:4848/common/appServer/serverInstGeneralPe.jsf?instanceName=server"