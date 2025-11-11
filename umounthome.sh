#!/bin/bash

USUARIO="${PAM_USER:-$USER}"
MOUNTPOINT="/home/$USUARIO"
LOGFILE="/var/log/unmounthome.log"
HORARIO=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$(date)] Fechando sessão de $PAM_USER (uid=$UID)" >> $LOGFILE

if [ ! -d "$MOUNTPOINT" ]; then
	echo "$HORARIO O arquivo $MOUNTPOINT  nao existe"
	exit 0
fi

if mountpoint -q "$MOUNTPOINT"; then
	echo "$HORARIO Desmontando $MOUNTPOINT >> $LOGFILE"
	umount -l  "$MOUNTPOINT"
else
	echo "$HORARIO $MOUNTPOINT nao esta montado , nada a desmontar" >> $LOGFILE
fi

exit 0	
