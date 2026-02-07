#!/bin/bash

source ./common.sh

check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "Added RabbitMQ repo"

dnf install rabbitmq-server -y &>>$LOGS_FILE
validate $? "Installing RabbitMQ server"

systemctl enable rabbitmq-server &>>$LOGS_FILE
systemctl start rabbitmq-server
validate $? "Enabled and started rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGS_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGS_FILE
validate $? "created user and gien permissions"