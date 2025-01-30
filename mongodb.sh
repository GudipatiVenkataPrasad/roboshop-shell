#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

R="\e[31m"
G="\e[32m"
N="\e[0m"

echo "script started and executing at $TIMESTAMP" &>>$LOGFILE

VALIDATE()
{

    if [ $1 -ne 0 ]
    then 
        echo  -e "ERROR :: $2..$R failed $N"
        #exit 1
    else 
        echo -e "$2...  $G scuess $N"

    fi
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR :: Please Run This Script with Root Acess $N"
    exit 1
else 
    echo  "your not user "

fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Mongodb repo