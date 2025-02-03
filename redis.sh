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
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE
VALIDATE $? "Install the new version"
dnf module enable redis:remi-6.2 -y &>>$LOGFILE
VALIDATE $? "Enable the redis"
dnf install redis -y &>>$LOGFILE
VALIDATE $? "Install the redis"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$LOGFILE
VALIDATE $? "Allowing remote connections"
systemctl enable redis &>>$LOGFILE
VALIDATE $? "Enable the redis"
systemctl start redis &>>$LOGFILE
VALIDATE $? "start the redis"
