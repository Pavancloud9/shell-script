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

dnf install nginx -y
VALIDATE $? "Installing nginx"

systemctl enable nginx
VALIDATE $? "Enabling nginx"

systemctl start nginx
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE  $? "Removing default nginx code"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "Unzipping frontend code"

cd usr/share/nginx/html
VALIDATE $? "Moving to html directory"

unzip /tmp/frontend.zip
VALIDATE $? "unzipping frontend code"

cp /home/ec2-user/shell-script/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "copied expense code"

systemctl restart nginx
VALIDATE $? "restarting nginx server"
