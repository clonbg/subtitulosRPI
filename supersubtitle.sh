#!/bin/bash

IFS='
'

RUTA=/media/series
SALIDA=/home/dietpi/subtitulosRPI/salida.log
LISTA=/home/dietpi/subtitulosRPI/videos.log
# Instalar subliminal

#########    subliminal download -l es -f $RUTA

find $RUTA -name *.mp4 > $LISTA
find $RUTA -name *.avi >> $LISTA
find $RUTA -name *.mkv >> $LISTA

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
      #echo "$DIA - $HORA : Existe $sincronizado" >> $SALIDA
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
            echo "$DIA - $HORA : Creado $sincronizado" >> $SALIDA
	    rm "$subtitulo"
            echo "$DIA - $HORA : Eliminado $subtitulo" >> $SALIDA
	 else
	echo "else"
         fi
      else
         echo "No existe $subtitulo"
         subliminal download -l es -f $video
         if [ -f $subtitulo ]
         then
            DIA=`date +"%d/%m/%Y"`
            HORA=`date +"%H:%M"`
            echo "$DIA - $HORA : Descargado $subtitulo" >> $SALIDA
            autosubsync $video $subtitulo $sincronizado < /dev/null
            if [ -f $sincronizado ]
            then
               DIA=`date +"%d/%m/%Y"`
               HORA=`date +"%H:%M"`
               echo "$DIA - $HORA : Creado $sincronizado" >> $SALIDA
               rm "$subtitulo"
               echo "$DIA - $HORA : Eliminado $subtitulo" >> $SALIDA
	    else
	    echo "else"
            fi
         else
            DIA=`date +"%d/%m/%Y"`
            HORA=`date +"%H:%M"`
            echo "$DIA - $HORA : Descarga de subtitulos fallida" >> $SALIDA
         fi
      fi
   fi
done <<< "`cat videos.log`"

