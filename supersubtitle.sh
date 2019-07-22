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
      #DIA=`date +"%d/%m/%Y"`
      #HORA=`date +"%H:%M"`
      #echo "$DIA - $HORA : Existe $sincronizado" >> salida.log
   else
      echo "No existe $sincronizado"
      if [ -f "$subtitulo" ]
      then
         echo "Existe $subtitulo"
         autosubsync $video $subtitulo $sincronizado < /dev/null
         if [ -f $sincronizado ]
         then
            DIA=`date +"%d/%m/%Y"`
            HORA=`date +"%H:%M"`
            echo "$DIA - $HORA : Creado $sincronizado" >> salida.log
	    rm "$subtitulo"
            echo "$DIA - $HORA : Eliminado $subtitulo" >> salida.log
         fi
      else
         echo "No existe $subtitulo"
         subliminal download -l es -f $video
         if [ -f $subtitulo ]
         then
            DIA=`date +"%d/%m/%Y"`
            HORA=`date +"%H:%M"`
            echo "$DIA - $HORA : Descargado $subtitulo" >> salida.log
            autosubsync $video $subtitulo $sincronizado < /dev/null
            if [ -f $sincronizado ]
            then
               DIA=`date +"%d/%m/%Y"`
               HORA=`date +"%H:%M"`
               echo "$DIA - $HORA : Creado $sincronizado" >> salida.log
               rm "$subtitulo"
               echo "$DIA - $HORA : Eliminado $subtitulo" >> salida.log
            fi
         else
            DIA=`date +"%d/%m/%Y"`
            HORA=`date +"%H:%M"`
            echo "$DIA - $HORA : Descarga de subtitulos fallida" >> salida.log
         fi
      fi
   fi
done <<< "`cat videos.log`"

