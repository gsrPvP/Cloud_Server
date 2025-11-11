#!/bin/bash
# Caminho do arquivo PAM principal


ARQ="/etc/pam.d/postlogin"
# Linha a ser adicionada
LINHA="session optional pam_exec.so type=open_session /usr/local/bin/remotelogin.sh"
LOGFILE="/var/log/setupclient.log"
SCRIPT1="remotelogin.sh"
SCRIPT2="umounthome.sh"
IP_SERVER=10.0.1.180
SERVER="dominio.intranet.local"
DOMAIN="intranet.local"
REALM="INTRANET.LOCAL"

echo Copiando Arquivos...
cp $SCRIPT1 /usr/local/bin/$SCRIPT1
cp $SCRIPT2 /usr/local/bin/$SCRIPT2
cp hosts /etc/hosts
cp resolv.conf /etc/resolv.conf

chmod +x /usr/local/bin/$SCRIPT1
chown root:root /usr/local/bin/$SCRIPT1
chmod +x /usr/local/bin/$SCRIPT2
chown root:root /usr/local/bin/$SCRIPT2
echo "Arquivos copiados."

ls /usr/local/bin

echo Arquivos Copiados.
echo " |---------------------------------------|"
echo " Configurando NetworkManager...	"
nmcli c m "Conexão cabeada 1" ipv4.dns "$IP_SERVER"
nmcli c m "Conexão cabeada 1" ipv4.dns-search "$DOMAIN"
nmcli c u "Conexão cabeada 1"
echo "|---------------------------------------|"

read -p "Digite o nome do cliente (EX: tec0101): " CLIENT_NAME
echo hostname : $CLIENT_NAME.$DOMAIN
hostnamectl hostname "$CLIENT_NAME.$DOMAIN"
read -s -p "Digite a senha do Admin: " PASSWD
echo ""

dnf install ipa-client -y
ipa-client-install --enable-dns-updates \
	--mkhomedir \
	--domain="$DOMAIN" \
	--server="$SERVER" \
	--principal="admin"\
	--password=$PASSWD \
    --realm=$REALM \
    --force-join \
	--unattended

if [ $? -eq 0 ]; then
	echo "Instalação IPA concluída com sucesso em $CLIENT_NAME." >> $LOGFILE
   # mv "/etc/pam.d/system-auth" "/etc/pam.d/system-auth.bak"
else
	echo "Erro na instalação do IPA. VERIFICAR LOGS."
	exit 1
fi

echo "Configurando Pam..."
cp -r myprofile /etc/authselect/custom/myprofile
authselect select custom/myprofile with-mkhomedir --force
authselect apply-changes
cp lightdm /etc/pam.d/lightdm
exit 0
