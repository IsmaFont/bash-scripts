#!/bin/bash 
# restart script
SRVPATH="/home/minecraft/guarida2"
SCRNAME='guarida2'
SRVNAME="Guarida"
	


cd $SRVPATH

case $* in
	\-now)
		sh stop.sh && sh start.sh
		;;
	*)	
		echo "$SRVNAME is restarting in 60 seconds. Throw this with [-now] to skip countdown."
		screen -S "$SCRNAME" -X stuff "say El server se va a reiniciar en 1 min\n"
		seq 21 60 | tac | while read line; do printf "# $line "; sleep 1; done
		echo "[!] T-Minus 20 seconds"
		screen -S "$SCRNAME" -X stuff "say T menos 20 segundos\n"
		sleep 1
		seq 0 19 | tac | while read line; do printf "# $line\n"; sleep 1; done
		screen -S "$SCRNAME" -X stuff "say Guardando y stoppeando el server\n"
		
		echo "Executing stop.sh"
		sh stop.sh && echo "Executing start.sh" && sh start.sh
		;;
esac
