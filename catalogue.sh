#!/bin/bash

ID=$(id -u) #checking root user are not 
TIMESTAMP=$(date +%F)
LOGFILE="/tmp/$0-$TIMESTAMP.log" #storing log file

R="\e[31m" # colours assign
G="\e[32m"
N="\e[0m"
Y="\e[33m"
#MONGDB_HOST=mongodb.dwas.shop

echo "script started and executing at $TIMESTAMP" &>>$LOGFILE

VALIDATE()
{
    if [ $1 -ne 0 ]
    then 
        echo  -e "$2..$R failed $N"
        exit 1
    else 
        echo -e "$2...$G scuess $N"

    fi
}

if [ $ID -ne 0 ]  # its checking same root user are not
then 
    echo -e "$R ERROR :: Please Run This Script with Root Acess $N"
    exit 1 # you can give other than Zero
else 
    echo  "you are root user"

fi
dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disable the nodejs"
dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enable the nodejs"
dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing the nodejs applicatio"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "Roboshop user already exists $Y SKYPPING $N"
fi

mkdir -p /app  # Is there ownt create ,otherwise it create
VALIDATE $? "Craeting a directory"
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "Download the application code"
cd /app 
#VALIDATE $? "app"
unzip -o /tmp/catalogue.zip &>> $LOGFILE #-o for overide
VALIDATE $? "Unzip the catalogue file"
npm install &>> $LOGFILE
VALIDATE $? "Installing Dependencies"

cp /home/centos/roboshop-shell/catalogue.services /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "copying catalogue service"
systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "catalogue dameon reload"
systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "Enable the catalogue service"
systemctl start catalogue &>> $LOGFILE
VALIDATE $? "Start the catalogue service"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongodb repo"
dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Installing mongodb client"
mongo --host mongodb.dwas.shop </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "Loading catalogue data into mongodb"
