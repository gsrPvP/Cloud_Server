#!/bin/bash

USER="${PAM_USER:-$USER}"
SERVER="fedora.server.linux"
MOUNTPOINT="/home/$USER"
REMOTE_SHARE="//$SERVER/$USER"
OPTIONS="sec=krb5,multiuser,vers=3.0"

#fazer login e montar o /home/user

#verifica se arquivo local existe

if [ ! -d "$MOUNTPOINT" ]; then
	mkdir -p "$MOUNTPOINT"
	chown "$USER":"$USER" "$MOUNTPOINT"
	chmod 700 "MOUNTPOINT"
	logger "Samba-home: diretório local criado para $USER"
fi
#verifica se esta montado
if mountpoint -q "$MOUNTPOINT"; then
       logger "Samba-Home: $MOUNTPOINT já montado , ignorado"
       exit 0
fi

mount -t cifs "$REMOTE_SHARE" "$MOUNTPOINT" -o "$OPTIONS"

if mountpoint -q "$MOUNTPOINT";then
	logger "Samba-Home: $USER montado com sucesso em $MOUNTPOINT"
	exit 0
else
	logger "Samba-Home: Falha ao montar "$REMOTE_SHARE" para $USER"
	exit 1
fi



