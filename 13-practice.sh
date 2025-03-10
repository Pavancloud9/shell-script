#!/bin/bash

USERIDDD=$(id -u)

LOGS_FOLDER="/var/log/shellscripts.logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
  if [ $? -ne 0 ]
then
   echo "$1...Failure"
   exit
else
   echo "$2...Success"
fi
}


if [ $USERIDDD -ne 0 ]
then
   echo "ERROR: You must have SUDO access"
   exit
fi

dnf list installed mysql  &>>$LOG_FILE_NAME
if [ $? -ne 0 ]
then
   dnf install mysql -y &>>$LOG_FILE_NAME
   VALIDATE $? "Installing mysql"
else
   echo "Already mysql....Installed"
fi


dnf list installed git &>>$LOG_FILE_NAME
if [ $? -ne 0 ]
then
   dnf install git &>>$LOG_FILE_NAME
   VALIDATE $? "Installing git"
else
   echo "Already Git....Installed"
fi

for software in $@
do
  dnf list installed $software &>>$LOG_FILE_NAME
  if [ $? -ne 0 ]
then
   dnf list install $software -y &>>$LOG_FILE_NAME
   VALIDATE $? "Installing $software"
else
   echo "$software...already installed"
fi
done