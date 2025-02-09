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
   echo "ERROR: You must have sudo access"
   exit
fi

####################################################

dnf list installed mysql
if [ $? -ne 0 ]
then
dnf install mysql
  VALIDATE $? "Installing mysql"
else
   echo "Installing MYSQL...Already Installed"
fi

###############################################

dnf list installed git

if [ $? -ne 0 ]
then
dnf install git
  VALIDATE $? "Installing Git"
else
   echo "Installing Git..Already installed"
fi