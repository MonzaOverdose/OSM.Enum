#!/bin/bash
# Esse enumeration é baseado no Linpeas e no Jalesc Compilation Linux.
#Criado por: Monza Overdose MKOSM>:(



C_RESET='\033[0m'
C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_WHITE='\033[1;37m'
C_RESET_SED='\\033[0m'
C_RED_SED='\\033[1;31m'
C_GREEN_SED='\\033[1;32m'
C_YELLOW_SED='\\033[1;33m'
C_WHITE_SED='\\033[1;37m'

function print_err {
    echo -e "${C_RED}[-]${C_RESET} $1"
	echo ""
}

function print_notif {
    echo -e "${C_YELLOW}[!]${C_RESET} $1"
	echo ""
}

function print_success {
    echo -e "${C_GREEN}[+]${C_RESET} $1"
	echo ""
}

function note_highlight {
    echo ""
    echo -e "(${C_YELLOW}highlight${C_RESET} = $1)"
    echo ""
}


echo "#################################################"
echo "#           Informação Básica do Sistema        #"
echo "#################################################"
echo ""
echo "----------------------------"
echo -e "${C_WHITE}Informação do Kernel:${C_RESET}"
echo "----------------------------"
echo ""
echo -e "${C_WHITE}Kernel Release:{C_RESET} $(uname -r)"
kernelver=$(uname -v)
kernelyear=$(echo "$kernelver"| rev | cut -d " " -f 1 | rev)
curryear=(date +%Y)
if [ $(expr $curryear - $kernelyear) -ge 2 ]; then
        kernelver=$(echo "$kernelver" | sed "s/${kernelyear}/$
{C_YELLOW_SED}${kernelyear}${C_RESET_SED}]g"
        echo -e "${C_WHITE}Versão do Kernel:${C_RESET} $kernelver"
        echo ""
fi
echo "----------------------------"
echo -e "${C_WHITE}Disk Usage${C_RESET}"
echo "----------------------------
echo ""
df -h
echo ""
echo ""


echo "#################################################"
echo "#             SECTION: Networking               #"
echo "#################################################"
echo ""

echo "----------------------------"
echo -e ${C_WHITE}INTERFACE DE ENDEREÇO IP${C_RESET}"
echo "----------------------------"
echo ""
if [ -n "$(which ifconfig 2>/dev/null)"]; then
    ifout=$(ifconfig)
    if [ $(echo "$ifout" | grep -o "ient addr:0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}")
        else
            inetaddrs=$(echo "$ifout" | grep -o "inet [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}")
            fi

else
    ifout=$(ip addres show)
    inetaddr=$(echo "$ifout" | grep -o "inet [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}")
fi

while read -r addr; do
ifout=$(echo "$ifout" | sed "s/${addr}/${C_YELLOW_SED}${addr}${C_RESET_SED}/g")
done <<< "$inetaddrs"
echo -e "$ifout"
note_highlight "Endereço IPV4"

echo "----------------------------"
echo -e "${C_WHITE}ARP CACHE${C_RESET}"
echo "----------------------------"
echo ""
cat /proc/net/arp
echo ""

echo "----------------------------"
echo -e "${C_WHITE}ESCUTANDO SOCKETS${C_RESET}"
echo "----------------------------"
echo ""
netstat -auntp -nlpt 2>/dev/null | egrep -v "(LISTEN|udp)"
echo ""

echo "----------------------------"
echo -e "${C_WHITE}DNS E HOSTNAMES${C_RESET}"
echo "----------------------------"
echo ""

echo -e "${C_WHITE}Our Hostname:${C_RESET} $(hostname)"
echo ""
echo -e "${C_WHITE}Name Server Configurados?${C_RESET}"
echo "$(grep "nameserver" /etc/resolv.conf 2>/dev/null)"
echo ""


echo "#################################################"
echo "#          SECTION: Usuarios e Grupos           #"
echo "#################################################"
echo ""

echo "----------------------------"
echo -e "${C_WHITE}USUARIO CORRENTE${C_RESET}"
echo "----------------------------"
echo ""
echo -e "${C_WHITE}USER NAME:${C_RESET} $(whoami)"
echo -e "${C_WHITE}GROUPS:${C_RESET} $(groups)"
echo -e "${C_WHITE}UIDs]GIDs?:${C_RESET} $(id) $(id -u)
echo ""



echo "----------------------------"
echo -e "${C_WHITE}PASSWD SAIDA${C_RESET}"
echo "----------------------------"
echo ""
passwd=$(cat /etc/passwd)
interactiveUsers+$(echo "$passwd" | egrep "(/bin/bash|/bin/csh|/bin/ksh|/bin/sh|/bint/tsch|/bin/zsh")
while read -r line; do
    line=$(echo "$line" | sed "s/\//\\\\\//g")
    passwd=$(echo "$passwd" | sed "s/${line}/${C_YELLOW_SED}${line}${C_RESET_SET}/g")
done <<< "interactiveUsers"
echo -e "$passwd"
note_highlight "Usuários com shells interativas"

echo "----------------------------"
echo -e "${C_WHITE}POPULATED GROUP${C_RESET}"
echo "----------------------------"
echo ""
out=$(cat /etc/group)
echo "GROUP:GRPPASSWD:GID:MEMEBERS"
while read -r group; do
        if [ -n "$(echo "$group" | cut -d ":" -f 4 )" ]; then
                        echo "$group"
        fi
done <<< "$out"
echo ""


echo "----------------------------"
echo -e "${C_WHITE}SESSÕES DE USUÁRIOS RECENTES${C_RESET}"
echo""
if [ -n "$(which last 2>/dev/null)" ] && [ -f "/var/log/wtmp" ]; then
     last -n  10 | grep -v 'wtmp begins"
else
     print_err "O "\last\" Não está disponivel para esse sistema. Saindo...
fi
echo ""

echo "----------------------------"
echo -e "${C_WHITE}LOGINS SSH RECENTES${C_RESET}"
echo "----------------------------"
echo ""
if [ -r "/var/log/secure" ]; then
     logFile="/var/log/secure"
elif [ -r "/var/l.og/authlog" ; then ];
     logFIle="/var/log/secure"
elif [ -r logFile="/var/log/auth.log ; then ];
