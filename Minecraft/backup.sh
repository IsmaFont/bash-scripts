#!/bin/bash

# Server folder
SRVPATH='/home/minecraft/guarida2'

# Folder in which you'll store your backups ( for ex: /home/minecraft/backups )
BUPSPATH='/home/minecraft/backups'

# Backup filename ( for the sake of simplicity, I suggest you use the mc server name in this field )
BUPNAME='guarida2'

# Server name (for wall message)
SRVNAME='Guarida2'


wall "'Alerta Roberto: $SRVNAME's boutta restart'"

sleep 10

tar -zcvf "$BUPSPATH"/"$BUPNAME"_"$(date +%d-%m-%Y_%H-%M%p)".tar.gz "$SRVPATH"

# tar = crear archivo solido de multiples archivos individuales
# -c = crear archivo
# -z = comprimis archivo con gzip
# -f = espcificas la carpeta en la que se va a escribir ese archivo
# -v = muestra el proceso de archivado
