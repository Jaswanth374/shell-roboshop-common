#!/bin/bash

source ./common.sh

check_root

dnf install mysql-server -y &>>$LOGS_FILE
validate $? "Installation of mysql"

systemctl enable mysqld &>>$LOGS_FILE
systemctl start mysqld &>>$LOGS_FILE
validate $? "started mysql services"

#set a password through read command

mysql_secure_installation --set-root-pass RoboShop@1
validate $? "set mysql root password"
