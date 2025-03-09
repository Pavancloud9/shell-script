#!/bin/bash

USERIDD=$(id -u)

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $? -ne 0 ]
then
    echo "$2....FAILURE"
    exit
else
    echo "$2....SUCCESS"
fi
}

CHECK_ROOT(){
    if [ $USERIDD -ne 0 ]
then
    echo "ERROR: you must have SUDO access to perform this"
    exit
fi
}

echo "script started executing at $TIMESTAMP"

dnf install nginx -y &>>$LOG_FILE_NAME
VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOG_FILE_NAME
VALIDATE $? "enabling nginx"

systemctl start nginx &>>$LOG_FILE_NAME
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE_NAME
VALIDATE $? "removing default nginx code"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "downloading expense code"

cd /usr/share/nginx/html &>>$LOG_FILE_NAME
VALIDATE $? "moving to nginx directory"

unzip /tmp/frontend.zip &>>$LOG_FILE_NAME
VALIDATE $? "unzipping frontend code"

cp /home/ec2-user/shell-script/expense.conf /etc/nginx/default.d/expense.conf &>>$LOG_FILE_NAME
VALIDATE $? "copied expense code"

systemctl restart nginx &>>$LOG_FILE_NAME
VALIDATE $? "restarting nginx server"

