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

dnf module disable nodejs -y
VALIDATE $? "disabling default nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "enabling nodejs20"

dnf install nodejs -y
VALIDATE $? "Installing nodejs"

id expense
    if [ $? -ne 0 ]
then
    useradd expense
    VALIDATE $? "adding expense user"
else
   echo "expense user already exists...SKIPPING"
fi

mkdir -p /app
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "downloading application code"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip
VALIDATE $? "unzipping baapplication code"

npm install
VALIDATE $? "installing dependecies"

cp /home/ec2-user/shell-script /etc/systemd/system/backend.service

#Preparing mysql schema

dnf install mysql -y
VALIDATE $? "Installing mysql"

mysql -h mysql.pavancloud9.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
VALIDATE $? "Setting up the transactions schema and tables"

systemctl daemon-reload
VALIDATE $? "daemon-reload"

systemctl enable backend
VALIDATE $? "enabling backend"

systemctl restart backend
VALIDATE $? "daemon-reload"



