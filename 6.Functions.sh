#!/bin/bash

USERID=$(id -u)

VALIDATE(){
       if [ $1 -ne 0 ]
   then
       echo "$2...FAILURE"
            exit
   else
       echo "$2...SUCCESS"
fi
}

if [ $USERID -ne 0 ]
   then
   echo "ERROR: You must have sudo access to execute"
   exit
fi

dnf list installed mysql

if [ $? -ne 0 ]
then
    dnf install mysql
    VALIDATE $? "installing mysql"
else 
   echo "mysql is already...INSTALLED"
fi

#################################

dnf list installed git

if [ $? -ne 0 ]
then
    dnf install git
    VALIDATE $? "installing git"
else
   echo "Git is already...installed"
fi