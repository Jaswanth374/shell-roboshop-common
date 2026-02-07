#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
mkdir -p $LOGS_FOLDER
MONGODB_HOST="mongodb.jaswanthdevops.online"

check_root() {
if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi
}

validate(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

create_systemuser(){

    id roboshop &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
        validate $? "Creating system user"
    else
        echo -e "Roboshop user already exist ... $Y SKIPPING $N"
    fi

}

nodejs(){

    dnf module disable nodejs -y &>>$LOGS_FILE
    validate $? "Disabling NodeJS Default version"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    validate $? "Enabling NodeJS 20"

    dnf install nodejs -y &>>$LOGS_FILE
    validate $? "Install NodeJS"

    npm install  &>>$LOGS_FILE
    validate $? "Installing dependencies"

}

app_code_install(){

    mkdir -p /app 
    validate $? "Creating app directory"
    curl -o /tmp/$appname.zip https://roboshop-artifacts.s3.amazonaws.com/$appname-v3.zip  &>>$LOGS_FILE
    validate $? "Downloading $appname code"

    cd /app &>>$LOGS_FILE
    validate $? "Moving to app directory"

    rm -rf /app/*
    validate $? "Removing existing code"

    unzip /tmp/$appname.zip &>>$LOGS_FILE
    validate $? "Uzip $appname code"
}

systemd_setup(){

    cp $SCRIPT_DIR/$appname.service /etc/systemd/system/$appname.service
    validate $? "Created systemctl service"

    systemctl daemon-reload
    systemctl enable $appname  &>>$LOGS_FILE
    systemctl start $appname
    validate $? "Starting and enabling $appname"
}

app_restart(){
    systemctl restart $appname
    VALIDATE $? "Restarting $appname"
}
