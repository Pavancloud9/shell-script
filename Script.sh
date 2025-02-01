#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR: You must have SUDO access"
    exit
fi

dnf install mysql

if [ $? -ne 0 ]
then 
    echo "Installing mysql...FAILURE"
    exit
else
    else "Installing mysql....SUCCESS"
fi

dnf install git

if [ $? -ne 0 ]
then 
    echo "Installing git...FAILURE"
    exit
else
   echo "installing git success"
fi