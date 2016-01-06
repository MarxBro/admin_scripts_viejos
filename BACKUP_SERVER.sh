#!/bin/bash
######################################################################
# BACKUP Server.
# Script para respaldar carpets claves en un servidor.
# Usar mediante un cronjob, como por ejemplo:
######################################################################

# #!/bin/bash
# . /root/BACKUP_SERVER.sh | mail -s "Log backup" someadmin@mail.com
# * MarxBro - WTFPL.

######################################################################
# Adaptado como el otro un 8 de agosto del 2014 para el server business.
#   VIGILAR !!!!

###########
# CONFIGS #
###########
# Llenar este array con directorios a backapear.
# NOTA: Ojo, es recursivo y /root DEBIESE IR PRIMERO!.
DIRs_paBK=('/root' '/etc' '/home' '/var' '/usr/local/ispconfig')

#BACK UP Rapido -> Solo logs y etc (errores, registros y configs).
DIRs_paBK_Rap=('/var/' '/etc' '/usr/local/ispconfig')
DIR_BACK="Backup"
DATE=`date +%a_%d_%b_%Y_%I_%M_%S_%p_%Z`
SERVER="SERVER_JOB"

######################################################################
# FUNCIONES PPLES.
######################################################################
# Ayudas || chequeos.
function Ayudas {
    echo '
    BackUps Server.

    -h    -> Esta ayuda.
    -r    -> Backup Rapido = /var/log + /etc

    ----------------
    MarxBro.                             ~2013~

    ' &&
    exit $1
}

# Greetings.
function Greetings {
    echo 'Listo!' &&
    echo '----------------------------------------------------------------------'
}

# cvzPF -> ??
function BACK {
    for i in ${!DIRs_paBK[*]}
    do
      
    PATHY_NN=$(echo ${DIRs_paBK[$i]} | sed 's!/!--!g' | sed 's!:!_!g')
    NOMBRE_ARCH_FIN="$SERVER-$PATHY_NN.tar.gz" 
   echo "Back Rapido $SERVER $PATHY_NN -> $NOMBRE_ARCH_FIN..."

    tar -cvzPf "/root/$DIR_BACK/$DATE/$NOMBRE_ARCH_FIN" "${DIRs_paBK[$i]}" --anchored --exclude "/root/$DIR_BACK'/*/*'" &&
    Greetings
    done
}

function BACK_RAP {
    for i in ${!DIRs_paBK_Rap[*]}
    do
      
    PATHY_NN=$(echo ${DIRs_paBK_Rap[$i]} | sed 's!/!--!g' | sed 's!:!_!g')
    RAPIDO="rap"
    NOMBRE_ARCH_FIN_r="$RAP_$SERVER-$PATHY_NN.tar.gz"
    echo "Back Rapido $SERVER $PATHY_NN -> $NOMBRE_ARCH_FIN_r..."

    tar -cvzPf "/root/$DIR_BACK/$DATE/$NOMBRE_ARCH_FIN_r" "${DIRs_paBK_Rap[$i]}" --anchored --exclude "/root/$DIR_BACK'/*/*'" &&
    Greetings
    done

}

# Back MySQL.
function MySql_Todo_bk {

    echo "Dump todas las bases de datos MYSQL..." &&
    mysqldump -u root --password='a15bbf4b0c6883bb8e069af9b7a8aa90' --all-databases > /var/lib/mysql/alldatabases.sql 2> /dev/null


    echo "Backing up $SERVER MySQL Config..." &&
    tar -cvzPf "/root/$DIR_BACK/$DATE/$SERVER-mysql.tar.gz" "/var/lib/mysql" &&
    Greetings
}

function BORRAR_BACK_Viejo {
    PATHY_Vi=$(pwd)
    cd "/root/$DIR_BACK"
    if [ $PATHY_Vi == $(pwd) ]; then
        if [ -z $PATHY_Vi ]; then
            rm -rf .
        fi
    else
        echo "Error en la funcion BORRAR_BACK_Viejo... ignorando y prosiguiendo"
    fi
    cd $PATHY_Vi
}

function CUSTOM_REPORTS {
# Recolectando simple informacion del momento.
    cd /root/$DIR_BACK/$DATE &&
    yum list all > yum_instalados.txt
    service --status-all > services_current.txt
    iptables --list-rules > iptables_reglas.txt
    lsof -P -i -n > conex_actuales.txt
    cat /var/log/httpd/access_log |awk '{print $1}' | sort | uniq -c > visitantes_ips.txt
    getsebool -a > selinux_policies.txt
    ifconfig > ifconfig.txt
    # Usuarios y sesiones.
    last > usuarios_logg.txt
    who >> usuarios_logg.txt
    rwho >> usuarios_logg.txt
}

# Esto funca?
function PERM_MOV {
    chmod -R 755 Backup &&
    chown -R apache:apache Backup &&
    echo
    echo Cambiados los permisos correctamente en la
    echo carpeta destino y todo lo que hay dentro.
    echo
    echo La carpeta FINAL, pesa:
    echo "$(du -sh Backup)"
    echo
    echo donde,
    echo "$(du -sh Backup/*)"
  echo
    echo -----------------------------------------------
    echo                                    Zaijian
    echo -----------------------------------------------
    echo
}


######################################################################
######################################################################

#Chequeo Simple -> ayuda / modo backup.
[[ $1 == "-h" ]] && Ayudas "0"
[[ $1 == "-r" ]] && M="r" # Esto va a ser usado despues.
[ $2 ] && Ayudas "1"

# Crer directorio con nombre de fecha.
echo "Comenzando Backup para $SERVER..." &&
mkdir -p /root/$DIR_BACK/$DATE 2>/dev/null
# Comprobar que este todo en orden...
[ ! -d "/root/$DIR_BACK/$DATE" ] &&
echo "ERROR FATAL: NO existe la carpeta 'Back'." && exit 1

######################################################################
######################################################################

###############
# CODIGO PPAL #
###############
if [[ $M == "r" ]]; then
    echo "Respaldo inicializado.
    Copiando archivos de sistema de paths listados para la opcion rapida...
    " &&
    # Ojo con esto...
    BORRAR_BACK_Viejo
    BACK_RAP
    echo "Respaldando dbs de MySQL..." &&
    MySql_Todo_bk
    CUSTOM_REPORTS
    Greetings
    exit 0
elif [ ! $1 ]; then
    echo "Respaldo inicializado.
    Copiando archivos de sistema de paths listados...
    " &&
    BACK
    echo "Respaldando dbs de MySQL..." &&
    MySql_Todo_bk
    CUSTOM_REPORTS
    Greetings
    exit 0
else
    Ayudas "1"
fi


