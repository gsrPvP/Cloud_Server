#!/bin/bash
HOMEDIR="/home/$1"
echo "$HOMEDIR$"

#cria o home se não existir
if [ ! -d "$HOMEDIR" ]; then
	mkdir -p "$HOMEDIR"
	chown "$1":"$1" "$HOMEDIR"
	chmod 700 "$HOMEDIR"
	logger "Samba: diretorio home criado automaticamente para $1"
fi

exit 0
