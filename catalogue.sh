#!/bin/bash

source ./common.sh
appname=catalogue

check_root
create_systemuser
app_code_install
nodejs
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGS_FILE
validate $? "Copying the mongo.repo"
dnf install mongodb-mongosh -y &>>$LOGS_FILE
validate $? "Install client Mongod in catalogue"

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")') &>>$LOGS_FILE

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOGS_FILE
    validate $? "Loading products"
else
    echo -e "Products already loaded ... $Y SKIPPING $N"
fi

app_restart