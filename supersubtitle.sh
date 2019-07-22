#!/bin/bash

IFS='
'

RUTA=/media/series
# Instalar subliminal

#########    subliminal download -l es -f $RUTA

find /media/series -name *.mp4 > videos.log
find /media/series -name *.avi >> videos.log
find /media/series -name *.mkv >> videos.log

#Leer el archivo salida.log linea a linea

while read video ; do
   #rm "$linea"
   #echo "${linea%.*}" elimina todo desde el último punto
   #nombreSinExt="${linea%.*.*}"
   #nombreSinExt="${nombreSinExt##*/}"
   #archivoVideo+=".sincro.srt"
   sincronizado="${video%.*}"
   sincronizado+=".sincro.srt"
   subtitulo="${video%.*}"
   subtitulo+=".es.srt"

   if [ -f "$sincronizado" ]
   then
      echo "Existe $sincronizado"
      DIA=`date +"%d/%m/%Y"`
      HORA=`date +"%H:%M"`
      echo "$DIA - $HORA : Existe $sincronizado" >> salida.log
   else
      echo "No existe $sincronizado"
      if [ -f "$subtitulo" ]
      then
         echo "Existe $subtitulo"
      else
         echo "No existe $subtitulo"
      fi
   fi
done <<< "`cat videos.log`"

