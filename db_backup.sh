#!/bin/bash

APP_NAME="Name"
TIMESTAMP=`date +%F-%H%M`
MONGODUMP_PATH="/usr/bin/mongodump"
BACKUPS_DIR="/path/to/DB_BACKUPS/"
BACKUP_NAME="$APP_NAME-$TIMESTAMP"

# Path to DropboxUploader script
DROPBOX_UPLOADER="/path/to/dropbox_uploader.sh"
# Path in Dropbox store
DROPBOX_PATH="/"

sudo $MONGODUMP_PATH --authenticationDatabase admin -u user -p pass

sudo mkdir -p $BACKUPS_DIR
sudo mv dump $BACKUP_NAME
sudo tar -zcvf $BACKUPS_DIR/$BACKUP_NAME.tgz $BACKUP_NAME
sudo rm -rf $BACKUP_NAME

# remove old backups
find ${BACKUPS_DIR} -type f -mtime +1 -exec rm -f {} \;

# remove old Dropbox folder
$DROPBOX_UPLOADER delete ${DROPBOX_PATH}/DB_BACKUPS

#upload backups to Dropbox
$DROPBOX_UPLOADER upload ${BACKUPS_DIR} ${DROPBOX_PATH}