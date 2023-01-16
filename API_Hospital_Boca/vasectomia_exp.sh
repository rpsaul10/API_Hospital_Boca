#!/bin/sh
#
# GENERACION DOCUMENTO BASECTOMIA (PG1)
# Este documento contiene dos paginas, que serán combinadas al terminar de procesar la información,
# por medio de ImageMagick.
#

############
# Declara los argumentos agregados antes de actuar.
while [ $# -gt 0 ]; do
    if [[ $1 == "--"* ]]; then
        v="${1/--/}"
        declare "$v"="$2"
		echo "$v=$2"
        shift
    fi
    shift
done
############


OCUPACION="${OCUPACION:-SIN TRABAJO}"

## Situacion: Puede suceder que el paciente no tiene hijos.
## Verifica el proceso con una condicion.
if [[ $NUM_HIJOS == 0 ]]; then
	EDAD_MENOR="N./A."
fi

DIA=$(date +'%d')
MES=$(date +'%h')
YEAR=$(date +'%Y')

HORA=$(date +'%H')
MINUTO=$(date +'%M')
FECHA_COMPLETA="$DIA $MES $YEAR"
echo "Comenzando creacion de imagen"

######
# 1 DATOS DE INDENTIFICACION
######

CARPETA="_basectomia"
NOMTEMP="temp$NUMEXPEDIENTE"

convert vas_p1.png -gravity West -pointsize 22 -annotate +790-374 $NUMEXPEDIENTE $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 22 -annotate +270-288 $UNIDAD_MEDICA $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 22 -annotate +320-248 "$UNIDAD_DIRECCION , $UNIDAD_TELEFONO" $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 22 -annotate +150-158 "$NOMPACIENTE" $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 22 -annotate +150-109 "$FECHA_COMPLETA" $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 22 -annotate +150-69 $EDAD $NOMTEMP.png

# Hora de generar el estado civil. Este es generado por un indice, que sera procesado
# por el switch case.
XPOS_PONT=0
case $ESTADO_CIVIL in
	1) XPOS_PONT="+348" ;; # Casado
	2) XPOS_PONT="+466" ;; # Soltero
	3) XPOS_PONT="+598" ;; # Divorciado
	4) XPOS_PONT="+710" ;; # Viudo
	*) XPOS_PONT="+856" # Union Libre
esac

if [[ $ESTADO_CIVIL == 1 ]]; then
	echo "El paciente es soltero, no necesita información de relación."
	NOMBRE_ESPOSA="N./A."
	DUR_RELACION="N./A."
fi

convert $NOMTEMP.png -gravity West -pointsize 22 -annotate $XPOS_PONT-44 "X" $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 22 -annotate +150+16 $ESCOLARIDAD $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 20 -annotate +150+56 "$OCUPACION" $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 20 -annotate +150+98 $REFERENCIA $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 20 -annotate +150+140 $NUM_HIJOS $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 20 -annotate +150+182 $EDAD_MENOR $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 20 -annotate +150+222 "$NOMBRE_ESPOSA" $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 20 -annotate +150+264 "$DUR_RELACION" $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 20 -annotate +150+306 "$DOMICILIO_ACTUAL" $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 20 -annotate +150+348 "$DOMICILIO_TELEFONO" $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 18 -annotate +340+372 "$TRABAJO_ACTUAL" $NOMTEMP.png
convert $NOMTEMP.png -gravity West -pointsize 18 -annotate +250+392 "$TRABAJO_TELEFONO" $NOMTEMP.png

######
# 2 MOTIVO DE SOLICITUD DE PROCEDIMIENTO
######

YPOS_PONT=0
case $MOTIVO_CAUSA_INT_HIJOS in
	1 | 2 | 3)
		XPOS_PONT="+136" ;;
	*)
		XPOS_PONT="+556" ;;
esac

case $MOTIVO_CAUSA_INT_HIJOS in
	1 | 4 ) YPOS_PONT="+478" ;;
	2 | 5 ) YPOS_PONT="+498" ;;
	*) YPOS_PONT="+518" ;;
esac

convert $NOMTEMP.png -gravity West -pointsize 18 -annotate "$XPOS_PONT$YPOS_PONT" "X" $NOMTEMP.png

case $MOTIVO_CAUSA_OPN_PAREJA in
	1) XPOS_PONT="+260" ;;
	2) XPOS_PONT="+526" ;;
	*) XPOS_PONT="+820" ;;
esac
convert $NOMTEMP.png -gravity West -pointsize 18 -annotate "$XPOS_PONT+560" "X" $NOMTEMP.png

case $MOTIVO_CAUSA_PLA_FAMILIAR in
	1) XPOS_PONT="+208" ;;
	2) XPOS_PONT="+336" ;;
	3) XPOS_PONT="+450" ;;
	4) XPOS_PONT="+578" ;;
	5) XPOS_PONT="+680" ;;
	*) XPOS_PONT="+808" ;;
esac
convert $NOMTEMP.png -gravity West -pointsize 18 -annotate "$XPOS_PONT+600" "X" $NOMTEMP.png

# Una vez hecho todo esto, convierte el resultado a un PDF.
convert $NOMTEMP.png vasec_$NUMEXPEDIENTE.pdf
# Borra el archivo temporal, no lo necesitamos.
rm $NOMTEMP.png

echo "terminado"

# /etc/ImageMagick-6/policy.xml, remove PDF
