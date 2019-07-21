#!/bin/bash

IFS='
'

RUTA=/media/series
# Descargue subtitulos de todas las series
# Instalar subliminal

#########    subliminal download -l es -f $RUTA

find /media/series -name *es.srt > salida.log

#Sustituir ruta del espacio para ruta absoluta

#Leer el archivo salida.log linea a linea

while read linea ; do
   #rm "$linea"
   #echo "${linea%.*}" elimina todo desde el último punto
   nombreSinExt="${linea%.*.*}"
   nombreSinExt="${nombreSinExt##*/}"
   echo $nombreSinExt
   echo $linea
   archivoVideo="${linea%.*.*}"
   archivoVideo+=".sincro.srt"
   if [ -f "$archivoVideo" ]
   then
      echo "Existe"
   else
      echo "No existe"
   fi
done <<< "`cat salida.log`"

