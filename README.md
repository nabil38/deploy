## Introduction
script allowing deployment of local development database and files to a remote deployment FTP server. 
The backed-up data would be used by the dockerBackup image to deploy a newly installed web site
## Install
deploy the script in a choosen location on the development machine and update the .bashrc ou .zshrc or whatever shell you are using adding those lines with your proper informations.
- alias deploy="/location/to/deploydata.sh $1 $2"
- export FTP_DEV_HOST="ftp.server.adress"
- export FTP_DEV_USER="ftp_user"
- export FTP_DEV_PASS="ftp_appsword"
- export FTP_DEV_PORT="ftp_port"

make deploydata.sh executable
- chmod +x /location/to/deploydata.sh

## Usage
deploy [folder_name] [database_name] 

if only one argument is given -> folder_name = database_name

the script compresses and transfers the /var/www/folder_name/IMG folder and the database_name as
- folder_name_IMG.tar.gz
- database_name.sql.tar.gz
