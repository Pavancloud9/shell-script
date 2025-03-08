#!/bin/bash

USERIDD=$(id -u)

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
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
   echo "ERROR:you must have sudo access to perform"
   exit
fi
}

echo "script started executing at: $TIMESTAMP"

dnf module disable nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE_NAME
VALIDATE $? "enabling nodejs20"

dnf install nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing nodejs"

id expense &>>$LOG_FILE_NAME
    if [ $? -ne 0 ]
then
    useradd expense
    VALIDATE $? "adding expense user"
else
   echo "expense user already exists...SKIPPING"
fi

mkdir -p /app &>>$LOG_FILE_NAME
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "downloading application code"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$LOG_FILE_NAME
VALIDATE $? "unzipping backend application code"

npm install &>>$LOG_FILE_NAME
VALIDATE $? "installing dependecies"

cp /home/ec2-user/shell-script /etc/systemd/system/backend.service

#Preparing mysql schema

dnf install mysql -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing mysql"

mysql -h mysql.pavancloud9.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE_NAME
VALIDATE $? "Setting up the transactions schema and tables"

systemctl daemon-reload &>>$LOG_FILE_NAME
VALIDATE $? "daemon-reload"

systemctl enable backend &>>$LOG_FILE_NAME
VALIDATE $? "enabling backend"

systemctl restart backend &>>$LOG_FILE_NAME
VALIDATE $? "daemon-reload"



