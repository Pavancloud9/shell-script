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

dnf module disable nodejs -y
VALIDATE $? "Disabling existing default nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "Enabling nodejs 20"

dnf install nodejs
VALIDATE $? "Installing nodejs"

id expense
if [ $? -ne 0 ]
then
   useradd expense
   VALIDATE $? "adding expense user"
else
   echo "expense user already exists...SKIPPING"

mkdir -p /app

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Downloading code"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip
VALIDATE $? "unzipping zip file"

npm install
VALIDATE $? "Installing dependencies"

cp /home/ec2-user/shell-script/backend.service /etc/systemd/system/backend.service

# prepare mysql schema

dnf install mysql -y
VALIDATE $? "Installing mysql client"

mysql -h mysql.pavancloud9.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
VALIDATE $? "creating schemas and tables in DB server"

systemctl daemon-reload
VALIDATE $? "daemon-reload"

systemctl enable backend
VALIDATE $? "enabling backend"

systemctl restart backend
VALIDATE $? "restarting backend"