#!/bin/bash

USERID=$(id -u)

if [ $USERID ne -0 ]
then
   echo "ERROR: You must have sudo access"
   exit
fi

####################################################

dnf list installed mysql
if [ $? -ne 0 ]
then
dnf install mysql
if [ $? -ne 0 ]
then 
   echo "Installing MYSQL...FAILURE"
else
   echo "Installing MYSQL...SUCCESS"
fi
else
   echo "Installing MYSQL...Already Installed"
fi

###############################################

dnf list installed git

if [ $? -ne 0 ]
then
dnf install git
if [ $? -ne 0 ]
then
   echo "Installing Git...Failure"
else
   echo "Installing Git...SUCCESS"
fi
else
   echo "Installing Git..Already installed"
fi