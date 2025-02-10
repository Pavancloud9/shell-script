#!/bin/bash

USERID=$(id -u)

LOGS_FOLDER="/var/log/shellscripts.logs"
LOG_FILE=$( echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
if [ $1 -ne 0 ]
then 
   echo "$2...FAILURE"
   exit
else
   echo "$2...SUCCESS"
fi
}

echo "Script started executing at $TIMESTAMP" &>>$LOG_FILE_NAME

if [ $USERID -ne 0 ]
then
   echo "ERROR: You must have sudo access"
   exit
fi

####################################################

dnf list installed mysql   &>>$LOG_FILE_NAME
if [ $? -ne 0 ]
then
dnf install mysql     &>>$LOG_FILE_NAME
  VALIDATE $? "Installing mysql" 
else
   echo "Installing MYSQL...Already Installed"
fi

###############################################

dnf list installed git     &>>$LOG_FILE_NAME

if [ $? -ne 0 ]
then
dnf install git
  VALIDATE $? "Installing Git"
else
   echo "Installing Git..Already installed"
fi