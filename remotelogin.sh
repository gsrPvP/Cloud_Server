#!/bin/bash
USUARIO="${PAM_USER:-$USER}"
SERVER="dominio.intranet.local"
MOUNTPOINT="/home/$USUARIO"
REMOTE_SHARE="//$SERVER/$USUARIO"
OPTIONS="sec=krb5,multiuser,cruid=$(id -u "$USUARIO"),vers=3.0"
#opções = kerberos , multiuser , cruid = id do usuario , smb = 3.0
LOGFILE="/var/log/remotelogin.log"
HORARIO=$(date +"%Y-%m-%d %H:%M:%S")
#
IUSERS=("lightdm" "gdm" "sddm" "gdm-launch-enviroment" "root")
#usuarios invalidos

{
    echo "============================"
    echo "Data: $(date)"
    echo "Usuário PAM: $PAM_USER"
    echo "UID: $(id -u $USUARIO)"
    #id é importante para não precisar do kinit antes do mount!!!
    echo "Variáveis de ambiente:"
    env
    echo "============================"
} >> "$LOGFILE" 


for u in "$IUSERS"; do		
	if [[ "$USUARIO" == "$U" ]]; then
		echo "$USUARIO é um usuario invalido , saindo.." >> $LOGFILE
		exit 0
	fi
done
#verifica se arquivo local existe
if [ ! -d "$MOUNTPOINT" ]; then
	mkdir -p "$MOUNTPOINT"
	chown "$USUARIO":"$USUARIO" "$MOUNTPOINT"
	echo "$HORARIO Samba-home: diretório local criado para $USUARIO" >> $LOGFILE
	chmod 755 "$MOUNTPOINT"
fi
#verifica se esta montado
if mountpoint -q "$MOUNTPOINT"; then
       echo "$HORARIO Samba-Home: $MOUNTPOINT já montado , ignorado" >> $LOGFILE
       exit 0
fi
#tenta montar
mount -t cifs "$REMOTE_SHARE" "$MOUNTPOINT" -o "$OPTIONS"

#Retorna sucesso
if mountpoint -q "$MOUNTPOINT";then
	echo "$HORARIO Samba-Home: $USUARIO montado com sucesso em $MOUNTPOINT" >> $LOGFILE
	exit 0
else
    #retona Erro
	echo "$HORARIO Samba-Home: Falha ao montar "$REMOTE_SHARE" para $USUARIO" >> $LOGFILE
	exit 1
fi



