#!/bin/bash

IFS='
'

RUTA=/media/series
SALIDA=/home/dietpi/subtitulosRPI/salida.log
LISTA=/home/dietpi/subtitulosRPI/videos.log
SINCRO=/home/dietpi/subtitulosRPI/sincro.log

# Instalar subliminal

#########    subliminal download -l es -f $RUTA

find $RUTA -name *.mp4 > $LISTA
find $RUTA -name *.avi >> $LISTA
find $RUTA -name *.mkv >> $LISTA
sed -i '/Mira lo que/d' $LISTA

#Leer el archivo videos.log linea a linea

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
      if [ -f "$subtitulo" ]
      then
         DIA=`date +"%d/%m/%Y"`
         HORA=`date +"%H:%M"`
         rm $subtitulo
         echo "$DIA - $HORA : Eliminado $subtitulo" >> $SALIDA
      fi
   else
      echo "No existe $sincronizado"
      if [ -f "$subtitulo" ]
      then
         echo "Existe $subtitulo"
         autosubsync $video $subtitulo $sincronizado < /dev/null 2> $SINCRO
         if [ -f $sincronizado ]
         then
            DIA=`date +"%d/%m/%Y"`
            HORA=`date +"%H:%M"`
            echo "$DIA - $HORA : Creado $sincronizado" >> $SALIDA
	         rm "$subtitulo"
            echo "$DIA - $HORA : Eliminado $subtitulo" >> $SALIDA
         fi
         if [[ -s $SINCRO ]]
         then
         rm $sincronizado
         echo "Eliminados subtitulos, no era el subtitulo correcto" >> $SALIDA
         fi
      else
         echo "No existe $subtitulo"
         subliminal download -l es $video
         if [ -f $subtitulo ]
         then
            DIA=`date +"%d/%m/%Y"`
            HORA=`date +"%H:%M"`
            echo "$DIA - $HORA : Descargado $subtitulo" >> $SALIDA
            autosubsync $video $subtitulo $sincronizado < /dev/null 2> $SINCRO
            if [ -f $sincronizado ]
            then
               DIA=`date +"%d/%m/%Y"`
               HORA=`date +"%H:%M"`
               echo "$DIA - $HORA : Creado $sincronizado" >> $SALIDA
               rm "$subtitulo"
               echo "$DIA - $HORA : Eliminado $subtitulo" >> $SALIDA
            fi
            if [[ -s $SINCRO ]]
            then
            rm $sincronizado
            echo "Eliminados subtitulos, no era el subtitulo correcto" >> $SALIDA
            fi
         else
            DIA=`date +"%d/%m/%Y"`
            HORA=`date +"%H:%M"`
            echo "$DIA - $HORA : Descarga de subtitulos fallida $video" >> $SALIDA
         fi
      fi
   fi
done <<< "`cat $LISTA`"

rm $LISTA