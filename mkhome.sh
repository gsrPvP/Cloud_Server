#!/bin/bash

LOGFILE="/var/log/mkhome.log"
USUARIO="$1"
LOCKFILE="/tmp/mkhome_${USUARIO}.lock"
echo "[$(date)] Usuario atual: {$USUARIO}" >> "$LOGFILE"
HOMEDIR="/home/$USUARIO"
echo "$HOMEDIR" >> "$LOGFILE"

# Evita execução duplicada
if [ -f "$LOCKFILE" ]; then
	echo "[$(date)] Execução Ignorada (já em andamento)"
	exit 0
fi
touch "$LOCKFILE"

#cri o home se não existir

exec 1>>/var/log/samba/mkhome.log 2>&1
echo "[$(date)] Criando home para $USUARIO se não existir..."

if [ -d "$HOMEDIR" ]; then
	echo "$[(date)] Home já criado: $HOMEDIR" >> "$LOGFILE"
	rm -f "$LOCKFILE"
	exit 0
fi

echo "[$(date)] Criando home para $USUARIO" >> "$LOGFILE"
mkdir -p "$HOMEDIR"
chown "$USUARIO:$USUARIO" "$HOMEDIR"

rm -f "$LOCKFILE"
exit 0
