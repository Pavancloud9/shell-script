#!/bin/bash

USERIDDD=$(id -u)

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
  if [ $1 -ne 0 ]
then
   echo "$2... Failure"
   exit
else
   echo "$2... Success"
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

dnf install nginx -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOG_FILE_NAME
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOG_FILE_NAME
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE_NAME
VALIDATE $? "Removing default code"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "Downloading latest code"

cd /usr/share/nginx/html &>>$LOG_FILE_NAME
VALIDATE $? "moving to HTML directory"

unzip /tmp/frontend.zip &>>$LOG_FILE_NAME
VALIDATE $? "unzipping the frontend code"

cp /home/ec2-user/shell-script/expense.config /etc/nginx/default.d/expense.config

systemctl restart nginx &>>$LOG_FILE_NAME
VALIDATE $? "restarting nginx server"

