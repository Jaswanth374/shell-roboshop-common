#!/bin/bash

source ./common.sh

appname=frontend
app_dir=/usr/share/nginx/html
check_root

dnf module disable nginx -y &>>$LOGS_FILE
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y &>>$LOGS_FILE
validate $? "Installing Nginx"

systemctl enable nginx  &>>$LOGS_FILE
systemctl start nginx 
validate $? "Enabled and started nginx"

rm -rf $app_dir/* 
validate $? "Remove default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
cd $app_dir 
unzip /tmp/frontend.zip &>>$LOGS_FILE
validate $? "Downloaded and unzipped frontend"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
validate $? "Copied our nginx conf file"

systemctl restart nginx
validate $? "Restarted Nginx"

