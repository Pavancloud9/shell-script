#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo "ERROR: you must have sudo access to execute"
    exit
fi

dnf list installed mysql

if [ $? -ne 0 ]
then 
  dnf install mysql

if [ $? -ne 0 ]
then 
   echo "installing mysql...FAILURE"
   exit
else
   echo "installing mysql...SUCCESS"
fi