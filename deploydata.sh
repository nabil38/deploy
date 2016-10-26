#!/bin/bash

if [ -z $1 ] ; then read -p "Enter website local folder name: " FOLDER_NAME; else FOLDER_NAME=$1; fi
if [ ! -z $2 ] ; then DB_NAME=$2; elif [ ! -z $1 ] ; then DB_NAME=$1 ; else read -p "Enter mysql data base name: " DB_NAME; fi
read -p "Enter website domain: " DOMAIN_NAME;

mkdir -p ~/export
if $(mysqldump -hlocalhost -uroot -padmin16idc $DB_NAME > ~/export/$DB_NAME.sql); then
  sed -i -e "s/http:\/\/localhost\/${FOLDER_NAME}/http:\/\/$DOMAIN_NAME/g" ~/export/$DB_NAME.sql
  tar cvzf ~/export/$DB_NAME.sql.tar.gz -C ~/export $DB_NAME.sql
  rm ~/export/$DB_NAME.sql
  echo "base de donnée sauvegardée"
else
  echo "la base de donnée $DB_NAME n'a pu être sauvegardée" && exit 1
fi
[ ! -d "/var/www/${FOLDER_NAME}/IMG" ] && { echo "Le repertoire /var/www/$FOLDER_NAME/IMG n'existe pas" && exit 1; }
tar cvzf ~/export/${FOLDER_NAME}_IMG.tar.gz -C /var/www/${FOLDER_NAME} IMG

echo "transfert vers le serveur de déploiement:"
if (ncftpput -R -u $FTP_DEV_USER -p $FTP_DEV_PASS -P $FTP_DEV_PORT $FTP_DEV_HOST /. ~/export/$DB_NAME.sql.tar.gz); then
  echo "Base de donnée transférée"
else
  echo "le transfert n'a pu s'effectuer, opération interrompue" && exit 1
fi
if (ncftpput -R -v -u $FTP_DEV_USER -p $FTP_DEV_PASS -P $FTP_DEV_PORT $FTP_DEV_HOST /. ~/export/${FOLDER_NAME}_IMG.tar.gz); then
  echo "Images transférées"
else
  echo "le transfert n'a pu s'effectuer, opération interrompue" && exit 1
fi
rm -rf ~/export
exit 0
