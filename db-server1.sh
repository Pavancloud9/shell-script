#!/bin/bash

USERIDDD=$(id -u)

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
  if [ $1 -ne 0 ]
then
   echo "$2...Failure"
   exit
else
   echo "$2...Success"
fi
}

CHECK_ROOT(){
if [ $USERIDDD -ne 0 ]
then
   echo "ERROR: You must have SUDO access"
   exit
fi
}

echo "Script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME 

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "enabling mysql server"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "starting mysqld"

mysql -h mysql.pavancloud9.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE_NAME
if [ $? -ne 0 ]
then
    echo "mysql root password not setup" 
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE_NAME
    VALIDATE $? "setting password"
else
    echo "MySQL Root password already setup ... SKIPPING"
fi