#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
   then
   echo "ERROR: You must have sudo access to execute"
   exit
fi

dnf list installed mysql

if [ $? -ne 0 ]
then
    dnf install mysql
if [ $? -ne 0 ]
then
   echo "Installing mysql...FAILURE"
   exit
else
   echo "Installing mysql...SUCCESS"
fi
else 
   echo "MySQL is already...INSTALLED"
fi