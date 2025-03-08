#!/bin/bash

USERIDD=$(id -u)

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
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

CHECK_ROOT(){
   if [ $USERIDD -ne 0 ]
then
   echo "ERROR: You must have sudo access to perform this action"
   exit
fi
}

echo "script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "enabling mysqld"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "starting mysqld"

mysql -h mysql.pavancloud9.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE_NAME

if [ $? -ne 0 ]
then
   echo "MYSQL password has not been setted up" 
   mysql_secure_installation --set-root-pass ExpenseApp@1   
   VALIDATE $? "setting up sql password"
else
   echo "mysql password setup already done..SKIPPING"
fi





